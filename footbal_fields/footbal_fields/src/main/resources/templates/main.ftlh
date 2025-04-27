<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Главная - Спортивные площадки</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
    <link rel="stylesheet" href="/main.css">
</head>
<body>
<div class="app-container">
    <!-- Навигационная панель -->
    <div class="profile-sidebar">
        <div class="logo-sidebar">
            <img src="/images/logo.png" alt="Логотип">
        </div>
        <ul class="profile-nav">
            <li><a href="/" class="active"><i>🏠</i> Главная</a></li>
            <li><a href="/contacts"><i>📞</i> Контакты проекта</a></li>
            <li><a href="/my-teams"><i>👥</i> Мои команды</a></li>
            <li><a href="/upcoming-games"><i>⚽</i> Ближайшие игры</a></li>
            <li><a href="/my-courts"><i>📍</i> Мои площадки</a></li>
            <li><a href="/my-reviews"><i>✍️</i> Мои отзывы</a></li>
            <li><a href="/settings"><i>⚙️</i> Настройки</a></li>
            <li><a href="/logout"><i>🚪</i> Выйти</a></li>
        </ul>
    </div>

    <!-- Основное содержимое -->
    <div class="main-content">
        <div class="page-header">
            <h1>Спортивные площадки</h1>
            <p>Найдите подходящую площадку для игры в вашем городе</p>
        </div>

        <div class="map-container">
            <!-- Карта -->
            <div id="courts-map"></div>

            <!-- Панель фильтров -->
            <div class="filters-panel">
                <h3>Фильтры</h3>

                <div class="search-box">
                    <input type="text" placeholder="Поиск по названию или адресу">
                </div>

                <div class="filter-group">
                    <h4>Тип покрытия</h4>
                    <div class="checkbox-item">
                        <input type="checkbox" id="artificial-turf" checked>
                        <label for="artificial-turf">Искусственный газон</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="parquet" checked>
                        <label for="parquet">Паркет</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="asphalt" checked>
                        <label for="asphalt">Асфальт</label>
                    </div>
                </div>

                <div class="filter-group">
                    <h4>Удобства</h4>
                    <div class="checkbox-item">
                        <input type="checkbox" id="shower" checked>
                        <label for="shower">Душ</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="locker-room" checked>
                        <label for="locker-room">Раздевалка</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="parking" checked>
                        <label for="parking">Парковка</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="lighting" checked>
                        <label for="lighting">Освещение</label>
                    </div>
                </div>

                <div class="filter-group">
                    <h4>Вид спорта</h4>
                    <div class="checkbox-item">
                        <input type="checkbox" id="football" checked>
                        <label for="football">Футбол</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="basketball" checked>
                        <label for="basketball">Баскетбол</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="volleyball" checked>
                        <label for="volleyball">Волейбол</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="tennis" checked>
                        <label for="tennis">Теннис</label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Модальное окно площадки -->
<div class="court-modal" id="courtModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modalCourtTitle">Футбольное поле "Спартак"</h3>
            <button class="close-modal" id="closeModal">&times;</button>
        </div>
        <div class="modal-body">
            <div class="court-info">
                <p><i>📍</i> <span id="modalCourtAddress">ул. Спортивная, 15</span></p>
                <p><i>⏰</i> <span id="modalCourtHours">08:00 - 22:00 ежедневно</span></p>
                <p><i>💵</i> <span id="modalCourtPrice">1000 руб/час</span></p>
                <p><i>📞</i> <span id="modalCourtPhone">+7 (123) 456-78-90</span></p>
                <p><i>⭐</i> Рейтинг: <span id="modalCourtRating">4.8</span>/5</p>

                <div class="court-services" id="courtServicesContainer">
                    <!-- Сюда будут добавляться услуги через JS -->
                </div>
            </div>

            <p id="modalCourtDescription">
                Современное футбольное поле с искусственным покрытием последнего поколения.
                Имеется трибуны на 50 мест, система освещения, раздевалки с душевыми.
                Доступна аренда спортивного инвентаря.
            </p>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" id="bookCourt">Забронировать</button>
            <button class="btn btn-primary" id="viewDetails">Подробнее</button>
        </div>
    </div>
</div>

<!-- Футер -->
<footer>
    &copy; Баваб Махмуд 231-361, 2023
</footer>

<script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
<script src="main.js"></script>
</body>
</html>