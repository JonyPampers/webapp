<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мои команды</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/myteams.css">
</head>
<body>
<!-- Боковая панель навигации -->
<div class="profile-sidebar">
    <div class="logo-sidebar">
        <img src="/images/logo.png" alt="Логотип">
    </div>
    <ul class="profile-nav">
        <li><a href="/"><i>🏠</i> Главная</a></li>
        <li><a href="/contacts"><i>📞</i> Контакты проекта</a></li>
        <li><a href="/my-teams" class="active"><i>👥</i> Мои команды</a></li>
        <li><a href="/upcoming-games"><i>⚽</i> Ближайшие игры</a></li>
        <li><a href="/my-courts"><i>📍</i> Мои площадки</a></li>
        <li><a href="/my-reviews"><i>✍️</i> Мои отзывы</a></li>
        <li><a href="/settings"><i>⚙️</i> Настройки</a></li>
        <li><a href="/logout"><i>🚪</i> Выйти</a></li>
    </ul>
</div>

<!-- Основное содержимое -->
<div class="profile-content">
    <h1>Мои команды</h1>
    <button class="create-team-btn" id="createTeamBtn">Создать команду</button>

    <div class="teams-grid">
        <!-- Динамическое создание карточек команд -->
        <#list teams as team>
        <div class="team-card" onclick="showTeamDetails(${team.id})">
            <h3>${team.name}</h3>
            <p><strong>Дата:</strong> <span>${team.gameDate?string('dd MMMM yyyy')}</span></p>
            <p><strong>Время:</strong> <span>${team.gameTime?string('HH:mm')}</span></p>
            <p><strong>Площадка:</strong>
                <#if team.fieldId??>
                                <#assign fieldName = fields?filter(f -> f.id == team.fieldId)?first.name!'' />
                                <#if fieldName != ''>
                                    ${fieldName}
                                <#else>
                                    Не указана
                                </#if>
                            <#else>
                                Не указана
                            </#if>
            </p>
        </div>
        </#list>

        <!-- Сообщение если нет команд -->
        <#if !teams?? || teams?size == 0>
        <div class="no-teams-message">
            У вас пока нет созданных команд
        </div>
        </#if>
    </div>
</div>

<!-- Модальное окно создания команды -->
<div id="createTeamModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" id="closeModalBtn">&times;</span>
        <h2>Создать новую команду</h2>
        <form id="createTeamForm" action="/create-team" method="post">
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <div class="form-group">
                <label for="teamName">Название команды</label>
                <input type="text" id="teamName" name="name" required>
            </div>
            <div class="form-group">
                <label for="gameDate">Дата игры</label>
                <input type="date" id="gameDate" name="gameDate" required>
            </div>
            <div class="form-group">
                <label for="gameTime">Время игры</label>
                <input type="time" id="gameTime" name="gameTime"
                           required
                           min="08:00" max="22:00"
                           value="18:00">
            </div>
             <div class="form-group">
                            <label for="playersCount">Количество игроков</label>
                            <input type="number" id="playersCount" name="amount"
                                   min="1" max="20" value="5" required>
                        </div>
            <div class="form-group">
                <label for="court">Спортивная площадка</label>
                <select id="court" name="fieldId" required>
                    <option value="">Выберите площадку</option>
                    <#list fields as field>
                    <option value="${field.id}">${field.name}</option>
                    </#list>
                </select>
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-secondary" id="cancelCreateBtn">Отмена</button>
                <button type="submit" class="btn btn-primary">Создать команду</button>
            </div>
        </form>
    </div>
</div>

<!-- Увеличенная карточка команды -->
<div class="overlay" id="overlay"></div>
<div class="team-card-expanded" id="teamDetails">
    <h2 id="expandedTeamTitle">Команда #<span id="teamId"></span></h2>
    <form id="editTeamForm" action="/update-team" method="post">
        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
        <input type="hidden" id="editTeamId" name="teamId">

        <div class="form-group">
            <label for="editTeamName">Название команды</label>
            <input type="text" class="form-control" id="editTeamName" name="name"
                   placeholder="Введите название команды" required>
        </div>

        <div class="form-group">
            <label for="editDate">Дата игры</label>
            <input type="date" class="form-control" id="editDate" name="date" required>
        </div>

        <div class="form-group">
            <label for="editTime">Время игры</label>
            <input type="time" class="form-control" id="editTime" name="time" required>
        </div>

        <div class="form-group">
            <label for="editAmount">Количество игроков</label>
            <input type="number" class="form-control" id="editAmount" name="amount"
                   min="1" placeholder="Укажите количество" required>
        </div>

        <div class="form-group">
            <label for="editCourt">Спортивная площадка</label>
            <select class="form-control" id="editCourt" name="fieldId" required>
                <#list fields as field>
                <option value="${field.id}">${field.name}</option>
                </#list>
            </select>
        </div>

        <div class="form-actions">
            <button type="button" class="btn btn-secondary" id="cancelEditBtn">Отмена</button>
            <button type="submit" class="btn btn-primary" id="saveChangesBtn">Сохранить изменения</button>
            <button type="button" class="btn btn-danger" id="deleteTeamBtn">Удалить команду</button>
        </div>
    </form>
