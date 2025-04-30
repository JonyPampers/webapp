<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вход | FootballFields</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/style.css">
</head>
<body>
<div class="container">
    <div class="header">

        <h1>Добро пожаловать!</h1>
        <p>Войдите в свой аккаунт</p>
    </div>

    <div class="form-container">
        <form action="/loginPlayer" method="POST" id="loginForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <#if error??>
            <div class="error-message">
                ${error}
            </div>
        </#if>

        <div class="form-group">
            <label for="username">Имя пользователя</label>
            <input type="text" id="username" name="username" required placeholder="Введите ваш логин">
        </div>

        <div class="form-group">
            <label for="password">Пароль</label>
            <input type="password" id="password" name="password" required placeholder="Введите ваш пароль">

        </div>



        <button type="submit" class="btn">Войти</button>

        <div class="register-link">
            Ещё нет аккаунта? <a href="/registerPage">Зарегистрируйтесь</a>
        </div>
        </form>
    </div>
</div>

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
</style>
</body>
</html>