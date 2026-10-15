
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="easyBuy.model.CartItem" %>
<%@ page import="easyBuy.model.Product" %>

<%
    // =====================================================
    // SECTION 1: CONTEXT PATH AND CART DATA
    // =====================================================
    String contextPath = request.getContextPath();

    List<CartItem> cartItems =
        (List<CartItem>) request.getAttribute("cartItems");

    Map<Integer, Product> products =
        (Map<Integer, Product>) request.getAttribute("products");

    if (cartItems == null) {
        cartItems = java.util.Collections.emptyList();
    }

    if (products == null) {
        products = new java.util.HashMap<Integer, Product>();
    }

    // =====================================================
    // SECTION 2: SAFELY READ THE CART TOTAL
    // Supports BigDecimal and other numeric total types.
    // =====================================================
    Object totalObject = request.getAttribute("cartTotal");
    BigDecimal cartTotal = BigDecimal.ZERO;

    if (totalObject instanceof BigDecimal) {
        cartTotal = (BigDecimal) totalObject;
    } else if (totalObject instanceof Number) {
        cartTotal = new BigDecimal(totalObject.toString());
    } else if (totalObject != null) {
        try {
            cartTotal = new BigDecimal(totalObject.toString());
        } catch (NumberFormatException ignored) {
            cartTotal = BigDecimal.ZERO;
        }
    }

    // =====================================================
    // SECTION 3: LOGIN STATUS AND PROFILE INITIAL
    // =====================================================
    Object sessionUser = session.getAttribute("user");
    Object sessionUserId = session.getAttribute("userId");
    Object sessionUserName = session.getAttribute("userName");

    boolean loggedIn = sessionUser != null || sessionUserId != null;

    String profileLetter = "U";

    if (sessionUserName != null
            && !sessionUserName.toString().trim().isEmpty()) {
        profileLetter = sessionUserName.toString()
            .trim()
            .substring(0, 1)
            .toUpperCase(Locale.ROOT);
    }

    // =====================================================
    // SECTION 4: TOTAL QUANTITY OF PRODUCTS
    // =====================================================
    int totalQuantity = 0;

    for (CartItem item : cartItems) {
        totalQuantity += item.getQuantity();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Page configuration -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Your Cart | easyBuy</title>

    <!-- Cart stylesheet -->
    <link rel="stylesheet"
          type="text/css"
          href="<%= contextPath %>/css/cart.css?v=200">
</head>

<body>

<!-- =====================================================
     SECTION 5: HEADER
     Only Wishlist and Profile appear beside the logo.
     ===================================================== -->
<header class="site-header">
    <nav class="navbar">

        <!-- easyBuy logo -->
        <a href="<%= contextPath %>/home" class="logo">
            easy<span>Buy</span>
        </a>

        <!-- Right-side account actions -->
        <div class="nav-actions">

            <a href="<%= contextPath %>/wishlist" class="nav-text">
                <span class="nav-icon" aria-hidden="true">♡</span>
                <span>Wishlist</span>
            </a>

            <a href="<%= contextPath %>/profile" class="profile-link">
                <span class="profile-dp"><%= profileLetter %></span>
                <span>Profile</span>
            </a>

        </div>
    </nav>
</header>


<!-- =====================================================
     SECTION 7: MAIN CART CONTENT
     ===================================================== -->
<main class="cart-page">

    <!-- Cart hero banner -->
    <section class="cart-hero">

        <div class="cart-hero-content">
            <p class="eyebrow">EASYBUY SHOPPING CART</p>

            <h1>Your Cart<span class="title-dot">.</span></h1>

            <p class="hero-description">
                Review your selected products before checkout.
            </p>
        </div>

        <!-- Decorative oversized logo letters -->
        <span class="hero-watermark" aria-hidden="true">eB</span>

    </section>

    <!-- =================================================
         SECTION 8: LOGIN WARNING
         ================================================= -->
    <% if (!loggedIn) { %>

        <div class="login-warning">
            <span class="warning-icon">!</span>
            <span>Please log in before accessing your cart.</span>
        </div>

    <% } %>

    <!-- =================================================
         SECTION 9: NOT LOGGED IN
         ================================================= -->
    <% if (!loggedIn) { %>

        <section class="empty-cart-card">

            <div class="empty-cart-icon" aria-hidden="true">♧</div>

            <p class="eyebrow">YOUR EASYBUY ACCOUNT</p>

            <h2>Please log in</h2>

            <p>
                Sign in to view and manage your easyBuy cart.
            </p>

            <a href="<%= contextPath %>/login"
               class="button-dark">
                Login to Continue <span>↗</span>
            </a>

        </section>

    <!-- =================================================
         SECTION 10: EMPTY CART
         ================================================= -->
    <% } else if (cartItems.isEmpty()) { %>

        <section class="empty-cart-card">

            <div class="empty-cart-icon" aria-hidden="true">♧</div>

            <p class="eyebrow">A LITTLE ROOM FOR SOMETHING NEW</p>

            <h2>Your cart is empty.</h2>

            <p>
                You haven't added any products yet.
                Discover something you'll love.
            </p>

            <a href="<%= contextPath %>/products"
               class="button-dark">
                Continue Shopping <span>↗</span>
            </a>

        </section>

    <!-- =================================================
         SECTION 11: CART WITH PRODUCTS
         ================================================= -->
    <% } else { %>

        <!-- Checkout progress indicator -->
        <section class="checkout-progress" aria-label="Checkout progress">

            <div class="progress-step active">
                <span class="progress-number">1</span>
                <span class="progress-label">Cart</span>
            </div>

            <span class="progress-line"></span>

            <div class="progress-step">
                <span class="progress-number">2</span>
                <span class="progress-label">Shipping</span>
            </div>

            <span class="progress-line"></span>

            <div class="progress-step">
                <span class="progress-number">3</span>
                <span class="progress-label">Payment</span>
            </div>

        </section>

        <!-- Two-column cart layout -->
        <section class="cart-content">

            <!-- =============================================
                 SECTION 12: PRODUCT SELECTION CARD
                 ============================================= -->
            <div class="cart-items-card">

                <div class="cart-items-header">
                    <div>
                        <p class="eyebrow">YOUR SELECTION</p>
                        <h2>Your Products</h2>
                        <p class="cart-subtitle">
                            Your picks are ready to go.
                        </p>
                    </div>

                    <span class="item-count">
                        <%= totalQuantity %>
                        item(s)
                    </span>
                </div>

                <!-- Loop through cart products -->
                <% for (CartItem item : cartItems) {

                    Product product = products.get(item.getProductId());

                    String productName = product != null
                        && product.getProductName() != null
                        ? product.getProductName()
                        : "Product";

                    String productSize = product != null
                        && product.getSize() != null
                        && !product.getSize().trim().isEmpty()
                        ? product.getSize()
                        : "-";

                    String productColor = product != null
                        && product.getColor() != null
                        && !product.getColor().trim().isEmpty()
                        ? product.getColor()
                        : "-";

                    BigDecimal productPrice = product != null
                        ? BigDecimal.valueOf(product.getPrice())
                        : BigDecimal.ZERO;

                    BigDecimal itemSubtotal = productPrice.multiply(
                        BigDecimal.valueOf(item.getQuantity())
                    );

                    String formattedPrice = productPrice.setScale(
                        2, java.math.RoundingMode.HALF_UP
                    ).toPlainString();

                    String formattedSubtotal = itemSubtotal.setScale(
                        2, java.math.RoundingMode.HALF_UP
                    ).toPlainString();

                    /*
                     * Temporary product image path.
                     * Replace the image later with the actual product image.
                     */

/* Get the actual image filename for this product */
String imageName = product != null
    ? product.getImageName()
    : null;

/* Build the image URL using the stored filename */
String imagePath = null;

if (imageName != null && !imageName.trim().isEmpty()) {
    imagePath = contextPath + "/images/all-products/"
        + java.net.URLEncoder.encode(
            imageName.trim(),
            java.nio.charset.StandardCharsets.UTF_8.name()
        ).replace("+", "%20");
}

                %>

                    <!-- One cart product row -->
                    <article class="cart-item">

                        <!-- Product image / temporary placeholder -->
                        <div class="cart-item-image">

                            

<% if (imagePath != null) { %>
    <img
        src="<%= imagePath %>"
        alt="<%= productName %>"
        onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
<% } %>

<div class="image-placeholder"
     style="<%= imagePath != null ? "display:none;" : "display:flex;" %>">
    <span class="placeholder-symbol">✳</span>
    <span>PRODUCT IMAGE</span>
</div>


                        </div>

                        <!-- Product details: no extra product label -->
                        <div class="cart-item-details">

                            <h3><%= productName %></h3>

                            <div class="product-meta-row">

                                <div class="product-meta">
                                    <span>SIZE</span>
                                    <strong><%= productSize %></strong>
                                </div>

                                <div class="product-meta">
                                    <span>COLOUR</span>
                                    <strong><%= productColor %></strong>
                                </div>

                            </div>

                            <p class="item-price">
                                ₹<%= formattedPrice %>
                                <span>/ item</span>
                            </p>

                           
                           
                      

                        </div>

                        <!-- Quantity update and remove actions -->
                        <div class="cart-item-actions">

                            <!-- Quantity update form -->
                            <form action="<%= contextPath %>/cart"
                                  method="post"
                                  class="quantity-action-form">

                                <input type="hidden"
                                       name="action"
                                       value="update">

                                <input type="hidden"
                                       name="cartItemId"
                                       value="<%= item.getCartItemId() %>">

                                <label class="quantity-label"
                                       for="quantity-<%= item.getCartItemId() %>">
                                    QUANTITY
                                </label>

                                <div class="quantity-control">

                                    <button type="button"
                                            class="quantity-button"
                                            aria-label="Decrease quantity"
                                            onclick="changeQuantity(this, -1)">−</button>

                                    <input
                                        type="number"
                                        id="quantity-<%= item.getCartItemId() %>"
                                        name="quantity"
                                        value="<%= item.getQuantity() %>"
                                        min="1"
                                        max="99"
                                        required>

                                    <button type="button"
                                            class="quantity-button"
                                            aria-label="Increase quantity"
                                            onclick="changeQuantity(this, 1)">+</button>

                                </div>

                                <button type="submit" class="update-button">
                                    Update
                                </button>

                            </form>

                            <!-- Remove product form -->
                            <form action="<%= contextPath %>/cart"
                                  method="post"
                                  class="remove-form"
                                  onsubmit="return confirm('Remove this product from your cart?');">

                                <input type="hidden"
                                       name="action"
                                       value="remove">

                                <input type="hidden"
                                       name="cartItemId"
                                       value="<%= item.getCartItemId() %>">

                                <button type="submit" class="remove-button">
                                    Remove item
                                </button>

                            </form>

                        </div>

                    </article>

                <% } %>

                <!-- Continue shopping link -->
                <div class="continue-shopping-row">
                    <a href="<%= contextPath %>/products"
                       class="continue-shopping-link">
                        ← Continue shopping
                    </a>
                </div>

            </div>

            <!-- =============================================
                 SECTION 13: ORDER SUMMARY
                 ============================================= -->
            <aside class="cart-summary">

                <p class="eyebrow">THE FINAL STEP</p>

                <h2>Order Summary</h2>

                <p class="summary-subtitle">
                    A few good choices, all in one place.
                </p>

                <div class="summary-divider"></div>

                <!-- Number of cart entries -->
                <div class="summary-row">
                    <span>Cart entries</span>
                    <strong><%= cartItems.size() %></strong>
                </div>

                <div class="summary-divider"></div>

                <!-- Total amount -->
                <div class="summary-row total-row">
                    <span>Total amount</span>
                    <strong>
                        ₹<%= cartTotal.setScale(
                            2, java.math.RoundingMode.HALF_UP
                        ).toPlainString() %>
                    </strong>
                </div>

                <p class="summary-note">
                    Your total is based on the cart amount supplied by easyBuy.
                </p>

                <!-- Checkout button -->
                <a href="<%= contextPath %>/checkout"
                   class="checkout-button">
                    <span>Proceed to Checkout</span>
                    <span class="checkout-arrow">↗</span>
                </a>

                <!-- Payment reminder -->
                <div class="payment-note">
                    <span class="payment-icon" aria-hidden="true">▣</span>
                    <span>Payment options are available at checkout.</span>
                </div>

            </aside>

        </section>

    <% } %>

</main>




<!-- =====================================================
     SECTION 14: FOOTER
     Same structure as product-details.jsp
     ===================================================== -->
<footer class="site-footer">

    <div class="footer-main">

        <!-- Footer brand -->
        <div class="footer-brand">
            <a href="<%= contextPath %>/home" class="footer-logo">
                easy<span>Buy</span>
            </a>
            <p>Easy shopping. Thoughtfully chosen.</p>
        </div>

        <!-- Footer exploration links -->
        <div class="footer-column">
            <h3>EXPLORE</h3>
            <a href="<%= contextPath %>/home">Home</a>
            <a href="<%= contextPath %>/products">Shop all</a>
            <a href="<%= contextPath %>/home#categories">Categories</a>
        </div>

        <!-- Footer account links -->
        <div class="footer-column">
            <h3>YOUR ACCOUNT</h3>
            <a href="<%= contextPath %>/profile">Profile</a>
            <a href="<%= contextPath %>/cart">Shopping cart</a>
            <a href="<%= contextPath %>/wishlist">Wishlist</a>
        </div>

        <!-- Footer closing message -->
        <div class="footer-note">
            <span>MADE FOR YOUR EVERYDAY</span>
            <p>Discover something you love.</p>
            <a href="<%= contextPath %>/products">Start exploring ↗</a>
        </div>

    </div>

    <!-- Copyright and back-to-top links -->
    <div class="footer-bottom">
        <span>© <%= java.time.Year.now().getValue() %> easyBuy</span>
        <span>Easy Shopping, Easy Buying.</span>
        <a href="#" id="backToTop">Back to top ↑</a>
    </div>

</footer>

<!-- =====================================================
     SECTION 15: CART PAGE INTERACTIONS
     ===================================================== -->
<script>
    // Increase or decrease quantity without allowing values below 1.
    function changeQuantity(button, amount) {
        const control = button.closest(".quantity-control");
        const input = control.querySelector('input[name="quantity"]');

        let quantity = parseInt(input.value, 10);

        if (isNaN(quantity)) {
            quantity = 1;
        }

        quantity += amount;
        quantity = Math.max(1, Math.min(99, quantity));

        input.value = quantity;
    }

    // Back-to-top link.
    document.getElementById("backToTop").addEventListener("click", function (event) {
        event.preventDefault();
        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    });
</script>

</body>
</html>
