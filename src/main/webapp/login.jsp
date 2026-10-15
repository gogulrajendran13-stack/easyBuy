<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String contextPath = request.getContextPath();

    String errorMessage =
            (String) request.getAttribute("errorMessage");

    if (errorMessage == null) {
        errorMessage =
                (String) request.getAttribute("error");
    }

    if (errorMessage == null) {
        errorMessage = "";
    }

    String successMessage =
            (String) request.getAttribute("successMessage");

    if (successMessage == null) {
        successMessage =
                (String) request.getAttribute("success");
    }

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

    <title>easyBuy | Login</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/login.css?v=701">

</head>

<body>

<main class="auth-page">

    <!-- =====================================================
         LEFT BRAND PANEL
    ====================================================== -->

    <section class="auth-brand-panel">

        <div class="brand-panel-decoration decoration-one"></div>
        <div class="brand-panel-decoration decoration-two"></div>
        <div class="brand-panel-decoration decoration-three"></div>


        <div class="brand-panel-card">

            <!-- =================================================
                 EASYBUY WORDMARK
                 Logo image intentionally removed.
            ================================================== -->

            <a href="<%= contextPath %>/home"
               class="auth-logo"
               aria-label="easyBuy Home">

                <span class="easybuy-wordmark">
                    easyBuy
                </span>

            </a>


            <!-- =================================================
                 EYEBROW
            ================================================== -->

            <div class="auth-eyebrow">
                EASY SHOPPING
            </div>


            <!-- =================================================
                 MAIN HEADING
            ================================================== -->

            <h1>
                Everything you love,
                <br>
                <span>in one place.</span>
            </h1>


            <!-- =================================================
                 DESCRIPTION
            ================================================== -->

            <p class="auth-description">

                Discover products, manage your cart,
                and enjoy a simple shopping experience
                designed around you.

            </p>


            <!-- =================================================
                 FEATURES
            ================================================== -->

            <div class="auth-features">

                <div class="auth-feature">

                    <span class="feature-check">
                        &#10003;
                    </span>

                    <span>
                        Discover products easily
                    </span>

                </div>


                <div class="auth-feature">

                    <span class="feature-check">
                        &#10003;
                    </span>

                    <span>
                        Simple and secure shopping
                    </span>

                </div>


                <div class="auth-feature">

                    <span class="feature-check">
                        &#10003;
                    </span>

                    <span>
                        Manage everything in one place
                    </span>

                </div>

            </div>

        </div>


        <!-- =====================================================
             BOTTOM CAPTION
        ====================================================== -->

        <div class="brand-panel-caption">

            <span></span>

            SHOP&nbsp;&nbsp;•&nbsp;&nbsp;DISCOVER&nbsp;&nbsp;•&nbsp;&nbsp;ENJOY

        </div>

    </section>


    <!-- =====================================================
         RIGHT LOGIN PANEL
    ====================================================== -->

    <section class="auth-form-panel">

        <div class="login-card">


            <!-- =================================================
                 LOGIN HEADING
            ================================================== -->

            <div class="login-heading">

                <h2>
                    Welcome back
                </h2>

                <p>
                    Login to your easyBuy account
                </p>

            </div>


            <!-- =================================================
                 ERROR MESSAGE
            ================================================== -->

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


            <!-- =================================================
                 SUCCESS MESSAGE
            ================================================== -->

            <% if (!successMessage.trim().isEmpty()) { %>

                <div class="message-box success-message">

                    <span class="message-icon">
                        &#10003;
                    </span>

                    <span>
                        <%= successMessage %>
                    </span>

                </div>

            <% } %>


            <!-- =================================================
                 LOGIN FORM

                 Backend parameter names preserved:
                 email
                 phone
                 password
                 remember
            ================================================== -->

            <form action="<%= contextPath %>/login"
                  method="post"
                  class="login-form">


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
                            placeholder="Enter your email"
                            autocomplete="email"
                            required>

                    </div>

                </div>


                <!-- MOBILE NUMBER -->

                <div class="form-group">

                    <label for="phone">
                        Mobile Number
                    </label>

                    <div class="input-wrap">

                        <span class="input-symbol phone-symbol">
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

                        <span class="input-symbol password-symbol">
                            &#8226;
                        </span>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
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


                <!-- REMEMBER ME -->

                <label class="remember-row">

                    <input
                        type="checkbox"
                        name="remember">

                    <span>
                        Keep me logged in
                    </span>

                </label>


                <!-- LOGIN BUTTON -->

                <button
                    type="submit"
                    class="primary-auth-button">

                    <span>
                        Login
                    </span>

                    <span class="button-arrow">
                        &#8594;
                    </span>

                </button>

            </form>


            <!-- =================================================
                 DIVIDER
            ================================================== -->

            <div class="auth-divider">

                <span></span>

                <strong>
                    OR
                </strong>

                <span></span>

            </div>


            <!-- =================================================
                 REGISTER
            ================================================== -->

            <div class="account-switch">

                <span>
                    Don't have an account?
                </span>

                <a href="<%= contextPath %>/register">
                    Create an account
                </a>

            </div>


            <!-- =================================================
                 CONTINUE SHOPPING
            ================================================== -->

            <a href="<%= contextPath %>/home"
               class="continue-shopping">

                <span>
                    &#8592;
                </span>

                Continue shopping

            </a>

        </div>

    </section>

</main>


<!-- =========================================================
     PASSWORD VISIBILITY SCRIPT
========================================================= -->

<script>

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

</script>

</body>

</html>