<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Главная - Спортивные площадки</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/main.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />  <!--  Leaflet CSS -->
    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>  <!-- Leaflet JS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.css">  <!-- MarkerCluster CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.Default.css"> <!-- MarkerCluster Default CSS -->
    <script src="https://unpkg.com/leaflet.markercluster@1.4.1/dist/leaflet.markercluster.js"></script> <!-- MarkerCluster JS -->
</head>
<body>
<div class="app-container">
    <!-- Навигационная панель -->
    <div class="profile-sidebar">

        <ul class="profile-nav">
            <li><a href="/" class="active"><i>🏠</i> Главная</a></li>
            <li><a href="/contacts"><i>📞</i> Контакты проекта</a></li>
            <li><a href="/team"><i>⚽</i> Ближайшие игры</a></li>
        </ul>
    </div>

    <!-- Основное содержимое -->
    <div class="main-content">
        <div class="profile-header">
            <div class="profile-btn-container">
                <button class="profile-btn" id="profileButton">
                    <i class="profile-icon">👤</i>
                    <span class="profile-name">Мой профиль</span>
                </button>
            </div>
        </div>
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
                  <h4>Все фильтры</h4>
                  <#list services as service>
                      <div class="checkbox-item">
                          <input type="checkbox" id="service-${service.id}"
                                 data-service-id="${service.id}" class="service-filter">
                          <label for="service-${service.id}">${service.name}</label>
                      </div>
                  </#list>
              </div>
</div>
</div>
</div>
</div>

<!-- Модальное окно площадки -->
<div class="court-modal" id="courtModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modalCourtTitle"></h3>
            <button class="close-modal" id="closeModal">&times;</button>
        </div>
        <div class="modal-body">
            <div class="court-info">
                <p><i>Адрес:</i><span id="modalCourtAddress"></span></p>
                <p><i>Платно:</i><span id="modalCourtPrice"></span></p>
                <p><i>Коментарий к оплате:</i><span id="modalCourtComment"></span></p>
                <p><i>Телефон:</i><span id="modalCourtPhone"></span></p>
                <p><i>Почта:</i><span id="modalCourtEmail"></span></p>
                <p><i>Освещение:</i><span id="modalCourtLighting"></span></p>
                <p><i>Места:</i><span id="modalCourtSeats"></span></p>
                <p><i>Доступность для людей с ОВЗ:</i><span id="modalCourtDisability"></span></p>
                <div class="court-services" id="courtServicesContainer">
                    <!-- Сюда будут добавляться услуги через JS -->
                </div>
            </div>

            <p id="modalCourtDescription"></p>
        </div>
        <div class="modal-footer">

        </div>
    </div>
</div>

<!-- Футер -->
<footer>
    &copy; Баваб Махмуд 231-361, 2025
