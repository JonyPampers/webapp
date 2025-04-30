
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Профиль пользователя</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/profile.css">
</head>
<body>
    <div class="profile-container">
        <!-- Боковая панель навигации -->
        <div class="profile-sidebar">
            <div class="logo-sidebar">
                <img src="/images/logo.png" alt="Логотип">
            </div>
            <ul class="profile-nav">
                <li><a href="/" class="active"><i>🏠</i> Главная</a></li>
                <li><a href="/contacts"><i>📞</i> Контакты проекта</a></li>
                <li><a href="/myteams"><i>👥</i> Мои команды</a></li>
                <li><a href="/teams"><i>⚽</i> Ближайшие игры</a></li>
                <li><a href="/my-courts"><i>📍</i> Мои площадки</a></li>
                <li><a href="/my-reviews"><i>✍️</i> Мои отзывы</a></li>
                <li><a href="/logoutPage"><i>🚪</i> Выйти</a></li>
            </ul>
        </div>

        <!-- Основное содержимое профиля -->
        <div class="profile-content">
            <!-- Заголовок профиля с аватаркой -->
            <div class="profile-header">
                <div class="profile-avatar">
                    <img src="${player.avatarUrl!'/images/default-avatar.png'}" alt="Аватар ${player.name}" class="avatar-img">
                    <form action="/upload-avatar" method="post" enctype="multipart/form-data">
                        <label class="avatar-upload">
                            <input type="file" name="avatar" accept="image/*">
                            <i>✏️</i>
                        </label>
                    </form>
                </div>
                <div class="profile-info">
                    <h2>${player.name}</h2>
                    <p>Участник с ${player.registrationDate?string('dd MMMM yyyy')} · ${player.age} года</p>

                </div>
            </div>

            <!-- Основная информация -->
            <div class="profile-section">
                <h3 class="section-title">Личная информация <button class="edit-btn" id="editPersonalBtn"><i>✏️</i> Редактировать</button></h3>

                <div class="info-grid">
                    <div class="info-card">
                        <div class="info-label">Полное имя</div>
                        <div class="info-value">${player.name!''}</div>
                    </div>

                    <div class="info-card">
                        <div class="info-label">Пол</div>
                        <div class="info-value">
                            <#if player.gender??>
                                    <#if player.gender == "MALE">Мужской
                                    <#elseif player.gender == "FEMALE">Женский
                                    <#else>Не указан
                                    </#if>
                                <#else>
                                    Не указан
                                </#if>
                        </div>
                    </div>
                    <div class="info-card">
                        <div class="info-label">Cтатус</div>
                        <div class="info-value">${player.experience!'Не указан'}</div>
                    </div>
                      <div class="info-grid">
                                        <div class="info-card">
                                            <div class="info-label">Полных лет</div>
                                            <div class="info-value">${player.age!''}</div>
                                        </div>
                </div>

                <!-- Форма редактирования личной информации -->
                <form id="personalForm" class="hidden" action="/updatePersonalInfo" method="post">
                    <input type="hidden" name="_method" value="put"/>
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>

                    <div class="form-row">
                        <label for="fullname">Полное имя</label>
                        <input type="text" id="fullname" name="name" value="${player.name!''}">
                    </div>
                    <div class="form-row">
                        <label for="birthdate">Возраст</label>
                        <input type="number" id="birthdate" name="age" value="${player.age}">
                    </div>
                    <div class="form-row">
                        <label for="gender">Пол</label>
                        <select id="gender" name="gender">
                        <option value="MALE" <#if player.gender?? && player.gender == "MALE">selected</#if>>Мужской</option>
                                <option value="FEMALE" <#if player.gender?? && player.gender == "FEMALE">selected</#if>>Женский</option>
                        </select>
                    </div>
                    <div class="form-row">
                        <label for="level">Статус</label>
                        <select id="level" name="status">
                         <option value="">-- Выберите статус --</option>
                                <option value="Игрок">Игрок</option>
                                <option value="Капитан">Капитан</option>
                                <option value="Зритель">Зритель</option>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn cancel-btn" id="cancelPersonalBtn"><i>✖</i> Отмена</button>
                        <button type="submit" class="btn"><i>✓</i> Сохранить изменения</button>
                    </div>
                </form>
            </div>

            <!-- Контактная информация -->
            <div class="profile-section">
                <h3 class="section-title">Контактная информация <button class="edit-btn" id="editContactBtn"><i>✏️</i> Редактировать</button></h3>

                <div class="info-grid">
                    <div class="info-card">
                        <div class="info-label">Контактная информация</div>
                        <div class="info-value">${player.contact!'Не указан'}</div>
                    </div>

                    <div class="info-card">
                        <div class="info-label">Район</div>
                        <div class="info-value">${player.district!'Не указан'}</div>
                    </div>

                </div>

                <!-- Форма редактирования контактной информации -->
                <form class="edit-form" id="contactForm" action="/update-contacts" method="post">
                 <input type="hidden" name="_method" value="put"/>
                                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    <div class="form-row">
                        <label for="contact">Контактная информация</label>
                        <textarea id="contact" name="contact" rows="3" class="editable-textarea">Ваша контактная информация здесь</textarea>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn cancel-btn" id="cancelContactBtn"><i>✖</i> Отмена</button>
                        <button type="submit" class="btn"><i>✓</i> Сохранить изменения</button>
                    </div>
                </form>
            </div>

            <!-- Безопасность -->
            <div class="profile-section">
                <h3 class="section-title">Безопасность <button class="edit-btn" id="editSecurityBtn"><i>✏️</i> Изменить</button></h3>

                <div class="info-grid">
                    <div class="info-card">
                        <div class="info-label">Пароль</div>
                        <div class="info-value password-field">
                            ********
                            <span class="password-toggle" id="togglePassword">Показать</span>
                        </div>
                    </div>

                </div>

                <!-- Форма изменения пароля -->
                <form class="edit-form" id="securityForm" action="/change-password" method="post">
                    <div class="form-row">
                        <label for="currentPassword">Текущий пароль</label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="form-row">
                        <label for="newPassword">Новый пароль</label>
                        <input type="password" id="newPassword" name="newPassword" required>
                    </div>
                    <div class="form-row">
                        <label for="confirmPassword">Подтвердите новый пароль</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn cancel-btn" id="cancelSecurityBtn"><i>✖</i> Отмена</button>
                        <button type="submit" class="btn"><i>✓</i> Изменить пароль</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="/profile.js"></script>
</body>
</html>