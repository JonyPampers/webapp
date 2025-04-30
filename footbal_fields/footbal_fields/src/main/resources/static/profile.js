document.addEventListener('DOMContentLoaded', function() {

    // Получаем все кнопки, чтобы применить к ним темный цвет
    const allButtons = document.querySelectorAll('.btn, .edit-btn'); //Включаем .edit-btn в выборку

    // Применение темного текста к кнопкам
    allButtons.forEach(button => {
        button.style.color = 'var(--dark-color)'; // Или любой другой темный цвет
    });

    // Активация форм редактирования
    const editPersonalBtn = document.getElementById('editPersonalBtn');
    const personalForm = document.getElementById('personalForm');
    if (editPersonalBtn) { // Проверка на null
        editPersonalBtn.addEventListener('click', () => {
            personalForm.classList.add('active');
        });
    }

    const editContactBtn = document.getElementById('editContactBtn');
    const contactForm = document.getElementById('contactForm');
    if (editContactBtn) { // Проверка на null
        editContactBtn.addEventListener('click', () => {
            contactForm.classList.add('active');
        });
    }

    const editSecurityBtn = document.getElementById('editSecurityBtn');
    const securityForm = document.getElementById('securityForm');
    if (editSecurityBtn) { // Проверка на null
        editSecurityBtn.addEventListener('click', () => {
            securityForm.classList.add('active');
        });
    }


    // Отмена редактирования
    const cancelPersonalBtn = document.getElementById('cancelPersonalBtn');
    if (cancelPersonalBtn) { // Проверка на null
        cancelPersonalBtn.addEventListener('click', (e) => {
            e.preventDefault();
            personalForm.classList.remove('active');
        });
    }

    const cancelContactBtn = document.getElementById('cancelContactBtn');
    if (cancelContactBtn) { // Проверка на null
        cancelContactBtn.addEventListener('click', (e) => {
            e.preventDefault();
            contactForm.classList.remove('active');
        });
    }

    const cancelSecurityBtn = document.getElementById('cancelSecurityBtn');
    if (cancelSecurityBtn) { // Проверка на null
        cancelSecurityBtn.addEventListener('click', (e) => {
            e.preventDefault();
            securityForm.classList.remove('active');
        });
    }


    // Переключение видимости пароля
    const togglePassword = document.getElementById('togglePassword');
    if (togglePassword) { // Проверка на null
        togglePassword.addEventListener('click', function() {
            const field = this.closest('.password-field');
            const valueField = field.querySelector('.info-value:not(.password-toggle)');

            if (this.textContent === 'Показать') {
                valueField.textContent = 'qwerty123'; // В реальном приложении не показываем пароль
                this.textContent = 'Скрыть';
            } else {
                valueField.textContent = '********';
                this.textContent = 'Показать';
            }
        });
    }

    // Загрузка аватарки (AJAX)
    const avatarUploadInput = document.querySelector('.avatar-upload input');
    if (avatarUploadInput) { // Проверка на null
        avatarUploadInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const formData = new FormData();
                formData.append('avatar', file);

                fetch('/upload-avatar', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.querySelector('.avatar-img').src = data.avatarUrl + '?' + new Date().getTime();
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        });
    }

    // Валидация форм перед отправкой
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!this.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            this.classList.add('was-validated');
        }, false);
    });
});