</footer>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Инициализация карты
        const map = L.map('courts-map').setView([55.751244, 37.618423], 12);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        // Объект для управления фильтрами и маркерами
        const mapManager = {
            selectedServices: new Set(),
            allMarkers: [],
            markerCluster: L.markerClusterGroup(),

            init: function(courts) {
                map.addLayer(this.markerCluster);
                this.createMarkers(courts);
                this.setupFilterHandlers();
                this.applyFilters();
            },

            createMarkers: function(courts) {
                this.allMarkers = courts.map(court => {
                    const marker = L.marker([court.lat, court.lng]);

                    // Сохраняем данные площадки и нормализованные serviceId
                    marker.courtData = court;
                   marker.serviceIds = court.services.map(s => String(s).toLowerCase().replace(/\s+/g, '-'));

                    marker.bindPopup(`
                        <b>court.title</b><br>
                        court.address<br>
                        Услуги: court.services.join(', ')
                    `);

                    marker.on('click', () => {
                        updateModalContent(court);
                        document.getElementById('courtModal').style.display = 'flex';
                    });

                    return marker;
                });
            },

            setupFilterHandlers: function() {
                document.querySelectorAll('.service-filter').forEach(checkbox => {
                    checkbox.addEventListener('change', (e) => {
                        const serviceId = e.target.dataset.serviceId.toLowerCase().replace(/\s+/g, '-');

                        if (e.target.checked) {
                            this.selectedServices.add(serviceId);
                        } else {
                            this.selectedServices.delete(serviceId);
                        }

                        this.applyFilters();
                    });
                });
            },

            applyFilters: function() {
                this.markerCluster.clearLayers();
                // Если не выбрано ни одного фильтра - показать все
                if (this.selectedServices.size === 0) {
                    this.allMarkers.forEach(marker => {
                        this.markerCluster.addLayer(marker);
                    });
                    return;
                }

                // Фильтруем маркеры по выбранным услугам
                this.allMarkers.forEach(marker => {
                    const hasMatchingService = marker.serviceIds.some(serviceId =>
                        this.selectedServices.has(serviceId)
                    );

                    if (hasMatchingService) {
                        this.markerCluster.addLayer(marker);
                    }
                });
            }
        };

        // Преобразование данных полей из FreeMarker
        const courts = [
            <#list fields as field>
            {
                id: ${field.id?c},
                title: "${field.name?js_string}",
                lat: ${field.x?string.computer},
                lng: ${field.y?string.computer},
                address: "${field.address?js_string}",
                price: "${(field.is_paid!'')?js_string}",
                priceComment: "${(field.paymentComments!'')?js_string}",
                phone: "${(field.phone!'')?js_string}",
                email: "${(field.email!'')?js_string}",
                lighting: "${(field.lighting!'')?js_string}",
                seats: "${(field.seats!'Не указано')?js_string}",
                disability: "${(field.disability!'')?js_string}",
                hours: "${(field.workingHoursWinter!'08:00 - 22:00 ежедневно')?js_string}",
                serviceNames: [
                 <#list field.services as service>
                                    "${service.name}"<#if service_has_next>,</#if>
                                    </#list>
                                ],
                rating: 4.8,
                services: [
                    <#list field.services as service>
                    "${service.id}"<#if service_has_next>,</#if>
                    </#list>
                ],
                description: "Спортивная площадка ${field.name?js_string}, расположенная по адресу ${field.address?js_string}"
            }<#if field_has_next>,</#if>
            </#list>
        ];

        // Инициализация менеджера карты
        mapManager.init(courts);

        // Функция обновления модального окна (без изменений)
        function updateModalContent(court) {
            document.getElementById('modalCourtTitle').textContent = court.title;
            document.getElementById('modalCourtAddress').textContent = court.address;
            document.getElementById('modalCourtPrice').textContent = court.price;
            document.getElementById('modalCourtComment').textContent = court.priceComment;
            document.getElementById('modalCourtPhone').textContent = court.phone;
            document.getElementById('modalCourtEmail').textContent = court.email;
            document.getElementById('modalCourtLighting').textContent = court.lighting;
            document.getElementById('modalCourtSeats').textContent = court.seats;
            document.getElementById('modalCourtDisability').textContent = court.disability;

            // Обновление услуг
            const servicesContainer = document.getElementById('courtServicesContainer');
            servicesContainer.innerHTML = '';
            court.serviceNames.forEach(service => {
                const badge = document.createElement('span');
                badge.className = 'service-badge';
                badge.textContent = service;
                servicesContainer.appendChild(badge);
            });
        }

        // Обработчики событий (без изменений)
        document.getElementById('closeModal').addEventListener('click', function() {
            document.getElementById('courtModal').style.display = 'none';
        });

        document.getElementById('courtModal').addEventListener('click', function(e) {
            if (e.target === this) {
                this.style.display = 'none';
            }
        });

        document.getElementById('profileButton').addEventListener('click', function() {
            window.location.href = '/profile';
        });
    });
</script>
</body>
</html>