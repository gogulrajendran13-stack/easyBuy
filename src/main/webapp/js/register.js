document.addEventListener("DOMContentLoaded", function () {

    const form = document.getElementById("registerForm");

    const password =
        document.getElementById("password");

    const confirmPassword =
        document.getElementById("confirmPassword");

    const passwordError =
        document.getElementById("passwordError");


    form.addEventListener("submit", function (event) {

        passwordError.textContent = "";

        if (password.value !== confirmPassword.value) {

            event.preventDefault();

            passwordError.textContent =
                "Passwords do not match.";

            return;
        }

        if (password.value.length < 6) {

            event.preventDefault();

            passwordError.textContent =
                "Password must contain at least 6 characters.";

            return;
        }

    });

});