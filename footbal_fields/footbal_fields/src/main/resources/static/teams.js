// Глобальные переменные
let games = ${gamesJson?no_esc};
const currentUserId = ${currentUserId!"null"};

// Функция обновления карточек игр
function updateGameCards() {
    document.querySelectorAll('.game-card').forEach(function(card) {
        const gameId = parseInt(card.dataset.gameId);
        const game = games.find(function(g) { return g.id === gameId; });
        if (!game) return;

        // Обновляем количество игроков
        const playersElement = card.querySelector('.players');
        if (playersElement) {
            const playersCount = game.players ? game.players.length : 0;
            playersElement.textContent = `Участники: ${playersCount}/${game.amount}`;
        }
    });
}

// Функция загрузки обновленных данных с сервера
async function refreshGamesData() {
    try {
        const response = await fetch('/api/games');
        if (!response.ok) throw new Error('Ошибка загрузки данных');

        const updatedGames = await response.json();
        games = updatedGames;
        renderGames(updatedGames);

        return updatedGames;
    } catch (error) {
        console.error('Ошибка при обновлении данных:', error);
        throw error;
    }
}

// Функция фильтрации игр по дате (POST запрос)
async function filterGamesByDate(date) {
    try {
        const gamesContainer = document.querySelector('.games-grid');
        gamesContainer.innerHTML = '<div class="loader">Загрузка...</div>';

        const csrfToken = document.querySelector('meta[name="_csrf"]').content;
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

        const formattedDate = new Date(date).toISOString().split('T')[0];

        const response = await fetch('/get-teams?date=' + encodeURIComponent(formattedDate), {
            method: 'POST',
            headers: {
                [csrfHeader]: csrfToken,
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        });

        if (!response.ok) {
            const error = await response.text();
            throw new Error(error || 'Ошибка сервера');
        }

        const filteredGames = await response.json();
        games = filteredGames;
        renderGames(filteredGames);
    } catch (error) {
        console.error('Ошибка фильтрации:', error);
        alert('Не удалось загрузить игры: ' + error.message);
        renderGames(games);
    }
}

// Функция отрисовки игр
function renderGames(gamesToRender) {
    const gamesContainer = document.querySelector('.games-grid');
    if (!gamesContainer) return;

    gamesContainer.innerHTML = '';

    if (!gamesToRender || gamesToRender.length === 0) {
        gamesContainer.innerHTML = '<div class="no-games-message">На выбранную дату игр не найдено</div>';
        return;
    }

    gamesToRender.forEach(function(game) {
        const gameCard = document.createElement('div');
        gameCard.className = 'game-card';
        gameCard.dataset.gameId = game.id;

        // Форматирование даты
        let gameDate = 'Дата не указана';
        if (game.gameDate) {
            const dateObj = new Date(game.gameDate);
            gameDate = dateObj.toLocaleDateString('ru-RU', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            });
        }

        // Форматирование времени
        let gameTime = 'Время не указано';
        if (game.gameTime) {
            const timeObj = new Date('1970-01-01T' + game.gameTime + 'Z');
            gameTime = timeObj.toLocaleTimeString('ru-RU', {
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        // Получаем название площадки
        let fieldName = 'Не указана';
        if (game.fieldId) {
            const field = document.querySelector(`#courtFilter option[value="${game.fieldId}"]`);
            if (field) fieldName = field.textContent;
        }

        // Формирование HTML
        gameCard.innerHTML = `
            <h3>${game.name || 'Без названия'}</h3>
            <p><strong>Создатель:</strong> ${game.creator || 'Не указан'}</p>
            <p class="players"><strong>Участники:</strong> ${game.players ? game.players.length : 0}/${game.amount}</p>
            <p><strong>Площадка:</strong> ${fieldName}</p>
            <p><strong>Дата:</strong> ${gameDate}</p>
            <p><strong>Время:</strong> ${gameTime}</p>
        `;

        gamesContainer.appendChild(gameCard);
    });

    initGameCardListeners();
}

// Функция открытия модального окна
function openGameModal(game) {
    if (!game) return;

    // Заполнение данных игры
    document.getElementById('modalGameId').value = game.id;
    document.getElementById('modalGameTitle').textContent = game.name || 'Название не указано';
    document.getElementById('modalCreatorName').textContent = game.creator || '';
    document.getElementById('modalCreatorContact').textContent = game.creatorContact || '';
    
    // Получаем информацию о площадке
    let fieldName = 'Не указана';
    let fieldAddress = 'Не указан';
    if (game.fieldId) {
        const field = document.querySelector(`#courtFilter option[value="${game.fieldId}"]`);
        if (field) {
            fieldName = field.textContent;
            // Предполагаем, что адрес хранится в атрибуте data-address
            fieldAddress = field.dataset.address || 'Не указан';
        }
    }
    document.getElementById('modalFieldName').textContent = fieldName;
    document.getElementById('modalFieldAddress').textContent = fieldAddress;

    // Форматирование даты и времени
    let gameDate = 'Дата не указана';
    if (game.gameDate) {
        const dateObj = new Date(game.gameDate);
        gameDate = dateObj.toLocaleDateString('ru-RU');
    }
    let gameTime = 'Время не указано';
    if (game.gameTime) {
        const timeObj = new Date('1970-01-01T' + game.gameTime + 'Z');
        gameTime = timeObj.toLocaleTimeString('ru-RU', {
            hour: '2-digit',
            minute: '2-digit'
        });
    }
    document.getElementById('modalGameDateTime').textContent = `${gameDate}, ${gameTime}`;

    // Обновление счетчика игроков
    document.getElementById('modalPlayersCount').textContent =
        (game.players ? game.players.length : 0) + '/' + game.amount;

    // Заполнение списка участников
    const participantsList = document.querySelector('.participants-list');
    participantsList.innerHTML = '<h4>Список участников:</h4>';

    if (game.players && game.players.length > 0) {
        game.players.forEach(function(player) {
            const participantElement = document.createElement('div');
            participantElement.className = 'participant ' + (player.isCreator ? 'creator' : '');

            let playerHtml = player.name;
            if (player.isCreator) {
                playerHtml += ' (создатель)';
            }
            if (player.contact) {
                playerHtml += ` <span class="contact-info">${player.contact}</span>`;
            }
            participantElement.innerHTML = playerHtml;

            participantsList.appendChild(participantElement);
        });
    } else {
        participantsList.innerHTML += '<div class="no-participants">В команде пока нет участников</div>';
    }

    // Обновление кнопки записи
    const joinButton = document.getElementById('joinGameBtn');
    if (joinButton) {
        const isParticipant = game.players && game.players.some(function(p) { return p.id === currentUserId; });
        joinButton.disabled = isParticipant;
        joinButton.textContent = isParticipant ? 'Вы уже записаны' : 'Записаться в команду';
    }

    // Показ модального окна
    document.getElementById('gameDetailsModal').style.display = 'block';
}

// Инициализация обработчиков для карточек игр
function initGameCardListeners() {
    document.querySelectorAll('.game-card').forEach(function(card) {
        card.addEventListener('click', function() {
            const gameId = parseInt(this.dataset.gameId);
            const game = games.find(function(g) { return g.id === gameId; });
            if (game) {
                openGameModal(game);
            }
        });
    });
}

// Инициализация обработчиков событий
function initEventListeners() {
    // Обработчик фильтра по дате
    const dateFilter = document.getElementById('gameDate');
    if (dateFilter) {
        dateFilter.addEventListener('change', function() {
            if (this.value) {
                filterGamesByDate(this.value);
            } else {
                renderGames(games);
            }
        });
    }

    // Обработчик фильтра по площадке
    const courtFilter = document.getElementById('courtFilter');
    if (courtFilter) {
        courtFilter.addEventListener('change', function() {
            const fieldId = this.value;
            if (fieldId) {
                const filteredGames = games.filter(game => game.fieldId == fieldId);
                renderGames(filteredGames);
            } else {
                renderGames(games);
            }
        });
    }

    // Обработчик формы записи
    const joinForm = document.getElementById('joinTeamForm');
    if (joinForm) {
        joinForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            try {
                if (!confirm('Вы уверены, что хотите записаться в команду?')) {
                    return;
                }

                const gameId = document.getElementById('modalGameId').value;
                if (!gameId) throw new Error('Не выбрана игра для записи');

                const csrfToken = document.querySelector('meta[name="_csrf"]').content;
                const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

                // Создаем URL-encoded данные
                const formData = new URLSearchParams();
                formData.append('gameId', gameId);
                formData.append('_csrf', csrfToken);

                const response = await fetch('/join-team', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        [csrfHeader]: csrfToken
                    },
                    body: formData
                });

                if (response.redirected) {
                    window.location.href = response.url;
                    return;
                }

                if (!response.ok) {
                    const error = await response.text();
                    throw new Error(error || 'Ошибка сервера');
                }

                // Обновление UI после записи
                const joinButton = document.getElementById('joinGameBtn');
                if (joinButton) {
                    joinButton.disabled = true;
                    joinButton.textContent = 'Вы записаны!';
                }

                // Обновление данных
                await refreshGamesData();

            } catch (error) {
                console.error('Ошибка записи:', error);
                alert(error.message || 'Не удалось записаться в команду');
            }
        });
    }

    // Закрытие модального окна
    const closeBtn = document.getElementById('closeModalBtn');
    if (closeBtn) {
        closeBtn.addEventListener('click', function() {
            document.getElementById('gameDetailsModal').style.display = 'none';
        });
    }

    // Клик вне модального окна
    window.addEventListener('click', function(event) {
        if (event.target === document.getElementById('gameDetailsModal')) {
            document.getElementById('gameDetailsModal').style.display = 'none';
        }
    });
}

// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', function() {
    initEventListeners();
    initGameCardListeners();
});