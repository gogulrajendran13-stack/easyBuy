
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="easyBuy.model.CartItem" %>
<%@ page import="easyBuy.model.Product" %>

<%
    // =====================================================
    // BASIC PAGE DATA
    // =====================================================
    String contextPath = request.getContextPath();

    String userName = (String) request.getAttribute("userName");
    String userEmail = (String) request.getAttribute("userEmail");
    String userPhone = (String) request.getAttribute("userPhone");

    if (userName == null) userName = "";
    if (userEmail == null) userEmail = "";
    if (userPhone == null) userPhone = "";

    // =====================================================
    // CART DATA
    // =====================================================
    List<CartItem> cartItems =
        (List<CartItem>) request.getAttribute("cartItems");

    Map<Integer, Product> products =
        (Map<Integer, Product>) request.getAttribute("products");

    Object totalObject = request.getAttribute("cartTotal");
    BigDecimal cartTotal = BigDecimal.ZERO;

    if (totalObject instanceof BigDecimal) {
        cartTotal = (BigDecimal) totalObject;
    } else if (totalObject instanceof Number) {
        cartTotal = new BigDecimal(totalObject.toString());
    }

    if (cartItems == null) {
        cartItems = java.util.Collections.emptyList();
    }

    if (products == null) {
        products = new java.util.HashMap<Integer, Product>();
    }

    // =====================================================
    // CHECKOUT FORM VALUES
    // Preserve values when the controller returns an error.
    // =====================================================
    String receiverName =
        (String) request.getAttribute("receiverName");

    String primaryMobile =
        (String) request.getAttribute("primaryMobile");

    String alternateMobile =
        (String) request.getAttribute("alternateMobile");

    String email =
        (String) request.getAttribute("email");

    String houseFlatNumber =
        (String) request.getAttribute("houseFlatNumber");

    String buildingName =
        (String) request.getAttribute("buildingName");

    String street =
        (String) request.getAttribute("street");

    String area =
        (String) request.getAttribute("area");

    String landmark =
        (String) request.getAttribute("landmark");

    String city =
        (String) request.getAttribute("city");

    if (receiverName == null || receiverName.trim().isEmpty()) {
        receiverName = userName;
    }

    if (primaryMobile == null || primaryMobile.trim().isEmpty()) {
        primaryMobile = userPhone;
    }

    if (alternateMobile == null) alternateMobile = "";
    if (email == null || email.trim().isEmpty()) email = userEmail;
    if (houseFlatNumber == null) houseFlatNumber = "";
    if (buildingName == null) buildingName = "";
    if (street == null) street = "";
    if (area == null) area = "";
    if (landmark == null) landmark = "";
    if (city == null) city = "";

    // =====================================================
    // ERROR MESSAGE
    // =====================================================
    String checkoutErrorMessage =
        (String) request.getAttribute("checkoutErrorMessage");

    // =====================================================
    // PROFILE LETTER
    // =====================================================
    Object navbarUserObject = session.getAttribute("user");
    Object navbarUserId = session.getAttribute("userId");

    String navbarUserName =
        (String) session.getAttribute("userName");

    boolean loggedIn =
        navbarUserObject != null || navbarUserId != null;

    String profileLetter = "U";

    if (navbarUserName != null &&
        !navbarUserName.trim().isEmpty()) {
        profileLetter = navbarUserName.trim()
            .substring(0, 1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>EasyBuy | Checkout</title>

    <!-- Separate checkout stylesheet -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/checkout.css">
</head>

<body>

    <!-- =====================================================
         NAVBAR
         Only the logo, Home and Profile are displayed.
         ===================================================== -->

    <nav class="navbar">

        <a href="<%= contextPath %>/home" class="logo">
            easy<span>Buy</span>
        </a>

        <div class="nav-links">

            <a href="<%= contextPath %>/home" class="home-nav-link">
                Home
            </a>

            <a href="<%= contextPath %>/profile" class="profile-nav-link">

                <span class="profile-dp"><%= profileLetter %></span>

                <span class="profile-text">Profile</span>

            </a>

        </div>

    </nav>


    <!-- =====================================================
         MAIN CHECKOUT PAGE
         ===================================================== -->

    <main class="checkout-page">

        <!-- Checkout banner -->

        <section class="checkout-hero">

            <div class="checkout-hero-content">

                <div class="checkout-small-text">
                    EASYBUY CHECKOUT
                </div>

                <h1>Checkout</h1>

                <p>
                    Confirm your details and delivery address before payment.
                </p>

            </div>

            <!-- Decorative EasyBuy initials -->

            <div class="hero-watermark" aria-hidden="true">
                eB
            </div>

        </section>


        <!-- Checkout error message -->

        <% if (checkoutErrorMessage != null
                && !checkoutErrorMessage.trim().isEmpty()) { %>

            <div class="checkout-error" role="alert">
                <%= checkoutErrorMessage %>
            </div>

        <% } %>


        <!-- =================================================
             CHECKOUT CONTENT
             ================================================= -->

        <section class="checkout-content">


            <!-- =================================================
                 CUSTOMER DETAILS AND DELIVERY ADDRESS
                 ================================================= -->

            <div class="checkout-details-card">

                <h2 class="section-title">
                    Customer Details
                </h2>

                <p class="section-subtitle">
                    Please provide the details required for delivery.
                </p>


                <!-- Checkout form -->

                <form action="<%= contextPath %>/checkout" method="post">


                    <!-- Receiver information -->

                    <div class="form-section">

                        <h3 class="form-section-title">
                            Receiver Information
                        </h3>

                        <p class="form-section-description">
                            Enter the person who will receive the order.
                        </p>

                        <div class="form-grid">


                            <!-- Receiver name -->

                            <div class="form-group full-width">

                                <label for="receiverName">
                                    Full Name of Receiver
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="text"
                                    id="receiverName"
                                    name="receiverName"
                                    value="<%= receiverName %>"
                                    placeholder="Enter receiver full name"
                                    autocomplete="name"
                                    required>

                            </div>


                            <!-- Primary mobile -->

                            <div class="form-group">

                                <label for="primaryMobile">
                                    Primary Mobile Number
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="tel"
                                    id="primaryMobile"
                                    name="primaryMobile"
                                    value="<%= primaryMobile %>"
                                    placeholder="Enter primary mobile number"
                                    autocomplete="tel"
                                    required>

                            </div>


                            <!-- Alternate mobile -->

                            <div class="form-group">

                                <label for="alternateMobile">
                                    Alternate Mobile Number
                                </label>

                                <input
                                    type="tel"
                                    id="alternateMobile"
                                    name="alternateMobile"
                                    value="<%= alternateMobile %>"
                                    placeholder="Enter alternate mobile number"
                                    autocomplete="tel">

                            </div>


                            <!-- Email address -->

                            <div class="form-group full-width">

                                <label for="email">
                                    Email Address
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="email"
                                    id="email"
                                    name="email"
                                    value="<%= email %>"
                                    placeholder="Enter email address"
                                    autocomplete="email"
                                    required>

                            </div>

                        </div>

                    </div>


                    <!-- Delivery address -->

                    <div class="form-section">

                        <h3 class="form-section-title">
                            Delivery Address
                        </h3>

                        <p class="form-section-description">
                            Enter your complete delivery address.
                        </p>

                        <div class="address-block">


                            <!-- House or flat number -->

                            <div class="address-field">

                                <label for="houseFlatNumber">
                                    House / Flat Number
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="text"
                                    id="houseFlatNumber"
                                    name="houseFlatNumber"
                                    value="<%= houseFlatNumber %>"
                                    placeholder="House / Flat No."
                                    autocomplete="address-line1"
                                    required>

                            </div>


                            <!-- Building name -->

                            <div class="address-field">

                                <label for="buildingName">
                                    Building Name
                                </label>

                                <input
                                    type="text"
                                    id="buildingName"
                                    name="buildingName"
                                    value="<%= buildingName %>"
                                    placeholder="Building / Apartment name"
                                    autocomplete="address-line2">

                            </div>


                            <!-- Street -->

                            <div class="address-field">

                                <label for="street">
                                    Street
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="text"
                                    id="street"
                                    name="street"
                                    value="<%= street %>"
                                    placeholder="Street name"
                                    required>

                            </div>


                            <!-- Area -->

                            <div class="address-field">

                                <label for="area">
                                    Area
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="text"
                                    id="area"
                                    name="area"
                                    value="<%= area %>"
                                    placeholder="Area / Locality"
                                    required>

                            </div>


                            <!-- Landmark -->

                            <div class="address-field">

                                <label for="landmark">
                                    Landmark
                                </label>

                                <input
                                    type="text"
                                    id="landmark"
                                    name="landmark"
                                    value="<%= landmark %>"
                                    placeholder="Nearby landmark">

                            </div>


                            <!-- City -->

                            <div class="address-field">

                                <label for="city">
                                    City
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="text"
                                    id="city"
                                    name="city"
                                    value="<%= city %>"
                                    placeholder="City"
                                    autocomplete="address-level2"
                                    required>

                            </div>

                        </div>

                    </div>


                    <!-- Form action buttons -->

                    <div class="checkout-actions">

                        <a href="<%= contextPath %>/cart"
                           class="back-cart-button">
                            &larr; Back to Cart
                        </a>

                        <button type="submit" class="payment-button">
                            Continue to Payment &rarr;
                        </button>

                    </div>

                </form>

            </div>


            <!-- =================================================
                 ORDER SUMMARY
                 ================================================= -->

            <aside class="order-summary-card">

                <div class="summary-eyebrow">
                    YOUR ORDER
                </div>

                <h2>Order Summary</h2>

                <p class="summary-intro">
                    A few good choices, all in one place.
                </p>


                <!-- Display cart items -->

                <% for (CartItem item : cartItems) {

                    if (item == null) {
                        continue;
                    }

                    Product product =
                        products.get(item.getProductId());

                    String itemName =
                        product != null
                            ? product.getProductName()
                            : "Product";

                    BigDecimal itemSubtotal = BigDecimal.ZERO;

                    if (product != null) {
                        itemSubtotal = BigDecimal.valueOf(
                            product.getPrice()
                        ).multiply(
                            BigDecimal.valueOf(item.getQuantity())
                        );
                    }
                %>

                    <div class="summary-item">

                        <div class="summary-item-details">

                            <p class="summary-item-name">
                                <%= itemName %>
                            </p>

                            <div class="summary-item-qty">
                                Quantity: <%= item.getQuantity() %>
                            </div>

                        </div>

                        <div class="summary-item-price">
                            Rs. <%= itemSubtotal %>
                        </div>

                    </div>

                <% } %>


                <!-- Total -->

                <div class="summary-total">

                    <span>Total Amount</span>

                    <strong>
                        Rs. <%= cartTotal %>
                    </strong>

                </div>

                <p class="summary-note">
                    Your order details will be reviewed before payment.
                </p>

            </aside>

        </section>

    </main>


    <!-- =====================================================
         FOOTER
         Shared four-column EasyBuy footer.
         ===================================================== -->

    <footer class="site-footer" id="site-footer">

        <div class="footer-main">


            <!-- Brand column -->

            <div class="footer-brand">

                <a href="<%= contextPath %>/home" class="footer-logo">
                    easy<span>Buy</span>
                </a>

                <p>
                    Discover your style. Find your favourites.
                    Make every shopping experience simple.
                </p>

            </div>


            <!-- Explore column -->

            <div class="footer-column">

                <h3>EXPLORE</h3>

                <a href="<%= contextPath %>/home">
                    Home
                </a>

                <a href="<%= contextPath %>/products">
                    Shop all
                </a>

                <a href="<%= contextPath %>/home#categories">
                    Categories
                </a>

            </div>


            <!-- Account column -->

            <div class="footer-column">

                <h3>YOUR ACCOUNT</h3>

                <a href="<%= contextPath %>/profile">
                    Profile
                </a>

                <a href="<%= contextPath %>/cart">
                    Shopping cart
                </a>

                <a href="<%= contextPath %>/wishlist">
                    Wishlist
                </a>

            </div>


            <!-- EasyBuy promise column -->

            <div class="footer-note">

                <span>THE EASYBUY PROMISE</span>

                <p>
                    Thoughtful choices, timeless finds, and a simpler
                    way to shop for the things you love.
                </p>

                <a href="<%= contextPath %>/products">
                    Discover something new &rarr;
                </a>

            </div>

        </div>


        <!-- Footer bottom row -->

        <div class="footer-bottom">

            <span>
                &copy; <%= java.time.Year.now().getValue() %>
                easyBuy. All rights reserved.
            </span>

            <span>
                Easy Shopping, Easy Buying.
            </span>

            <a href="#"
               onclick="window.scrollTo({top: 0, behavior: 'smooth'}); return false;">
                Back to top &uarr;
            </a>

        </div>

    </footer>

</body>
</html>
