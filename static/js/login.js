// Funcionalidades específicas del login
document.addEventListener('DOMContentLoaded', function () {
    // Auto-remove alerts after 5 seconds
    setTimeout(() => {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            alert.style.transition = 'all 0.3s ease';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 300);
        });
    }, 5000);

    // Enter key submits form
    document.getElementById('password').addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            document.querySelector('form').submit();
        }
    });

    // Focus on email field on load
    document.getElementById('email').focus();
});

// Fill demo credentials
function fillCredentials(email, password) {
    document.getElementById('email').value = email;
    document.getElementById('password').value = password;

    // Highlight the selected demo account
    document.querySelectorAll('.demo-account').forEach(account => {
        account.style.borderColor = '#e9ecef';
        account.style.background = 'white';
    });

    event.currentTarget.style.borderColor = '#3498db';
    event.currentTarget.style.background = '#e3f2fd';
}

// Show/hide password (opcional)
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
}

// Form validation
function validateForm() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    if (!email || !password) {
        showMessage('Por favor complete todos los campos', 'error');
        return false;
    }

    if (!isValidEmail(email)) {
        showMessage('Por favor ingrese un email válido', 'error');
        return false;
    }

    return true;
}

function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function showMessage(message, type) {
    // Remove existing messages
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());

    // Create new alert
    const alert = document.createElement('div');
    alert.className = `alert ${type}`;
    alert.textContent = message;

    // Insert after logo
    const logo = document.querySelector('.logo');
    logo.parentNode.insertBefore(alert, logo.nextSibling);

    // Auto remove
    setTimeout(() => {
        alert.style.transition = 'all 0.3s ease';
        alert.style.opacity = '0';
        setTimeout(() => alert.remove(), 300);
    }, 5000);
}

// Prevent form submission if validation fails
document.querySelector('form').addEventListener('submit', function (e) {
    if (!validateForm()) {
        e.preventDefault();
    }
});