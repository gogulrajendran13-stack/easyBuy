<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String contextPath = request.getContextPath();

    String errorMessage =
            (String) request.getAttribute("error");

    if (errorMessage == null) {
        errorMessage = "";
    }

    String successMessage =
            (String) request.getAttribute("success");

    if (successMessage == null) {
        successMessage = "";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>easyBuy | Create Account</title>

    <link rel="stylesheet"
          type="text/css"
          href="<%= contextPath %>/css/register.css?v=602">

</head>


<body>


<main class="auth-page">


    <!-- =====================================================
         LEFT BRAND PANEL
    ====================================================== -->

    <section class="auth-brand-panel">


        <!-- BACKGROUND DECORATIONS -->

        <div class="brand-decoration brand-decoration-one"></div>

        <div class="brand-decoration brand-decoration-two"></div>

        <div class="brand-decoration brand-decoration-three"></div>

        <div class="brand-decoration brand-decoration-four"></div>


        <!-- LEFT CONTENT CARD -->

        <div class="brand-panel-card">


            <!-- EASYBUY BRAND -->

            <a href="<%= contextPath %>/home"
               class="auth-brand-name"
               aria-label="Go to easyBuy homepage">

                easyBuy

            </a>


            <!-- SMALL LABEL -->

            <div class="auth-eyebrow">
                EASY SHOPPING
            </div>


            <!-- MAIN HEADING -->

            <h1>

                Everything you love,

                <br>

                <span>in one place.</span>

            </h1>


            <!-- DESCRIPTION -->

            <p class="auth-description">

                Create your easyBuy account and enjoy
                a simple, smarter and more enjoyable
                way to shop.

            </p>


            <!-- FEATURES -->

            <div class="auth-features">


                <div class="auth-feature">

                    <span class="feature-check">
                        ✓
                    </span>

                    <span>
                        Easy shopping
                    </span>

                </div>


                <div class="auth-feature">

                    <span class="feature-check">
                        ✓
                    </span>

                    <span>
                        Smart cart management
                    </span>

                </div>


                <div class="auth-feature">

                    <span class="feature-check">
                        ✓
                    </span>

                    <span>
                        Discover great products
                    </span>

                </div>


            </div>


        </div>


        <!-- BOTTOM CAPTION -->

        <div class="brand-panel-caption">

            <span></span>

            SHOP&nbsp;&nbsp;•&nbsp;&nbsp;DISCOVER&nbsp;&nbsp;•&nbsp;&nbsp;ENJOY

        </div>


    </section>



    <!-- =====================================================
         RIGHT REGISTER PANEL
    ====================================================== -->

    <section class="auth-form-panel">


        <!-- RIGHT BACKGROUND DECORATIONS -->

        <div class="form-decoration form-decoration-one"></div>

        <div class="form-decoration form-decoration-two"></div>

        <div class="form-decoration form-decoration-three"></div>


        <!-- REGISTER CARD -->

        <div class="register-card">


            <!-- HEADING -->

            <div class="register-heading">

                <h2>
                    Create account
                </h2>

                <p>
                    Enter your details below to create
                    your easyBuy account.
                </p>

            </div>



            <!-- ERROR MESSAGE -->

            <% if (!errorMessage.trim().isEmpty()) { %>

                <div class="message-box error-message">

                    <span class="message-icon">
                        !
                    </span>

                    <span>
                        <%= errorMessage %>
                    </span>

                </div>

            <% } %>



            <!-- SUCCESS MESSAGE -->

            <% if (!successMessage.trim().isEmpty()) { %>

                <div class="message-box success-message">

                    <span class="message-icon">
                        ✓
                    </span>

                    <span>
                        <%= successMessage %>
                    </span>

                </div>

            <% } %>



            <!-- =================================================
                 REGISTER FORM

                 Backend parameter names preserved:

                 name
                 email
                 phone
                 password
                 confirmPassword
            ================================================== -->

            <form action="<%= contextPath %>/register"
                  method="post"
                  class="register-form">


                <!-- FULL NAME -->

                <div class="form-group">

                    <label for="name">
                        Full Name
                    </label>

                    <div class="input-wrap">

                        <span class="input-symbol">
                            ●
                        </span>

                        <input
                            type="text"
                            id="name"
                            name="name"
                            placeholder="Enter your full name"
                            autocomplete="name"
                            required>

                    </div>

                </div>



                <!-- EMAIL -->

                <div class="form-group">

                    <label for="email">
                        Email
                    </label>

                    <div class="input-wrap">

                        <span class="input-symbol">
                            @
                        </span>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email address"
                            autocomplete="email"
                            required>

                    </div>

                </div>



                <!-- PHONE -->

                <div class="form-group">

                    <label for="phone">
                        Mobile Number
                    </label>

                    <div class="input-wrap">

                        <span class="input-symbol">
                            +
                        </span>

                        <input
                            type="tel"
                            id="phone"
                            name="phone"
                            placeholder="Enter your mobile number"
                            autocomplete="tel"
                            inputmode="numeric"
                            required>

                    </div>

                </div>



                <!-- PASSWORD -->

                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <div class="input-wrap">

                        <span class="input-symbol">
                            •
                        </span>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Create a password"
                            autocomplete="new-password"
                            required>

                        <button
                            type="button"
                            class="password-toggle"
                            data-target="password"
                            aria-label="Show password">

                            <span class="eye-icon"></span>

                        </button>

                    </div>

                </div>



                <!-- CONFIRM PASSWORD -->

                <div class="form-group">

                    <label for="confirmPassword">
                        Confirm Password
                    </label>

                    <div class="input-wrap">

                        <span class="input-symbol">
                            •
                        </span>

                        <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            placeholder="Confirm your password"
                            autocomplete="new-password"
                            required>

                        <button
                            type="button"
                            class="password-toggle"
                            data-target="confirmPassword"
                            aria-label="Show password">

                            <span class="eye-icon"></span>

                        </button>

                    </div>

                </div>



                <!-- PASSWORD TIP -->

                <div class="password-tip">

                    <span></span>

                    Use a password you don't use elsewhere.

                </div>



                <!-- CREATE ACCOUNT BUTTON -->

                <button
                    type="submit"
                    class="primary-auth-button">

                    <span>
                        Create account
                    </span>

                    <span class="button-arrow">
                        →
                    </span>

                </button>


            </form>



            <!-- LOGIN LINK -->

            <div class="account-switch">

                <span>
                    Already have an account?
                </span>

                <a href="<%= contextPath %>/login">
                    Log in
                </a>

            </div>



            <!-- CONTINUE SHOPPING -->

            <a href="<%= contextPath %>/home"
               class="continue-shopping">

                <span>
                    ←
                </span>

                Continue shopping

            </a>


        </div>


    </section>


</main>



<script>


    /* =========================================================
       SHOW / HIDE PASSWORD
    ========================================================= */

    document.querySelectorAll(".password-toggle")
        .forEach(function(button) {

            button.addEventListener("click", function() {

                const targetId =
                    button.getAttribute("data-target");

                const input =
                    document.getElementById(targetId);

                if (!input) {
                    return;
                }


                if (input.type === "password") {

                    input.type = "text";

                    button.setAttribute(
                        "aria-label",
                        "Hide password"
                    );

                    button.classList.add("visible");

                } else {

                    input.type = "password";

                    button.setAttribute(
                        "aria-label",
                        "Show password"
                    );

                    button.classList.remove("visible");

                }

            });

        });



    /* =========================================================
       PASSWORD MATCH
    ========================================================= */

    const registerForm =
        document.querySelector(".register-form");

    const password =
        document.getElementById("password");

    const confirmPassword =
        document.getElementById("confirmPassword");


    if (
        registerForm &&
        password &&
        confirmPassword
    ) {

        registerForm.addEventListener(
            "submit",
            function(event) {

                if (
                    password.value !==
                    confirmPassword.value
                ) {

                    event.preventDefault();

                    alert(
                        "Passwords do not match."
                    );

                    confirmPassword.focus();

                }

            }
        );

    }

</script>


</body>

</html>