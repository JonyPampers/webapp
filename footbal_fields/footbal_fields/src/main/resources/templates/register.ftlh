<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Регистрация | FootballFields</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/style.css">
</head>
<body>
<div class="container">
    <div class="header">
        <div class="logo">
            <img src="https://i.pinimg.com/736x/53/74/cc/5374cc05417af08e12218c69aaf3374d.jpg" alt="FootballFields Logo">
        </div>
        <h1>Создайте аккаунт</h1>
        <p>Присоединяйтесь к нашему футбольному сообществу</p>
    </div>

    <div class="form-container">
        <form action="/registerPlayer" method="POST" id="registrationForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <label for="username">Имя пользователя</label>
                <input type="text" id="username" name="username" required placeholder="Введите ваш логин">
            </div>

            <div class="form-group">
                <label for="age">Ваш возраст</label>
                <input type="number" id="age" name="age" min="5" max="120" required placeholder="Укажите ваш возраст">
            </div>

            <div class="form-group" id="parentPermissionGroup" style="display: none;">
                <label class="checkbox-label">
                    <input type="checkbox" id="parentPermission" name="parentPermission">
                    <span>Моя мама разрешила мне играть</span>
                </label>
            </div>

            <div class="form-group">
                <label for="password">Пароль</label>
                <input type="password" id="password" name="password" required placeholder="Не менее 8 символов">
            </div>

            <div class="form-group">
                <label for="confirmPassword">Подтвердите пароль</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Повторите пароль">
            </div>

            <div class="form-group">
                <label for="fullName">Полное имя</label>
                <input type="text" id="fullName" name="fullName" placeholder="Иван Иванов">
            </div>

            <div class="form-group">
                <label for="phone">Телефон (или аккаунт в telegram)</label>
                <input type="tel" id="phone" name="phone" placeholder="Необязательное поле">
            </div>

            <#if error??>
            <div class="error-message" style="color: #ff6b6b; margin-bottom: 15px;">
                ${error}
            </div>
        </#if>

        <button type="submit" class="btn">Зарегистрироваться</button>

        <div class="login-link">
            Уже есть аккаунт? <a href="/loginPage">Войдите</a>
        </div>
        </form>
    </div>
</div>

<script>
    // Показываем чекбокс "Мама разрешила" если возраст < 16
    document.getElementById('age').addEventListener('change', function() {
        const age = parseInt(this.value);
        const parentPermissionGroup = document.getElementById('parentPermissionGroup');

        if (age < 16) {
            parentPermissionGroup.style.display = 'block';
            document.getElementById('parentPermission').required = true;
        } else {
            parentPermissionGroup.style.display = 'none';
            document.getElementById('parentPermission').required = false;
        }
    });

    // Валидация формы
    document.getElementById('registrationForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const age = parseInt(document.getElementById('age').value);
        const parentPermission = document.getElementById('parentPermission');

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Пароли не совпадают!');
            document.getElementById('confirmPassword').focus();
            return false;
        }

        if (password.length < 8) {
            e.preventDefault();
            alert('Пароль должен содержать не менее 8 символов');
            document.getElementById('password').focus();
            return false;
        }

        if (age < 16 && !parentPermission.checked) {
            e.preventDefault();
            alert('Для пользователей младше 16 лет требуется разрешение родителей');
            parentPermission.focus();
            return false;
        }

        return true;
    });
</script>

<style>
    .checkbox-label {
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    .checkbox-label input {
        margin-right: 10px;
        width: auto;
    }

    .error-message {
        background: rgba(255, 107, 107, 0.1);
        padding: 10px;
        border-radius: 5px;
        border-left: 3px solid #ff6b6b;
    }
</style>
</body>
</html>