document.addEventListener('DOMContentLoaded', function() {
    // Активация форм редактирования
    document.getElementById('editPersonalBtn')?.addEventListener('click', () => {
        document.getElementById('personalForm').classList.add('active');
    });

    document.getElementById('editContactBtn')?.addEventListener('click', () => {
        document.getElementById('contactForm').classList.add('active');
    });

    document.getElementById('editSecurityBtn')?.addEventListener('click', () => {
        document.getElementById('securityForm').classList.add('active');
    });

    // Отмена редактирования
    document.getElementById('cancelPersonalBtn')?.addEventListener('click', (e) => {
        e.preventDefault();
        document.getElementById('personalForm').classList.remove('active');
    });

    document.getElementById('cancelContactBtn')?.addEventListener('click', (e) => {
        e.preventDefault();
        document.getElementById('contactForm').classList.remove('active');
    });

    document.getElementById('cancelSecurityBtn')?.addEventListener('click', (e) => {
        e.preventDefault();
        document.getElementById('securityForm').classList.remove('active');
    });

    // Переключение видимости пароля
    document.getElementById('togglePassword')?.addEventListener('click', function() {
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

    // Загрузка аватарки (AJAX)
    document.querySelector('.avatar-upload input')?.addEventListener('change', function(e) {
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