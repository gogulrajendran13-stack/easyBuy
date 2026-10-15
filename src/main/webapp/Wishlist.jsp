<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="easyBuy.model.Wishlist" %>
<%@ page import="easyBuy.model.Product" %>

<%
    // =========================================================
    // PAGE DATA
    // =========================================================
    String contextPath = request.getContextPath();

    List<Wishlist> wishlistItems =
        (List<Wishlist>) request.getAttribute("wishlistItems");

    Map<Integer, Product> products =
        (Map<Integer, Product>) request.getAttribute("products");

    int wishlistCount =
        wishlistItems == null ? 0 : wishlistItems.size();

    // =========================================================
    // SUCCESS AND ERROR MESSAGES
    // =========================================================
    String successMessage =
        (String) session.getAttribute("wishlistSuccessMessage");

    if (successMessage != null) {
        session.removeAttribute("wishlistSuccessMessage");
    }

    String errorMessage =
        (String) session.getAttribute("wishlistErrorMessage");

    if (errorMessage != null) {
        session.removeAttribute("wishlistErrorMessage");
    }

    // =========================================================
    // PROFILE INFORMATION
    // =========================================================
    String userName = "";
    Object sessionUserName = session.getAttribute("userName");

    if (sessionUserName != null) {
        userName = String.valueOf(sessionUserName);
    }

    String initial = "E";

    if (!userName.trim().isEmpty()) {
        initial = userName.trim().substring(0, 1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Wishlist | easyBuy</title>

    <!-- Wishlist stylesheet -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/wishlist.css?v=102">
</head>

<body>

    <!-- =====================================================
         NAVBAR
         Only Cart and Profile are displayed.
         ===================================================== -->
    <nav class="navbar">

        <!-- easyBuy logo -->
        <a href="<%= contextPath %>/home" class="logo">
            easy<span>Buy</span>
        </a>

        <!-- Only two navigation links -->
        <div class="nav-actions">

            <a href="<%= contextPath %>/cart" class="cart-nav-link">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M3 3h2l2.2 11.2a2 2 0 0 0 2 1.6h7.9a2 2 0 0 0 1.9-1.4L21 8H6"/>
                    <circle cx="10" cy="20" r="1"/>
                    <circle cx="18" cy="20" r="1"/>
                </svg>
                <span>Cart</span>
            </a>

            <a href="<%= contextPath %>/profile" class="profile-nav-link">
                <span class="profile-dp"><%= initial %></span>
                <span class="profile-text">Profile</span>
            </a>

        </div>
    </nav>


    <!-- =====================================================
         MAIN WISHLIST CONTENT
         ===================================================== -->
    <main class="wishlist-page">

        <!-- Page banner -->
        <section class="wishlist-header">

            <div class="wishlist-header-content">
                <span class="wishlist-eyebrow">EASYBUY COLLECTION</span>

                <h1>My Wishlist<span>.</span></h1>

                <p>
                    Save the products you love and come back to them
                    whenever you are ready.
                </p>
            </div>

            <div class="wishlist-heart" aria-hidden="true">♡</div>

            <div class="wishlist-banner-mark" aria-hidden="true">eB</div>

        </section>


        <!-- =================================================
             SUCCESS AND ERROR MESSAGES
             ================================================= -->
        <% if (successMessage != null && !successMessage.isEmpty()) { %>
            <div class="wishlist-message wishlist-success" role="status">
                <%= successMessage %>
            </div>
        <% } %>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="wishlist-message wishlist-error" role="alert">
                <%= errorMessage %>
            </div>
        <% } %>


        <!-- =================================================
             WISHLIST TITLE AND ITEM COUNT
             ================================================= -->
        <section class="wishlist-topbar">

            <div class="wishlist-heading">
                <span class="section-eyebrow">YOUR SAVED ITEMS</span>
                <h2>Your Wishlist</h2>
                <p>Keep the pieces you love in one place.</p>
            </div>

            <div class="wishlist-topbar-actions">

                <span class="wishlist-count">
                    <%= wishlistCount %>
                    <%= wishlistCount == 1 ? "item" : "items" %>
                </span>

                <% if (wishlistItems != null && !wishlistItems.isEmpty()) { %>
                    <form action="<%= contextPath %>/wishlist" method="post"
                          onsubmit="return confirm('Are you sure you want to clear your entire wishlist?');">

                        <input type="hidden" name="action" value="clear">

                        <button type="submit" class="clear-wishlist-button">
                            Clear Wishlist
                        </button>
                    </form>
                <% } %>

            </div>
        </section>


        <!-- =================================================
             WISHLIST PRODUCTS
             ================================================= -->
        <section class="wishlist-section">

            <% if (wishlistItems != null && !wishlistItems.isEmpty()) { %>

                <div class="wishlist-grid">

                    <% for (Wishlist wishlist : wishlistItems) {
                        Product product = null;

                        if (products != null) {
                            product = products.get(wishlist.getProductId());
                        }

                        if (product != null) {
                    %>

                        <!-- Individual wishlist card -->
                        <article class="wishlist-card">

                            <!-- Product image area
                                 Replace the placeholder with your real
                                 product image when the image path is ready. -->
                            <a href="<%= contextPath %>/product-details?productId=<%= product.getProductId() %>"
   class="wishlist-image-link"
   aria-label="View <%= product.getProductName() %>">
    <div class="wishlist-product-image">

        <div class="wishlist-image-art" aria-hidden="true">
            <span>easyBuy</span>
        </div>

        <span class="wishlist-image-label">SAVED FOR LATER</span>

        <div class="wishlist-image-heart" aria-hidden="true">♥</div>

    </div>
</a>


                            <!-- Product information -->
                            <div class="wishlist-product-content">

                               

                                <h3 class="wishlist-product-name">
    <a href="<%= contextPath %>/product-details?productId=<%= product.getProductId() %>">
        <%= product.getProductName() %>
    </a>
</h3>
                                <div class="wishlist-info-row">
                                    <span>Size</span>
                                    <strong><%= product.getSize() %></strong>
                                </div>

                                <div class="wishlist-info-row">
                                    <span>Colour</span>
                                    <strong><%= product.getColor() %></strong>
                                </div>

                                <div class="wishlist-price">
                                    <span class="currency-symbol">₹</span>
                                    <%= product.getPrice() %>
                                </div>

                                <!-- Product actions -->
                                <div class="wishlist-actions">

                                    <a href="<%= contextPath %>/product-details?productId=<%= product.getProductId() %>"
                                       class="wishlist-view-button">
                                        View Product
                                        <span aria-hidden="true">↗</span>
                                    </a>

                                    <form action="<%= contextPath %>/wishlist"
                                          method="post"
                                          onsubmit="return confirm('Remove this product from your wishlist?');">

                                        <input type="hidden"
                                               name="action"
                                               value="remove">

                                        <input type="hidden"
                                               name="productId"
                                               value="<%= product.getProductId() %>">

                                        <button type="submit"
                                                class="wishlist-remove-button"
                                                aria-label="Remove <%= product.getProductName() %> from wishlist">
                                            Remove
                                        </button>
                                    </form>

                                </div>

                            </div>
                        </article>

                    <%  }
                    } %>

                </div>

            <% } else { %>

                <!-- Empty wishlist state -->
                <div class="empty-wishlist">

                    <div class="empty-wishlist-icon" aria-hidden="true">
                        ♡
                    </div>

                    <span class="section-eyebrow">YOUR COLLECTION STARTS HERE</span>

                    <h2>Your wishlist is empty.</h2>

                    <p>
                        When you find something you love, save it here
                        and it will be waiting for you.
                    </p>

                    <a href="<%= contextPath %>/products"
                       class="browse-wishlist-button">
                        Explore Products
                        <span aria-hidden="true">→</span>
                    </a>

                </div>

            <% } %>

        </section>

    </main>


   <!-- =====================================================
     FOOTER - MATCHES THE PRODUCT DETAILS PAGE
     ===================================================== -->
<footer class="site-footer" id="site-footer">

    <div class="footer-main">

        <!-- Brand -->
        <div class="footer-brand">
            <a href="<%= contextPath %>/home" class="footer-logo">
                easy<span>Buy</span>
            </a>

            <p>
                Discover your style. Find your favourites.
                Make every shopping experience simple.
            </p>
        </div>

        <!-- Explore -->
        <div class="footer-column">
            <h3>EXPLORE</h3>
            <a href="<%= contextPath %>/home">Home</a>
            <a href="<%= contextPath %>/products">Shop all</a>
            <a href="<%= contextPath %>/home#categories">Categories</a>
        </div>

        <!-- Your account -->
        <div class="footer-column">
            <h3>YOUR ACCOUNT</h3>
            <a href="<%= contextPath %>/profile">Profile</a>
            <a href="<%= contextPath %>/cart">Shopping cart</a>
            <a href="<%= contextPath %>/wishlist">Wishlist</a>
        </div>

        <!-- Footer note -->
        <div class="footer-note">
            <span>THE EASYBUY PROMISE</span>

            <p>
                Thoughtful choices, timeless finds, and a simpler
                way to shop for the things you love.
            </p>

            <a href="<%= contextPath %>/products">
                Discover something new →
            </a>
        </div>

    </div>

    <!-- Footer bottom -->
    <div class="footer-bottom">
        <span>
            © <%= java.time.Year.now().getValue() %> easyBuy.
            All rights reserved.
        </span>

        <span>Easy Shopping, Easy Buying.</span>

        <a href="#" onclick="window.scrollTo({top: 0, behavior: 'smooth'}); return false;">
            Back to top ↑
        </a>
    </div>

</footer>

</body>
</html>