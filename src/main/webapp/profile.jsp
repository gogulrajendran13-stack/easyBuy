
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="easyBuy.model.User"%>
<%@ page import="easyBuy.model.UserProfile"%>

<%
    String contextPath = request.getContextPath();

    /* =========================================================
       GET USER
       ========================================================= */

    User user = null;

    Object userObject = request.getAttribute("user");

    if (userObject instanceof User) {
        user = (User) userObject;
    }

    if (user == null) {
        Object sessionUser = session.getAttribute("user");

        if (sessionUser instanceof User) {
            user = (User) sessionUser;
        }
    }

    /* =========================================================
       GET PROFILE
       ========================================================= */

    UserProfile profile =
            (UserProfile) request.getAttribute("profile");

    /* =========================================================
       GET USER ID
       ========================================================= */

    int userId = 0;

    Object userIdObject = request.getAttribute("userId");

    if (userIdObject == null) {
        userIdObject = session.getAttribute("userId");
    }

    if (userIdObject != null) {
        try {
            userId = Integer.parseInt(String.valueOf(userIdObject));
        } catch (NumberFormatException e) {
            userId = 0;
        }
    }

    /* =========================================================
       USER INFORMATION
       ========================================================= */

    String userName = "";
    String userEmail = "";
    String userPhone = "";

    if (user != null) {
        userName = user.getName() == null ? "" : user.getName();
        userEmail = user.getEmail() == null ? "" : user.getEmail();
        userPhone = user.getPhone() == null ? "" : user.getPhone();
    } else {
        Object sessionName = session.getAttribute("userName");
        Object sessionEmail = session.getAttribute("userEmail");
        Object sessionPhone = session.getAttribute("userPhone");

        if (sessionName != null) {
            userName = String.valueOf(sessionName);
        }

        if (sessionEmail != null) {
            userEmail = String.valueOf(sessionEmail);
        }

        if (sessionPhone != null) {
            userPhone = String.valueOf(sessionPhone);
        }
    }

    /* =========================================================
       PROFILE INFORMATION
       ========================================================= */

    String firstName = "";
    String lastName = "";
    String gender = "";
    String address = "";

    if (profile != null) {
        firstName = profile.getFirstName() == null
                ? "" : profile.getFirstName();

        lastName = profile.getLastName() == null
                ? "" : profile.getLastName();

        gender = profile.getGender() == null
                ? "" : profile.getGender();

        address = profile.getAddress() == null
                ? "" : profile.getAddress();
    }

    /* =========================================================
       DISPLAY NAME
       ========================================================= */

    String displayName = userName;

    String profileFullName =
            (firstName + " " + lastName).trim();

    if (!profileFullName.isEmpty()) {
        displayName = profileFullName;
    }

    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = "EasyBuy User";
    }

    /* =========================================================
       PROFILE INITIAL
       ========================================================= */

    String initial = "E";

    if (!displayName.trim().isEmpty()) {
        initial = displayName.trim()
                .substring(0, 1)
                .toUpperCase();
    }

    /* =========================================================
       PUBLIC ACCOUNT REFERENCE
       ========================================================= */

    String publicAccountId = "EB#GUEST@USER!X";

    if (userId > 0) {
        String base36 =
                Integer.toString(userId, 36).toUpperCase();

        int code = Math.floorMod(userId * 73, 10000);

        publicAccountId =
                "EB@" +
                base36 +
                "#U" +
                String.format("%04d", code) +
                "!X";
    }

    /* =========================================================
       SUCCESS MESSAGE
       ========================================================= */

    String profileSuccessMessage =
            (String) session.getAttribute("profileSuccessMessage");

    if (profileSuccessMessage != null) {
        session.removeAttribute("profileSuccessMessage");
    }

    /* =========================================================
       ERROR MESSAGE
       ========================================================= */

    String errorMessage =
            (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Profile - EasyBuy</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/profile.css?v=206">
</head>

<body>

    <!-- =====================================================
         NAVIGATION
         ===================================================== -->

    <nav class="navbar">

        <a href="<%= contextPath %>/home" class="logo">
            easy<span>Buy</span>
        </a>

        
<div class="nav-links">

    <a href="<%= contextPath %>/home">
        Home
    </a>

    <a href="<%= contextPath %>/profile"
       class="profile-nav-link">

        <span class="profile-dp">
            <%= initial %>
        </span>

        <span class="profile-text">
            Profile
        </span>

    </a>

</div>


    </nav>

    <!-- =====================================================
         MAIN PROFILE PAGE
         ===================================================== -->

    <main class="profile-page">

        <!-- HERO -->

        <section class="profile-hero">

            <div class="profile-hero-content">

                <div class="profile-avatar-large">
                    <%= initial %>
                </div>

                <div class="profile-hero-text">

                    <span class="profile-eyebrow">
                        YOUR EASYBUY ACCOUNT
                    </span>

                    <h1>
                        Welcome, <%= displayName %>
                    </h1>

                    <p>
                        Manage your personal details
                        and keep your EasyBuy profile up to date.
                    </p>

                </div>

            </div>

            <div class="account-reference">

                <span class="reference-label">
                    Account Reference
                </span>

                <span class="reference-id">
                    <%= publicAccountId %>
                </span>

            </div>

        </section>

        <!-- SUCCESS MESSAGE -->

        <% if (profileSuccessMessage != null
                && !profileSuccessMessage.isEmpty()) { %>

            <div class="profile-message success-message">
                <%= profileSuccessMessage %>
            </div>

        <% } %>

        <!-- ERROR MESSAGE -->

        <% if (errorMessage != null
                && !errorMessage.isEmpty()) { %>

            <div class="profile-message error-message">
                <%= errorMessage %>
            </div>

        <% } %>

        <!-- MAIN PROFILE CONTENT -->

        <section class="profile-content">

            <!-- ACCOUNT OVERVIEW -->

            <div class="profile-summary-card">

                <div class="section-label">
                    ACCOUNT
                </div>

                <h2>
                    Account overview
                </h2>

                <p class="section-description">
                    Your EasyBuy account information.
                </p>

                <!-- FULL NAME -->

                <div class="summary-item">

                    <span>
                        Full Name
                    </span>

                    <strong>
                        <%= displayName %>
                    </strong>

                </div>

                <!-- EMAIL -->

                <div class="summary-item">

                    <span>
                        Email
                    </span>

                    <strong>
                        <%= userEmail.isEmpty()
                                ? "Not available"
                                : userEmail %>
                    </strong>

                </div>

                <!-- MOBILE -->

                <div class="summary-item">

                    <span>
                        Mobile Number
                    </span>

                    <strong>
                        <%= userPhone.isEmpty()
                                ? "Not available"
                                : userPhone %>
                    </strong>

                </div>

                <!-- ACCOUNT ID -->

                <div class="summary-item">

                    <span>
                        EasyBuy Account ID
                    </span>

                    <strong>
                        <%= publicAccountId %>
                    </strong>

                </div>

                <!-- LOGOUT -->

                <div class="profile-logout-section">

                    <p>
                        Sign out securely from your EasyBuy account.
                    </p>

                    <form action="<%= contextPath %>/logout"
                          method="post">

                        <button type="submit"
                                class="logout-button">
                            Logout
                        </button>

                    </form>

                </div>

            </div>

            <!-- PERSONAL DETAILS -->

            <div class="profile-form-card">

                <div class="section-label">
                    PERSONAL DETAILS
                </div>

                <h2>
                    Complete your profile
                </h2>

                <p class="section-description">
                    Add a few more details to personalize
                    your EasyBuy account.
                </p>

                <form action="<%= contextPath %>/profile"
                      method="post"
                      class="profile-form">

                    <!-- FIRST NAME -->

                    <div class="form-group">

                        <label for="firstName">
                            First Name
                        </label>

                        <input
                            type="text"
                            id="firstName"
                            name="firstName"
                            value="<%= firstName %>"
                            placeholder="Enter your first name"
                            maxlength="100"
                            required>

                    </div>

                    <!-- LAST NAME -->

                    <div class="form-group">

                        <label for="lastName">
                            Last Name
                        </label>

                        <input
                            type="text"
                            id="lastName"
                            name="lastName"
                            value="<%= lastName %>"
                            placeholder="Enter your last name"
                            maxlength="100">

                    </div>

                    <!-- MOBILE NUMBER -->

                    <div class="form-group">

                        <label for="phone">
                            Mobile Number
                        </label>

                        <input
                            type="tel"
                            id="phone"
                            name="phone"
                            value="<%= userPhone %>"
                            placeholder="Enter your mobile number"
                            maxlength="20"
                            required>

                        <small>
                            This number is also used when signing in.
                        </small>

                    </div>

                    <!-- GENDER -->

                    <div class="form-group">

                        <label for="gender">
                            Gender
                        </label>

                        <select id="gender" name="gender">

                            <option value="">
                                Select gender
                            </option>

                            <option value="Male"
                                <%= "Male".equalsIgnoreCase(gender)
                                        ? "selected"
                                        : "" %>>
                                Male
                            </option>

                            <option value="Female"
                                <%= "Female".equalsIgnoreCase(gender)
                                        ? "selected"
                                        : "" %>>
                                Female
                            </option>

                            <option value="Other"
                                <%= "Other".equalsIgnoreCase(gender)
                                        ? "selected"
                                        : "" %>>
                                Other
                            </option>

                            <option value="Prefer not to say"
                                <%= "Prefer not to say".equalsIgnoreCase(gender)
                                        ? "selected"
                                        : "" %>>
                                Prefer not to say
                            </option>

                        </select>

                    </div>

                    <!-- ADDRESS -->

                    <div class="form-group form-group-full">

                        <label for="address">
                            Address
                        </label>

                        <textarea
                            id="address"
                            name="address"
                            rows="5"
                            maxlength="255"
                            placeholder="Enter your complete address"><%= address %></textarea>

                    </div>

                    <!-- FORM ACTIONS -->

                    <div class="profile-form-actions">

                        <a href="<%= contextPath %>/home"
                           class="secondary-profile-button">
                            Continue Shopping
                        </a>

                        <button type="submit"
                                class="primary-profile-button">
                            Save Profile
                        </button>

                    </div>

                </form>

            </div>

        </section>

        <!-- QUICK ACTIONS -->

        <section class="profile-actions-section">

            <!-- CONTINUE SHOPPING -->

            <div class="profile-action-card">

                <div class="action-icon">
                    🛍️
                </div>

                <div class="action-content">

                    <h3>
                        Continue Shopping
                    </h3>

                    <p>
                        Explore categories and discover
                        something you love.
                    </p>

                </div>

                <a href="<%= contextPath %>/products"
                   class="action-link">
                    Browse Products →
                </a>

            </div>

            <!-- WISHLIST -->

            <div class="profile-action-card">

                <div class="action-icon">
                    ♡
                </div>

                <div class="action-content">

                    <h3>
                        My Wishlist
                    </h3>

                    <p>
                        View the products you saved
                        for later.
                    </p>

                </div>

                <a href="<%= contextPath %>/wishlist"
                   class="action-link">
                    View Wishlist →
                </a>

            </div>

            <!-- VIEW CART -->

            <div class="profile-action-card">

                <div class="action-icon">
                    🛒
                </div>

                <div class="action-content">

                    <h3>
                        View Your Cart
                    </h3>

                    <p>
                        Check the products you have
                        added to your shopping cart.
                    </p>

                </div>

                <a href="<%= contextPath %>/cart"
                   class="action-link">
                    Open Cart →
                </a>

            </div>

        </section>

    </main>

   
<!-- =====================================================
     SHARED EASYBUY FOOTER
     Same four-column structure as Cart and Product Details
     ===================================================== -->
<footer class="site-footer">
    <div class="footer-main">

        <!-- Brand -->
        <div class="footer-brand">
            <a href="<%= contextPath %>/home" class="footer-logo">
                Easy<span>Buy</span>
            </a>
            <p>Your simple and smarter shopping experience.</p>
        </div>

        <!-- Shop links -->
        <div class="footer-column">
            <h3>SHOP</h3>
            <a href="<%= contextPath %>/home">Home</a>
            <a href="<%= contextPath %>/products">All Products</a>
            <a href="<%= contextPath %>/wishlist">My Wishlist</a>
            <a href="<%= contextPath %>/cart">Shopping Cart</a>
        </div>

        <!-- Account links -->
        <div class="footer-column">
            <h3>YOUR ACCOUNT</h3>
            <a href="<%= contextPath %>/profile">My Profile</a>
            <a href="<%= contextPath %>/orders">My Orders</a>
            <a href="<%= contextPath %>/login">Sign In</a>
        </div>

        <!-- Help and note -->
        <div class="footer-note">
            <span>THE EASYBUY EXPERIENCE</span>
            <p>Discover your favourites and enjoy a simple, convenient way to shop.</p>
            <a href="<%= contextPath %>/products">Explore Products →</a>
        </div>

    </div>

    <!-- Footer bottom -->
    <div class="footer-bottom">
        <span>© <%= java.time.Year.now().getValue() %> EasyBuy. All rights reserved.</span>
        <a href="<%= contextPath %>/home">Continue Shopping</a>
    </div>
</footer>


</body>
</html>