</div>

<script>
    // Открытие модального окна создания команды
    document.getElementById('createTeamBtn')?.addEventListener('click', function() {
        document.getElementById('createTeamModal').style.display = 'block';
    });

    // Закрытие модального окна
    document.getElementById('closeModalBtn')?.addEventListener('click', function() {
        document.getElementById('createTeamModal').style.display = 'none';
    });

    document.getElementById('cancelCreateBtn')?.addEventListener('click', function() {
        document.getElementById('createTeamModal').style.display = 'none';
    });

    // Храним все команды в глобальной переменной (передается из шаблона)
    const teamsData = {
        <#list teams as team>
        "${team.id}": {
            id: ${team.id},
            name: "${team.name?js_string}",
            gameDate: "${team.gameDate?string('yyyy-MM-dd')}",
            gameTime: "${team.gameTime?string('HH:mm')}",
            field: {
                id: "${team.fieldId!''}",
            }
        }<#if team?has_next>,</#if>
        </#list>
    };

    // Показ деталей команды (без AJAX)
    function showTeamDetails(teamId) {
        const team = teamsData[teamId];

        if (!team) {
            console.error('Team not found:', teamId);
            return;
        }

        // Получаем все элементы перед изменением
        const teamIdElement = document.getElementById('teamId');
        const editTeamIdInput = document.getElementById('editTeamId');
        const teamTitleElement = document.getElementById('expandedTeamTitle');
        const editDateInput = document.getElementById('editDate');
        const editTimeInput = document.getElementById('editTime');
        const editCourtInput = document.getElementById('editCourt');
        const overlayElement = document.getElementById('overlay');
        const teamDetailsElement = document.getElementById('teamDetails');

        // Проверяем существование всех элементов
        if (!teamIdElement || !editTeamIdInput || !teamTitleElement ||
            !editDateInput || !editTimeInput || !editCourtInput ||
            !overlayElement || !teamDetailsElement) {
            console.error('One or more required elements not found');
            return;
        }

        // Заполняем форму данными
        teamIdElement.textContent = team.id;
        editTeamIdInput.value = team.id;
        teamTitleElement.textContent = team.name;
        editDateInput.value = team.gameDate;
        editTimeInput.value = team.gameTime;
        editCourtInput.value = team.field.id || '';

        // Показываем модальное окно
        overlayElement.style.display = 'block';
        teamDetailsElement.style.display = 'block';
    }

    // Закрытие деталей команды
    document.getElementById('cancelEditBtn')?.addEventListener('click', function() {
        const overlay = document.getElementById('overlay');
        const teamDetails = document.getElementById('teamDetails');
        if (overlay) overlay.style.display = 'none';
        if (teamDetails) teamDetails.style.display = 'none';
    });

    // Удаление команды
  document.getElementById('deleteTeamBtn')?.addEventListener('click', function() {
      const teamIdInput = document.getElementById('editTeamId');
      if (!teamIdInput) return;

      const teamId = teamIdInput.value;

      if (confirm('Вы уверены, что хотите удалить эту команду?')) {
          // Создаем FormData для отправки как x-www-form-urlencoded
          const formData = new FormData();
          formData.append('teamId', teamId);

          // Добавляем CSRF-токен
          const csrfToken = document.querySelector('input[name="_csrf"]')?.value;
          if (csrfToken) {
              formData.append('_csrf', csrfToken);
          }

          fetch('/delete-team', {
              method: 'POST',
              body: new URLSearchParams(formData), // Конвертируем в формат x-www-form-urlencoded
              headers: {
                  'Content-Type': 'application/x-www-form-urlencoded'
              }
          })
          .then(response => {
              if (response.redirected) {
                  window.location.href = response.url; // Редирект на "myteams"
              }
          })
          .catch(error => {
              console.error('Error:', error);
              alert('Произошла ошибка при удалении команды');
          });
      }
  });
    // Закрытие модальных окон при клике на overlay
    document.getElementById('overlay')?.addEventListener('click', function() {
        const overlay = document.getElementById('overlay');
        const teamDetails = document.getElementById('teamDetails');
        const createTeamModal = document.getElementById('createTeamModal');

        if (overlay) overlay.style.display = 'none';
        if (teamDetails) teamDetails.style.display = 'none';
        if (createTeamModal) createTeamModal.style.display = 'none';
    });

    // Безопасное назначение обработчиков для карточек команд
    document.querySelectorAll('.team-card').forEach(card => {
        card.addEventListener('click', function() {
            const teamId = this.dataset.teamId;
            if (teamId) {
                showTeamDetails(teamId);
            }
        });
    });
</script>
</body>
</html>