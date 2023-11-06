document.getElementById('registration-form').onsubmit = function(event) {
    const fields = ['role_id', 'first_name', 'last_name', 'email_address', 'user_password', 'confirm_password', 'phone_number'];
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

        // Additional validation for specific fields (email and phone number)
        if (field === 'email_address' && !isValidEmail(value)) {
            event.preventDefault();
            isValid = false;
            document.getElementById(`${field}-error`).innerText = 'Invalid email address.';
        }

        if (field === 'phone_number' && !isValidPhoneNumber(value)) {
            event.preventDefault();
            isValid = false;
            document.getElementById(`${field}-error`).innerText = 'Invalid phone number.';
        }
    });

    return isValid;
};

// Validate email format
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Validate phone number format
function isValidPhoneNumber(phoneNumber) {
    const phoneRegex = /^(07\d{8}|01\d{8}|\+2541\d{7}|\+2547\d{8})$/;
    return phoneRegex.test(phoneNumber);
}

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
};
