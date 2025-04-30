<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ближайшие игры</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/teams.css">
     <meta name="_csrf" content="${_csrf.token}">
      <meta name="_csrf_header" content="${_csrf.headerName}">
</head>
<body>
<!-- Боковая панель навигации -->
<div class="profile-sidebar">
  
    <ul class="profile-nav">
        <li><a href="/"><i>🏠</i> Главная</a></li>
        <li><a href="/contacts"><i>📞</i> Контакты проекта</a></li>
        <li><a href="/myteams"><i>👥</i> Мои команды</a></li>
        <li><a href="/teams" class="active"><i>⚽</i> Ближайшие игры</a></li>
        <li><a href="/my-courts"><i>📍</i> Мои площадки</a></li>
        <li><a href="/my-reviews"><i>✍️</i> Мои отзывы</a></li>

        <li><a href="/logoutPage"><i>🚪</i> Выйти</a></li>
    </ul>
</div>

<!-- Основное содержимое -->
<div class="profile-content">
    <h1>Ближайшие игры</h1>


    <div class="main-content-container">
        <div class="games-container">
            <!-- Карточки игр -->
            <div class="games-grid">
                <#list games as game>
                <div class="game-card" data-game-id="${game.id}">
                <input type="hidden" class="game-id-input" value="${game.id}">


                    <h3>${game.name}</h3>
                    <p><strong>Создатель:</strong> ${game.creator}</p>
                    <p class="players"><strong>Участники:</strong> ${game.players?size}/${game.amount}</p>
                    <p><strong>Площадка:</strong></p>

                    <p><strong>Дата:</strong> ${game.gameDate?string('dd.MM.yyyy')}</p>
                    <p><strong>Время:</strong> ${game.gameTime?string('HH:mm')}</p>
                </div>
            </#list>

            <#if !games?? || games?size == 0>
            <div class="no-games-message">
                На выбранную дату игр не найдено
            </div>
        </#if>
    </div>
</div>

</div>
</div>
</div>

<!-- Модальное окно с деталями игры -->
<div id="gameDetailsModal" class="modal">
  <!-- Форма для отправки данных -->
  <form id="joinTeamForm" method="post" action="/join-team" class="modal-content">
    <input type="hidden" id="modalGameId" name="gameId" required>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

    <div class="modal-header">
      <span class="close-btn" id="closeModalBtn">&times;</span>
      <h2 id="modalGameTitle"></h2>
    </div>

    <div class="modal-body">
      <!-- Все поля сделаны read-only -->
      <p><strong>Создатель:</strong> <span id="modalCreatorName"></span></p>
      <p><strong>Контакт:</strong> <span id="modalCreatorContact"></span></p>
      <p><strong>Площадка:</strong> <span id="modalFieldName"></span></p>
      <p><strong>Адрес:</strong> <span id="modalFieldAddress"></span></p>
      <p><strong>Дата:</strong><span id = "modalGameDateTime"></span></p>
      <p><strong>Время:</strong></p>
      <p><strong>Участники:</strong> <span id="modalPlayersCount"></span></p>

      <div class="participants-list">
        <!-- Список участников будет заполняться динамически -->
      </div>

      <button type="submit" class="join-btn" id="joinGameBtn">Записаться в команду</button>
    </div>
  </form>
</div>

