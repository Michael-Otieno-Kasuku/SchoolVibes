// login.js
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('login-form');
    loginForm.addEventListener('submit', function(event) {
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;

        // Regular expression patterns for email and password validation
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

        // Validation checks
        if (!emailPattern.test(email)) {
            event.preventDefault();
            alert('Please enter a valid email address.');
        }

        if (!passwordPattern.test(password)) {
            event.preventDefault();
            alert('Password must be 8 characters or more and contain both letters and numbers.');
        }
    });
});
