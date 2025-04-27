document.addEventListener('DOMContentLoaded', function() {
    // Инициализация карты
    const map = L.map('courts-map').setView([55.751244, 37.618423], 12);

    // Добавление слоя карты
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    // Пример маркеров (в реальном приложении данные будут из API)
    const courts = [
        {
            id: 1,
            title: "Футбольное поле 'Спартак'",
            lat: 55.751244,
            lng: 37.618423,
            address: "ул. Спортивная, 15",
            hours: "08:00 - 22:00 ежедневно",
            price: "1000 руб/час",
            phone: "+7 (123) 456-78-90",
            rating: 4.8,
            services: ["Искусственный газон", "Освещение", "Раздевалка", "Парковка"],
            description: "Современное футбольное поле с искусственным покрытием последнего поколения."
        },
        {
            id: 2,
            title: "Баскетбольная площадка 'Олимп'",
            lat: 55.761244,
            lng: 37.628423,
            address: "ул. Ленина, 42",
            hours: "10:00 - 20:00 ежедневно",
            price: "500 руб/час",
            phone: "+7 (987) 654-32-10",
            rating: 4.5,
            services: ["Асфальт", "Освещение"],
            description: "Открытая баскетбольная площадка с новыми кольцами и разметкой."
        }
    ];

    // Добавление маркеров на карту
    courts.forEach(court => {
        const marker = L.marker([court.lat, court.lng]).addTo(map)
            .bindPopup(`<b>${court.title}</b><br>${court.address}`);

        // Обработчик клика по маркеру
        marker.on('click', function() {
            updateModalContent(court);
            document.getElementById('courtModal').style.display = 'flex';
        });
    });

    // Функция обновления содержимого модального окна
    function updateModalContent(court) {
        document.getElementById('modalCourtTitle').textContent = court.title;
        document.getElementById('modalCourtAddress').textContent = court.address;
        document.getElementById('modalCourtHours').textContent = court.hours;
        document.getElementById('modalCourtPrice').textContent = court.price;
        document.getElementById('modalCourtPhone').textContent = court.phone;
        document.getElementById('modalCourtRating').textContent = court.rating;
        document.getElementById('modalCourtDescription').textContent = court.description;

        // Обновление услуг
        const servicesContainer = document.getElementById('courtServicesContainer');
        servicesContainer.innerHTML = '';
        court.services.forEach(service => {
            const badge = document.createElement('span');
            badge.className = 'service-badge';
            badge.textContent = service;
            servicesContainer.appendChild(badge);
        });
    }

    // Закрытие модального окна
    document.getElementById('closeModal').addEventListener('click', function() {
        document.getElementById('courtModal').style.display = 'none';
    });

    // Закрытие при клике вне окна
    document.getElementById('courtModal').addEventListener('click', function(e) {
        if (e.target === this) {
            this.style.display = 'none';
        }
    });

    // Кнопка "Забронировать"
    document.getElementById('bookCourt').addEventListener('click', function() {
        alert('Функция бронирования будет реализована позже');
    });

    // Кнопка "Подробнее"
    document.getElementById('viewDetails').addEventListener('click', function() {
        alert('Переход на страницу площадки');
    });
});