<script>
  // Глобальные переменные
  let games = ${gamesJson?no_esc}; // Инициализация данных из Freemarker
  const currentUserId = ${currentUserId!"null"}; // ID текущего пользователя

  // Функция для проверки, прошла ли уже дата игры
  function isGamePast(gameDate) {
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Сбрасываем время для сравнения только дат
    const gameDateObj = new Date(gameDate);
    return gameDateObj < today;
  }

  // Функция для загрузки данных создателя
  async function loadCreatorData(creatorId, element) {
      if (!creatorId) return null;

      try {
          const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
          const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;

          if (!csrfToken || !csrfHeader) {
              throw new Error('CSRF токен не найден');
          }

          const formData = new URLSearchParams();
          formData.append('creator', creatorId);

          const response = await fetch('/getCreator', {
              method: 'POST',
              headers: {
                  'Content-Type': 'application/x-www-form-urlencoded',
                  [csrfHeader]: csrfToken
              },
              body: formData
          });

          if (!response.ok) throw new Error('Ошибка загрузки данных создателя');

          return await response.json();
      } catch (error) {
          console.error('Ошибка загрузки создателя:', error);
          return null;
      }
  }

  // Функция для загрузки данных площадки
  async function loadFieldData(fieldId, element) {
      if (!fieldId) return null;

      try {
          const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
          const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;

          if (!csrfToken || !csrfHeader) {
              throw new Error('CSRF токен не найден');
          }

          const formData = new URLSearchParams();
          formData.append('id', fieldId);

          const response = await fetch('/get-field', {
              method: 'POST',
              headers: {
                  'Content-Type': 'application/x-www-form-urlencoded',
                  [csrfHeader]: csrfToken
              },
              body: formData
          });

          if (!response.ok) throw new Error('Ошибка загрузки данных площадки');

          return await response.json();
      } catch (error) {
          console.error('Ошибка загрузки площадки:', error);
          return null;
      }
  }

  // Функция обновления карточек игр
  function updateGameCards() {
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      document.querySelectorAll('.game-card').forEach(card => {
          const gameId = parseInt(card.dataset.gameId);
          const game = games.find(g => g.id === gameId);
          if (!game) return;

          // Проверяем дату игры
          const gameDate = new Date(game.gameDate);
          const isPast = gameDate < today;

          if (isPast) {
              // Для прошедших игр
              card.classList.add('past-game');
              card.innerHTML += '<div class="game-status">Состоялась</div>';
              card.style.pointerEvents = 'none';
              card.style.opacity = '0.7';
          } else {
              // Для будущих игр
              const playersCountElement = card.querySelector('.players');
              if (playersCountElement) {
                  const playersCount = game.players ? game.players.length : 0;
                  const maxPlayers = game.amount || 0;
                  playersCountElement.textContent = 'Участники: ' + playersCount + '/' + maxPlayers;
              }
          }
      });
  }

  // Функция загрузки обновленных данных с сервера
  async function refreshGamesData() {
      try {
          const response = await fetch('/api/games');
          if (!response.ok) throw new Error('Ошибка загрузки данных');

          games = await response.json();
          updateGameCards();
          return games;
      } catch (error) {
          console.error('Ошибка при обновлении данных:', error);
          throw error;
      }
  }

  // Функция открытия модального окна с деталями игры
  async function openGameModal(game) {
    if (!game) return;

    // Проверяем дату игры
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const gameDate = new Date(game.gameDate);

    if (gameDate < today) {
        alert('Эта игра уже состоялась');
        return;
    }

    document.getElementById('modalGameId').value = game.id;
    document.getElementById('modalGameTitle').textContent = game.name || 'Название не указано';

    // Загружаем данные создателя
    if (game.creatorId) {
        const creator = await loadCreatorData(game.creatorId, document.body);
        document.getElementById('modalCreatorName').textContent = game.creatorName || 'Не указан';
        document.getElementById('modalCreatorContact').textContent = game.creatorContact || 'Не указан';
    } else {
        document.getElementById('modalCreatorName').textContent = game.creatorName || '';
        document.getElementById('modalCreatorContact').textContent = game.creatorContact || '';
    }

   // Загружаем данные площадки
   if (game.fieldId) {
       // Ищем площадку в списке fields по ID
       const field = fields.find(f => f.id == game.fieldId);

       if (field) {
           document.getElementById('modalFieldName').textContent = field.name || 'Не указана';
           document.getElementById('modalFieldAddress').textContent = field.address || 'Не указан';
       } else {
           // Если площадка не найдена в списке, используем данные из game
           document.getElementById('modalFieldName').textContent = game.fieldName || 'Не указана';
           document.getElementById('modalFieldAddress').textContent = game.fieldAddress || 'Не указан';
       }
   } else {
       // Если нет fieldId, показываем данные напрямую из game
       document.getElementById('modalFieldName').textContent = game.fieldName || 'Не указана';
       document.getElementById('modalFieldAddress').textContent = game.fieldAddress || 'Не указан';
   }

    // Форматируем дату и время
    const formattedDate = game.gameDate ? new Date(game.gameDate).toLocaleDateString('ru-RU', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    }) : 'Дата не указана';

    const formattedTime = game.gameTime || 'Время не указано';
    document.getElementById('modalGameDateTime').textContent = formattedDate+formattedTime;

    document.getElementById('modalPlayersCount').textContent =
      (game.players ? game.players.length : 0) + '/' + game.amount;

    const participantsList = document.querySelector('.participants-list');
    participantsList.innerHTML = '<h4>Список участников:</h4>';

    if (game.players && game.players.length > 0) {
      game.players.forEach(function(player) {
        const participantElement = document.createElement('div');
        participantElement.className = 'participant ' + (player.isCreator ? 'creator' : '');

        var playerHtml = player.name;
        if (player.isCreator) {
          playerHtml += ' (создатель) <span class="contact-info">' + (player.contact || '') + '</span>';
        }
        participantElement.innerHTML = playerHtml;

        participantsList.appendChild(participantElement);
      });
    } else {
      participantsList.innerHTML += '<div class="no-participants">В команде пока нет участников</div>';
    }

    const joinButton = document.getElementById('joinGameBtn');
    if (joinButton) {
      const isParticipant = game.players && game.players.some(function(p) { return p.id === currentUserId; });
      joinButton.disabled = isParticipant;
      joinButton.textContent = isParticipant ? 'Вы уже записаны' : 'Записаться в команду';
    }

    document.getElementById('gameDetailsModal').style.display = 'block';
  }

  // Инициализация обработчиков событий
  function initEventListeners() {
    // Клик по карточке игры (делегирование событий)
    document.addEventListener('click', function(e) {
      const card = e.target.closest('.game-card');
      if (!card || card.classList.contains('past-game')) return;

      const gameId = parseInt(card.dataset.gameId);
      const game = games.find(g => g.id === gameId);
      if (game) {
        openGameModal(game);
      }
    });

    // Остальные обработчики остаются без изменений
    // Отправка формы записи
    var joinForm = document.getElementById('joinTeamForm');
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

          const formData = new URLSearchParams();
          formData.append('gameId', gameId);

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
            const error = await response.json();
            throw new Error(error.message || 'Ошибка сервера');
          }

          document.getElementById('joinGameBtn').disabled = true;
          document.getElementById('joinGameBtn').textContent = 'Вы записаны!';

          await refreshGamesData();

        } catch (error) {
          console.error('Ошибка записи:', error);
          alert(error.message || 'Не удалось записаться в команду');
        }
      });
    }

    // Закрытие модального окна
    var closeBtn = document.getElementById('closeModalBtn');
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
    updateGameCards();
  });
</script>

<style>
  .past-game {
    position: relative;
    opacity: 0.7;
    pointer-events: none;
  }

  .game-status {
    position: absolute;
    top: 10px;
    right: 10px;
    background-color: #f8d7da;
    color: #721c24;
    padding: 5px 10px;
    border-radius: 4px;
    font-weight: bold;
  }
</style>

</body>
</html>