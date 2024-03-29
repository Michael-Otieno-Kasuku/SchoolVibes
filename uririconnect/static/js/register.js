document.getElementById('registration-form').onsubmit = function(event) {
    const fields = ['first_name', 'last_name', 'email_address', 'user_password', 'confirm_password', 'phone_number'];
    let isValid = true;
    fields.forEach(field => {
        const value = document.getElementById(`id_${field}`).value.trim();
        if (!value) {
            event.preventDefault();
            isValid = false;
            document.getElementById(`${field}-error`).innerText = `${field.replace('_', ' ').capitalize()} is required.`;
        } else {
            document.getElementById(`${field}-error`).innerText = '';
        }

        // Additional validation for specific fields (email, password, and phone number)
        if (field === 'email_address' && !isValidEmail(value)) {
            event.preventDefault();
            isValid = false;
            document.getElementById(`${field}-error`).innerText = 'Invalid email address.';
        }

        if ((field === 'user_password' || field === 'confirm_password') && !isValidPassword(value)) {
            event.preventDefault();
            isValid = false;
            document.getElementById(`${field}-error`).innerText = 'Password must be at least 8 characters long and contain both letters and numbers.';
        }

        if (field === 'phone_number' && !isValidPhoneNumber(value)) {
            event.preventDefault();
            isValid = false;
            document.getElementById(`${field}-error`).innerText = 'Invalid phone number.';
        }
    });

    return isValid;
};

function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function isValidPassword(password) {
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
    return passwordRegex.test(password);
}

function isValidPhoneNumber(phoneNumber) {
    const phoneRegex = /^(07\d{8}|01\d{8}|\+2541\d{7}|\+2547\d{8})$/;
    return phoneRegex.test(phoneNumber);
}

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
};
