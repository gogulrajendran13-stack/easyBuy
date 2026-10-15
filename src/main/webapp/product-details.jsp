
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="easyBuy.model.Product" %>
<%@ page import="java.util.Locale" %>

<%
    // =====================================================
    // SECTION 1: GET PRODUCT DETAILS FROM THE CONTROLLER
    // =====================================================
    String contextPath = request.getContextPath();
    Product product = (Product) request.getAttribute("product");

    int productId = 0;
    String productName = "EasyBuy Product";
    String size = "M";
    String color = "White";
    String price = "0.00";

    if (product != null) {
        productId = product.getProductId();

        if (product.getProductName() != null && !product.getProductName().trim().isEmpty()) {
            productName = product.getProductName().trim();
        }
        if (product.getSize() != null && !product.getSize().trim().isEmpty()) {
            size = product.getSize().trim();
        }
        if (product.getColor() != null && !product.getColor().trim().isEmpty()) {
            color = product.getColor().trim();
        }
        price = String.format(Locale.US, "%.2f", product.getPrice());
    }

    // =====================================================
    // SECTION 2: GET USER PROFILE INITIAL
    // =====================================================
    String userName = "";
    Object sessionUserName = session.getAttribute("userName");

    if (sessionUserName != null) {
        userName = String.valueOf(sessionUserName).trim();
    }

    String initial = userName.isEmpty()
            ? "E"
            : userName.substring(0, 1).toUpperCase(Locale.ROOT);

    // =====================================================
    // SECTION 3: GET WISHLIST STATUS MESSAGES
    // =====================================================
    String wishlistSuccessMessage =
            (String) session.getAttribute("wishlistSuccessMessage");
    String wishlistErrorMessage =
            (String) session.getAttribute("wishlistErrorMessage");

    if (wishlistSuccessMessage != null) {
        session.removeAttribute("wishlistSuccessMessage");
    }
    if (wishlistErrorMessage != null) {
        session.removeAttribute("wishlistErrorMessage");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- SECTION 4: PAGE CONFIGURATION -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= productName %> | easyBuy</title>

    <!-- SECTION 5: CONNECT THE PRODUCT DETAILS STYLESHEET -->
    <link rel="stylesheet" href="<%= contextPath %>/css/product-details.css?v=402">
</head>
<body>

    <!-- =====================================================
         SECTION 6: HEADER AND NAVIGATION
         ===================================================== -->
    <header class="site-header">
        <nav class="navbar">
            <!-- SECTION 6A: easyBuy LOGO -->
            <a href="<%= contextPath %>/home" class="logo">
                easy<span>Buy</span>
            </a>

            <!-- SECTION 6B: HEADER NAVIGATION LINKS -->
            <div class="nav-actions">
                <a href="<%= contextPath %>/wishlist" class="nav-text">
                    <span class="nav-icon">♡</span>
                    <span>Wishlist</span>
                </a>
                <a href="<%= contextPath %>/cart" class="nav-text">
                    <span class="nav-icon">🛒</span>
                    <span>Cart</span>
                </a>
                <a href="<%= contextPath %>/profile" class="profile-link">
                    <span class="profile-dp"><%= initial %></span>
                    <span>Profile</span>
                </a>
            </div>
        </nav>
    </header>

    <!-- =====================================================
         SECTION 7: MAIN PAGE CONTAINER
         ===================================================== -->
    <main class="page-container">
        <% if (product == null) { %>

            <!-- SECTION 8: PRODUCT NOT FOUND MESSAGE -->
            <section class="product-not-found">
                <p class="eyebrow">EASYBUY COLLECTION</p>
                <h1>Product not found</h1>
                <p>The product you are looking for is currently unavailable.</p>
                <a href="<%= contextPath %>/products" class="button-dark">
                    Explore products ↗
                </a>
            </section>

        <% } else { %>

            <!-- SECTION 9: BREADCRUMB NAVIGATION -->
            <div class="breadcrumb">
                <a href="<%= contextPath %>/home">Home</a>
                <span>/</span>
                <a href="<%= contextPath %>/products">Products</a>
                <span>/</span>
                <span class="breadcrumb-current"><%= productName %></span>
            </div>

            <!-- =================================================
                 SECTION 10: PRODUCT LAYOUT
                 Left: Product image placeholder
                 Right: Product information and actions
                 ================================================= -->
            <section class="product-layout">

               
<%-- PRODUCT IMAGE SECTION --%>
<div class="product-image-container">
    <%
        String imageName = product.getImageName();

        if (imageName != null && !imageName.trim().isEmpty()) {
            String encodedImageName =
                java.net.URLEncoder.encode(
                    imageName.trim(),
                    "UTF-8"
                ).replace("+", "%20");
    %>
        <img
            src="<%= request.getContextPath() %>/images/all-products/<%= encodedImageName %>"
            alt="<%= product.getProductName() %>"
            class="product-detail-image"
            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
        >

        <div class="product-image-placeholder" style="display:none;">
            Product image unavailable
        </div>
    <%
        } else {
    %>
        <div class="product-image-placeholder">
            Product image unavailable
        </div>
    <%
        }
    %>
</div>


                <!-- SECTION 10B: RIGHT PRODUCT INFORMATION -->
                <div class="product-info">

                    <!-- SECTION 10B-1: PRODUCT OVERLINE -->
                    <div class="product-overline">
                        <span class="overline-line"></span>
                        THE EASYBUY EDIT
                    </div>

                    <!-- SECTION 10B-2: PRODUCT CATEGORY -->
                    <p class="product-category">
                        A considered everyday essential
                    </p>

                    <!-- SECTION 10B-3: PRODUCT NAME -->
                    <h1 class="product-title"><%= productName %></h1>

                    <!-- SECTION 10B-4: PRODUCT PRICE -->
                    <div class="product-price-row">
                        <span class="price-label">Price</span>
                        <span class="product-price">₹<%= price %></span>
                    </div>

                    <!-- SECTION 10B-5: PRODUCT INTRODUCTION -->
                    <p class="product-intro">
                        Find something you'll love. Explore the details
                        and make your favourite part of your collection.
                    </p>

                    <!-- SECTION 10B-6: INFORMATION DIVIDER -->
                    <div class="info-divider"></div>

                    <!-- =================================================
                         SECTION 11: SIZE SELECTOR
                         ================================================= -->
                    <div class="option-block">
                        <div class="option-heading">
                            <span>SIZE</span>
                            <span class="option-value" id="selectedSizeLabel"><%= size %></span>
                        </div>

                        <!-- SECTION 11A: CIRCULAR SIZE OPTIONS -->
                        <div class="size-display" id="sizeSelector">
                            <button type="button" class="size-chip"
                                    data-size="S" aria-pressed="false">S</button>
                            <button type="button" class="size-chip"
                                    data-size="M" aria-pressed="false">M</button>
                            <button type="button" class="size-chip"
                                    data-size="L" aria-pressed="false">L</button>
                        </div>
                    </div>

                    <!-- =================================================
                         SECTION 12: COLOUR SELECTOR
                         The colour name appears beside the heading.
                         No second colour preview is shown underneath.
                         ================================================= -->
                    <div class="option-block color-block">
                        <div class="option-heading">
                            <span>COLOUR</span>
                            <span class="option-value" id="selectedColorLabel"><%= color %></span>
                        </div>

                        <!-- SECTION 12A: COLOUR SWATCH BUTTONS -->
                        <div class="color-options" id="colorSelector">
                            <button type="button"
                                    class="color-chip white-chip"
                                    data-color="White"
                                    aria-label="Select white"
                                    aria-pressed="false"></button>

                            <button type="button"
                                    class="color-chip black-chip"
                                    data-color="Black"
                                    aria-label="Select black"
                                    aria-pressed="false"></button>

                            <button type="button"
                                    class="color-chip beige-chip"
                                    data-color="Beige"
                                    aria-label="Select beige"
                                    aria-pressed="false"></button>
                        </div>
                    </div>

                    <!-- =================================================
                         SECTION 13: WISHLIST STATUS MESSAGES
                         ================================================= -->
                    <% if (wishlistSuccessMessage != null
                            && !wishlistSuccessMessage.isEmpty()) { %>
                        <div class="product-message success">
                            <%= wishlistSuccessMessage %>
                        </div>
                    <% } %>

                    <% if (wishlistErrorMessage != null
                            && !wishlistErrorMessage.isEmpty()) { %>
                        <div class="product-message error">
                            <%= wishlistErrorMessage %>
                        </div>
                    <% } %>

                    <!-- =================================================
                         SECTION 14: ADD TO CART AND WISHLIST ACTIONS
                         ================================================= -->
                    <div class="product-actions">

                        <!-- SECTION 14A: ADD TO CART FORM -->
                        <form action="<%= contextPath %>/cart"
                              method="post" class="cart-form">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <input type="hidden" name="quantity" value="1">

                            <!-- Add to Cart button content is centred -->
                            <button type="submit" class="add-cart-button">
                                <span class="cart-button-label">
                                    <span class="cart-button-icon">🛒</span>
                                    <span>Add to Cart</span>
                                </span>
                                <span class="button-arrow">↗</span>
                            </button>
                        </form>

                        <!-- SECTION 14B: WISHLIST FORM -->
                        <form action="<%= contextPath %>/wishlist"
                              method="post" class="wishlist-form">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="<%= productId %>">

                            <!-- Heart and Wishlist text share one button -->
                            <button type="submit" class="wishlist-button"
                                    aria-label="Add to Wishlist">
                                <span class="wishlist-icon">♡</span>
                                <span>Wishlist</span>
                            </button>
                        </form>
                    </div>
                </div>
            </section>
        <% } %>

        <!-- =====================================================
             SECTION 15: RECOMMENDED PRODUCTS
             ===================================================== -->
        <section class="recommended-section">
            <!-- SECTION 15A: RECOMMENDED SECTION HEADING -->
            <div class="section-heading">
                <div>
                    <p class="eyebrow">A LITTLE MORE TO LOVE</p>
                    <h2>Recommended <em>for you.</em></h2>
                </div>
                <a href="<%= contextPath %>/products" class="view-all-link">
                    Explore all products <span>↗</span>
                </a>
            </div>

           
<!-- SECTION 15B: RECOMMENDED PRODUCT CARDS -->
<div class="recommended-grid">

    <!-- RECOMMENDED CARD 1: EVERYDAY ESSENTIALS -->
    <a href="<%= contextPath %>/products" class="recommended-card">
        <div class="recommended-image">
            <img src="<%= contextPath %>/images/products/product_1.jpg"
                 alt="Everyday essentials collection">
        </div>
        <div class="recommended-details">
            <div>
                <h3>Everyday Essentials</h3>
                <p>Simple things, thoughtfully chosen</p>
            </div>
            <span class="card-arrow">↗</span>
        </div>
    </a>

    <!-- RECOMMENDED CARD 2: MODERN FAVOURITES -->
    <a href="<%= contextPath %>/products" class="recommended-card">
        <div class="recommended-image">
            <img src="<%= contextPath %>/images/products/product_2.jpg"
                 alt="Modern favourites collection">
        </div>
        <div class="recommended-details">
            <div>
                <h3>Modern Favourites</h3>
                <p>Find your next favourite</p>
            </div>
            <span class="card-arrow">↗</span>
        </div>
    </a>

    <!-- RECOMMENDED CARD 3: DAILY PICKS -->
    <a href="<%= contextPath %>/products" class="recommended-card">
        <div class="recommended-image">
            <img src="<%= contextPath %>/images/products/product_19.jpg"
                 alt="Daily picks collection">
        </div>
        <div class="recommended-details">
            <div>
                <h3>Daily Picks</h3>
                <p>Little upgrades for every day</p>
            </div>
            <span class="card-arrow">↗</span>
        </div>
    </a>

    <!-- RECOMMENDED CARD 4: NEW DISCOVERIES -->
    <a href="<%= contextPath %>/products" class="recommended-card">
        <div class="recommended-image">
            <img src="<%= contextPath %>/images/products/product_6.jpg"
                 alt="New discoveries collection">
        </div>
        <div class="recommended-details">
            <div>
                <h3>New Discoveries</h3>
                <p>Something worth discovering</p>
            </div>
            <span class="card-arrow">↗</span>
        </div>
    </a>

</div>

        </section>

       
<!-- =====================================================
     SECTION 16: IMAGE-BASED PROMOTIONAL BANNER
     Uses product_11.jpg from the EasyBuy project.
====================================================== -->
<section class="promo-banner">

    <!-- Background product image -->
    <img
        class="promo-background-image"
        src="<%= contextPath %>/images/products/product_11.jpg"
        alt="Selected EasyBuy products"
        onerror="this.style.display='none';">

    <!-- Overlay keeps the existing warm EasyBuy palette -->
    <div class="promo-image-overlay"></div>

    <!-- Left-side promotional text -->
    <div class="promo-content">

        <p class="promo-eyebrow">
            A LITTLE SOMETHING FOR YOU
        </p>

        <h2>
            Good finds.<br>
            <em>Even better prices.</em>
        </h2>

        <p class="promo-description">
            Make room for something new. Explore the easyBuy
            collection and discover your next favourite.
        </p>

        <a href="<%= contextPath %>/products"
           class="promo-button">
            Shop the collection <span>↗</span>
        </a>

    </div>

    <!-- Offer typography integrated into the banner -->
    <div class="promo-offer">

        <span class="offer-small">YOUR NEXT ORDER</span>

        <strong>20<span>%</span></strong>

        <span class="offer-bottom">OFF</span>

        <span class="offer-star">✳</span>

    </div>

    <!-- Small decorative caption -->
    <span class="promo-side-note">
        A BETTER WAY TO DISCOVER
    </span>

</section>


        <!-- =====================================================
             SECTION 17: NEWSLETTER
             ===================================================== -->
        <section class="newsletter-section" id="newsletter">
            <!-- SECTION 17A: NEWSLETTER DESCRIPTION -->
            <div class="newsletter-copy">
                <p class="eyebrow">STAY IN THE KNOW</p>
                <h2>A good thing,<br><em>straight to your inbox.</em></h2>
                <p>
                    Be the first to discover new arrivals, thoughtful picks,
                    and special offers from easyBuy.
                </p>
            </div>

            <!-- SECTION 17B: NEWSLETTER FORM -->
            <form class="newsletter-form" id="newsletterForm">
                <label for="newsletterEmail">YOUR EMAIL ADDRESS</label>
                <div class="newsletter-input-row">
                    <input type="email" id="newsletterEmail" name="email"
                           placeholder="you@example.com" required>
                    <button type="submit">Subscribe <span>↗</span></button>
                </div>
                <p class="newsletter-note" id="newsletterMessage">
                    By subscribing, you agree to receive easyBuy updates.
                </p>
            </form>
        </section>
    </main>

    <!-- =====================================================
         SECTION 18: FOOTER
         ===================================================== -->
    <footer class="site-footer">
        <!-- SECTION 18A: FOOTER CONTENT COLUMNS -->
        <div class="footer-main">
            <!-- SECTION 18A-1: FOOTER BRAND -->
            <div class="footer-brand">
                <a href="<%= contextPath %>/home" class="footer-logo">
                    easy<span>Buy</span>
                </a>
                <p>Easy shopping. Thoughtfully chosen.</p>
            </div>

            <!-- SECTION 18A-2: EXPLORE LINKS -->
            <div class="footer-column">
                <h3>EXPLORE</h3>
                <a href="<%= contextPath %>/home">Home</a>
                <a href="<%= contextPath %>/products">Shop all</a>
                <a href="<%= contextPath %>/home#categories">Categories</a>
            </div>

            <!-- SECTION 18A-3: ACCOUNT LINKS -->
            <div class="footer-column">
                <h3>YOUR ACCOUNT</h3>
                <a href="<%= contextPath %>/profile">Profile</a>
                <a href="<%= contextPath %>/cart">Shopping cart</a>
                <a href="<%= contextPath %>/wishlist">Wishlist</a>
            </div>

            <!-- SECTION 18A-4: FOOTER CLOSING MESSAGE -->
            <div class="footer-note">
                <span>MADE FOR YOUR EVERYDAY</span>
                <p>Discover something you love.</p>
                <a href="<%= contextPath %>/products">Start exploring ↗</a>
            </div>
        </div>

        <!-- SECTION 18B: COPYRIGHT AND BACK-TO-TOP LINK -->
        <div class="footer-bottom">
            <span>© <%= java.time.Year.now().getValue() %> easyBuy</span>
            <span>Easy Shopping, Easy Buying.</span>
            <a href="#" id="backToTop">Back to top ↑</a>
        </div>
    </footer>

    <!-- =====================================================
         SECTION 19: JAVASCRIPT INTERACTIONS
         ===================================================== -->
    <script>
        // =====================================================
        // SECTION 19A: SIZE SELECTOR
        // =====================================================
        (function () {
            var selector = document.getElementById("sizeSelector");
            var label = document.getElementById("selectedSizeLabel");

            if (!selector || !label) {
                return;
            }

            var buttons = selector.querySelectorAll("[data-size]");
            var currentSize = "<%= size.replace("\\", "\\\\").replace("\"", "\\\"") %>";
            var selected = false;

            buttons.forEach(function (button) {
                if (button.dataset.size === currentSize) {
                    button.classList.add("selected");
                    button.setAttribute("aria-pressed", "true");
                    selected = true;
                }

                button.addEventListener("click", function () {
                    buttons.forEach(function (item) {
                        item.classList.remove("selected");
                        item.setAttribute("aria-pressed", "false");
                    });

                    button.classList.add("selected");
                    button.setAttribute("aria-pressed", "true");
                    label.textContent = button.dataset.size;
                });
            });

            if (!selected && buttons.length > 0) {
                buttons[0].classList.add("selected");
                buttons[0].setAttribute("aria-pressed", "true");
                label.textContent = buttons[0].dataset.size;
            }
        })();

        // =====================================================
        // SECTION 19B: COLOUR SELECTOR
        // The selected colour updates only the heading label.
        // =====================================================
        (function () {
            var selector = document.getElementById("colorSelector");
            var label = document.getElementById("selectedColorLabel");

            if (!selector || !label) {
                return;
            }

            var buttons = selector.querySelectorAll("[data-color]");
            var currentColor = "<%= color.replace("\\", "\\\\").replace("\"", "\\\"") %>";
            var selected = false;

            buttons.forEach(function (button) {
                if (button.dataset.color.toLowerCase() === currentColor.toLowerCase()) {
                    button.classList.add("selected");
                    button.setAttribute("aria-pressed", "true");
                    label.textContent = button.dataset.color;
                    selected = true;
                }

                button.addEventListener("click", function () {
                    buttons.forEach(function (item) {
                        item.classList.remove("selected");
                        item.setAttribute("aria-pressed", "false");
                    });

                    button.classList.add("selected");
                    button.setAttribute("aria-pressed", "true");
                    label.textContent = button.dataset.color;
                });
            });

            if (!selected && buttons.length > 0) {
                buttons[0].classList.add("selected");
                buttons[0].setAttribute("aria-pressed", "true");
                label.textContent = buttons[0].dataset.color;
            }
        })();

        // =====================================================
        // SECTION 19C: NEWSLETTER DEMONSTRATION
        // This displays a message only; it does not save an email.
        // =====================================================
        (function () {
            var form = document.getElementById("newsletterForm");
            var message = document.getElementById("newsletterMessage");

            if (form && message) {
                form.addEventListener("submit", function (event) {
                    event.preventDefault();
                    message.textContent =
                        "Thank you! Newsletter registration requires a backend service.";
                });
            }
        })();

        // =====================================================
        // SECTION 19D: BACK-TO-TOP BUTTON
        // =====================================================
        (function () {
            var button = document.getElementById("backToTop");

            if (button) {
                button.addEventListener("click", function (event) {
                    event.preventDefault();
                    window.scrollTo({
                        top: 0,
                        behavior: "smooth"
                    });
                });
            }
        })();
    </script>
</body>
</html>
