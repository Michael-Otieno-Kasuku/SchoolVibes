$(document).ready(function () {
    $('#password-reset-form').submit(function (event) {
        event.preventDefault(); // Prevent the form from submitting normally
        
        var email = $('#email').val();

        // Frontend email format validation
        if (!isValidEmail(email)) {
            $('#error-message').text('Invalid email address.');
            return;
        } else {
            $('#error-message').text('');
        }

        // Perform AJAX request to check if the email exists in the database
        $.ajax({
            url: '/check_email_existence/',  // Update the URL to your backend endpoint
            method: 'POST',
            data: {email: email},
            success: function (response) {
                if (response.exists) {
                    // Email exists in the database, allow form submission
                    $('#error-message').text('');
                    $('#password-reset-form')[0].submit();
                } else {
                    // Email does not exist, show an error message
                    $('#error-message').text('Email address not found.');
                }
            },
            error: function (error) {
                // Handle AJAX errors, show a generic error message
                $('#error-message').text('Error occurred while processing your request. Please try again later.');
            }
        });
    });

    // Function to validate email format
    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
});
