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
            <label for="editDate">Дата игры</label>
            <input type="date" id="editDate" name="gameDate">
        </div>
        <div class="form-group">
            <label for="editTime">Время игры</label>
            <input type="time" id="editTime" name="gameTime">
        </div>
        <div class="form-group">
            <label for="editCourt">Спортивная площадка</label>
            <select id="editCourt" name="fieldId">
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
       document.getElementById('createTeamBtn').addEventListener('click', function() {
           document.getElementById('createTeamModal').style.display = 'block';
       });

       // Закрытие модального окна
       document.getElementById('closeModalBtn').addEventListener('click', function() {
           document.getElementById('createTeamModal').style.display = 'none';
       });

       document.getElementById('cancelCreateBtn').addEventListener('click', function() {
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

          // Заполняем форму данными
          document.getElementById('teamId').textContent = team.id;
          document.getElementById('editTeamId').value = team.id;
          document.getElementById('expandedTeamTitle').textContent = team.name;
          document.getElementById('editDate').value = team.gameDate;
          document.getElementById('editTime').value = team.gameTime;
          document.getElementById('editCourt').value = team.field.id || '';

          // Показываем модальное окно
          document.getElementById('overlay').style.display = 'block';
          document.getElementById('teamDetails').style.display = 'block';
      }

       // Закрытие деталей команды
       document.getElementById('cancelEditBtn').addEventListener('click', function() {
           document.getElementById('overlay').style.display = 'none';
           document.getElementById('teamDetails').style.display = 'none';
       });

       // Удаление команды
       document.getElementById('deleteTeamBtn').addEventListener('click', function() {
           const teamId = document.getElementById('editTeamId').value;
           if (confirm('Вы уверены, что хотите удалить эту команду?')) {
               fetch('/delete-team/' + teamId, {
                   method: 'DELETE',
                   headers: {
                       'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]').value
                   }
               })
               .then(response => {
                   if (response.ok) {
                       alert('Команда удалена!');
                       location.reload();
                   }
               })
               .catch(error => console.error('Error:', error));
           }
       });

       // Закрытие модальных окон при клике на overlay
       document.getElementById('overlay').addEventListener('click', function() {
           document.getElementById('overlay').style.display = 'none';
           document.getElementById('teamDetails').style.display = 'none';
           document.getElementById('createTeamModal').style.display = 'none';
       });
</script>
</body>
</html>