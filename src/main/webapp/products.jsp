<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.ArrayList,java.util.Locale" %>
<%@ page import="easyBuy.model.Product,easyBuy.model.Category" %>

<%-- =========================================================
     SECTION 1: PREPARE DATA FOR THE PRODUCTS PAGE
     ========================================================= --%>
<%
String contextPath = request.getContextPath();

List<Product> products = (List<Product>) request.getAttribute("products");
if (products == null) products = new ArrayList<>();

List<Category> categories = (List<Category>) request.getAttribute("categories");
if (categories == null) categories = new ArrayList<>();

Integer selectedCategoryId = (Integer) request.getAttribute("selectedCategoryId");
Category selectedCategory = (Category) request.getAttribute("selectedCategory");

String search = (String) request.getAttribute("search");
String minPrice = (String) request.getAttribute("minPrice");
String maxPrice = (String) request.getAttribute("maxPrice");
String selectedSize = (String) request.getAttribute("size");
String selectedColor = (String) request.getAttribute("color");
String selectedSort = (String) request.getAttribute("sort");

search = search == null ? "" : search;
minPrice = minPrice == null ? "" : minPrice;
maxPrice = maxPrice == null ? "" : maxPrice;
selectedSize = selectedSize == null ? "" : selectedSize;
selectedColor = selectedColor == null ? "" : selectedColor;
selectedSort = selectedSort == null || selectedSort.isEmpty()
        ? "relevance" : selectedSort;

List<String> availableSizes =
        (List<String>) request.getAttribute("availableSizes");
List<String> availableColors =
        (List<String>) request.getAttribute("availableColors");

if (availableSizes == null) availableSizes = new ArrayList<>();
if (availableColors == null) availableColors = new ArrayList<>();

String categoryTitle = selectedCategory == null
        ? "All Products" : selectedCategory.getCategoryName();

String categoryDescription =
        "Discover products selected to make everyday shopping simple, stylish and easy.";

if (selectedCategory != null
        && selectedCategory.getDescription() != null
        && !selectedCategory.getDescription().trim().isEmpty()) {
    categoryDescription = selectedCategory.getDescription();
} else if (selectedCategory != null) {
    categoryDescription = "Explore products available in " + categoryTitle + ".";
}
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <%-- SECTION 2: PAGE METADATA AND CSS CONNECTION --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>easyBuy | Products</title>
    <link rel="stylesheet"
          href="<%= contextPath %>/css/products.css?v=705">
</head>

<body>

<div class="products-page">

    <%-- =====================================================
         SECTION 3: HEADER AND NAVIGATION
         ===================================================== --%>
    <header class="products-header">

        <%-- SECTION 3A: EASYBUY BRAND --%>
        <a href="<%= contextPath %>/home" class="products-brand">
            
<span class="brand-easy">easy</span><span class="brand-buy">Buy</span>

        </a>

        <%-- SECTION 3B: MAIN NAVIGATION LINKS --%>
        <nav class="products-main-nav" aria-label="Main navigation">
            <a href="<%= contextPath %>/home" class="products-nav-item">
                Dashboard
            </a>

            <a href="<%= contextPath %>/products"
               class="products-nav-item active">
                Shop
            </a>
        </nav>

        <%-- SECTION 3C: WISHLIST, CART AND PROFILE LINKS --%>
        <div class="products-header-actions">

            <a href="<%= contextPath %>/wishlist"
               class="products-header-action"
               aria-label="Wishlist">
                <span class="products-action-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.7l-1-1.1a5.5 5.5 0 0 0-7.8 7.8L12 21.2l8.8-8.8a5.5 5.5 0 0 0 0-7.8z"/>
                    </svg>
                </span>
                <span class="products-action-label">Wishlist</span>
            </a>

            <a href="<%= contextPath %>/cart"
               class="products-header-action"
               aria-label="Cart">
                <span class="products-action-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M6 6h15l-1.5 9h-12z"/>
                        <path d="M6 6 5 3H2"/>
                        <circle cx="9" cy="20" r="1.5"/>
                        <circle cx="18" cy="20" r="1.5"/>
                    </svg>
                </span>
                <span class="products-action-label">Cart</span>
            </a>

            <a href="<%= contextPath %>/profile"
               class="products-header-action"
               aria-label="Profile">
                <span class="products-action-icon">
                    <svg viewBox="0 0 24 24">
                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"/>
                    </svg>
                </span>
                <span class="products-action-label">Profile</span>
            </a>

        </div>
    </header>

    <%-- SECTION 3D: LINE UNDER THE HEADER --%>
    <div class="products-header-line"></div>


    <%-- =====================================================
         SECTION 4: MAIN PROMOTIONAL HERO CAROUSEL
         This carousel contains three promotional slides.
         ===================================================== --%>
    <section class="products-promo-carousel"
             aria-label="EasyBuy promotional offers">

        <%-- SECTION 4A: PROMOTIONAL SLIDES TRACK --%>
        <div class="products-promo-track">

            <%-- SLIDE 1: EVERYDAY SHOPPING OFFER --%>
            <a href="<%= contextPath %>/products"
               class="products-promo-slide promo-slide-one active">

                <img src="<%= contextPath %>/images/products/product_19.jpg"
                     alt="EasyBuy selected products">

                <div class="products-promo-overlay"></div>

                <div class="products-promo-content">
                    <span class="products-promo-eyebrow">
                        EASYBUY EVERYDAY
                    </span>

                    <h1>
                        Everything you need.<br>
                        All in one place.
                    </h1>

                    <p>
                        Discover fashion, technology, beauty, home,
                        sports and everyday essentials.
                    </p>

                    <div class="promo-offer-text">
                        <span>UP TO</span>
                        <strong>20% OFF</strong>
                        <small>SELECTED PICKS</small>
                    </div>
                </div>
            </a>

            <%-- SLIDE 2: BANK OFFER --%>
            <a href="<%= contextPath %>/products"
               class="products-promo-slide promo-slide-two">

                <img src="<%= contextPath %>/images/products/product_5.jpg"
                     alt="EasyBuy payment benefits">

                <div class="products-promo-overlay"></div>

                <div class="products-promo-content">
                    <span class="products-promo-eyebrow">
                        EASYBUY BANK OFFER
                    </span>

                    <h2>
                        Get up to<br>
                        <span>10% Instant Discount</span>
                    </h2>

                    <p>
                        Save more on your EasyBuy purchases with
                        selected bank cards.
                    </p>

                    <div class="bank-offer-row">
                        <span class="bank-offer-card">ICICI BANK</span>
                        <span class="bank-offer-divider">+</span>
                        <span class="bank-offer-card">AXIS BANK</span>
                    </div>

                    <span class="products-promo-note">
                        On eligible credit and debit cards
                    </span>
                </div>
            </a>

            <%-- SLIDE 3: PAYMENT CARD SAVINGS --%>
            <a href="<%= contextPath %>/products"
               class="products-promo-slide promo-slide-three">

                <img src="<%= contextPath %>/images/products/product_16.jpg"
                     alt="EasyBuy card savings">

                <div class="products-promo-overlay"></div>

                <div class="products-promo-content">
                    <span class="products-promo-eyebrow">
                        EASYBUY CARD OFFER
                    </span>

                    <h2>
                        10% Savings<br>
                        <span>on Big Purchases</span>
                    </h2>

                    <p>
                        Enjoy extra value on selected purchases
                        with eligible payment cards.
                    </p>

                    <div class="credit-card-offer">
                        <span>FLIPKART</span>
                        <b>×</b>
                        <span>AXIS BANK</span>
                    </div>

                    <span class="products-promo-note">
                        Savings on eligible purchases
                    </span>
                </div>
            </a>

        </div>

        <%-- SECTION 4B: MAIN CAROUSEL NAVIGATION DOTS --%>
        <div class="products-promo-dots">
            <button type="button"
                    class="products-promo-dot active"
                    aria-label="Show promotional offer 1"></button>

            <button type="button"
                    class="products-promo-dot"
                    aria-label="Show promotional offer 2"></button>

            <button type="button"
                    class="products-promo-dot"
                    aria-label="Show promotional offer 3"></button>
        </div>

    </section>


    <%-- =====================================================
         SECTION 5: SECONDARY FEATURE HERO CAROUSEL
         This carousel contains three slides:
         1. Style Edit
         2. New Collection
         3. Payment and Technology Offer
         ===================================================== --%>
    <section class="style-hero-carousel"
             aria-label="EasyBuy featured collections">

        <%-- SECTION 5A: SECONDARY CAROUSEL SLIDES TRACK --%>
        <div class="style-hero-track">

            <%-- SLIDE 1: STYLE EDIT --%>
            <a href="<%= contextPath %>/products"
               class="style-hero-slide active">

                <div class="style-hero-copy">
                    <span class="eyebrow">THE STYLE EDIT</span>

                    <h2>
                        Find your<br>
                        <em>everyday look.</em>
                    </h2>

                    <p>
                        From polished essentials to pieces that make
                        a statement, discover styles selected for
                        the way you live.
                    </p>

                    <span class="style-hero-note">
                        <span></span>
                        New styles added to the EasyBuy collection
                    </span>
                </div>

                <div class="style-hero-image">
                    <img src="<%= contextPath %>/images/products/product_4.jpg"
                         alt="EasyBuy everyday fashion collection">
                </div>
            </a>


            <%-- SLIDE 2: NEW COLLECTION --%>
            <a href="<%= contextPath %>/products"
               class="style-hero-slide">

                <div class="style-hero-copy">
                    <span class="eyebrow">THE NEW EDIT</span>

                    <h2>
                        Discover your<br>
                        <em>next favourite.</em>
                    </h2>

                    <p>
                        Explore fresh EasyBuy finds selected for
                        everyday moments, modern living and
                        effortless style.
                    </p>

                    <span class="style-hero-note">
                        <span></span>
                        Fresh picks are waiting for you
                    </span>
                </div>

                <div class="style-hero-image">
                    <img src="<%= contextPath %>/images/products/product_10.jpg"
                         alt="EasyBuy new collection">
                </div>
            </a>


            <%-- SLIDE 3: PAYMENT AND TECHNOLOGY OFFER BANNER --%>
            <a href="<%= contextPath %>/products"
               class="style-hero-slide payment-hero-slide">

                <%-- SLIDE 3A: PAYMENT BANNER IMAGE --%>
                <div class="payment-hero-image">
                    <img src="<%= contextPath %>/images/products/product_5.jpg"
                         alt="EasyBuy payment and technology offers">
                </div>

                <%-- SLIDE 3B: PAYMENT BANNER TEXT AND OFFERS --%>
                <div class="payment-hero-copy">

                    <span class="eyebrow">
                        SMARTER WAY TO SHOP
                    </span>

                    <h2>
                        More value.<br>
                        <em>More possibilities.</em>
                    </h2>

                    <p>
                        Discover smart technology and enjoy more value
                        when you shop on EasyBuy.
                    </p>

                    <%-- SLIDE 3C: THREE PAYMENT AND TECHNOLOGY FEATURES --%>
                    <div class="payment-hero-offers">

                        <%-- OFFER 1: CARD OFFERS --%>
                        <div class="payment-hero-offer">
                            <span class="payment-offer-icon">01</span>
                            <div>
                                <strong>Exclusive card offers</strong>
                                <small>
                                    Explore savings on eligible purchases.
                                </small>
                            </div>
                        </div>

                        <%-- OFFER 2: TECHNOLOGY PRODUCTS --%>
                        <div class="payment-hero-offer">
                            <span class="payment-offer-icon">02</span>
                            <div>
                                <strong>Technology for everyday life</strong>
                                <small>
                                    Discover useful products and smart essentials.
                                </small>
                            </div>
                        </div>

                        <%-- OFFER 3: EASY SHOPPING --%>
                        <div class="payment-hero-offer">
                            <span class="payment-offer-icon">03</span>
                            <div>
                                <strong>One easy shopping experience</strong>
                                <small>
                                    Find your favourite products in one place.
                                </small>
                            </div>
                        </div>

                    </div>
                </div>
            </a>

        </div>

        <%-- SECTION 5B: SECONDARY CAROUSEL NAVIGATION DOTS --%>
        <div class="style-hero-dots">

            <button type="button"
                    class="style-hero-dot active"
                    aria-label="Show style banner 1"></button>

            <button type="button"
                    class="style-hero-dot"
                    aria-label="Show style banner 2"></button>

            <button type="button"
                    class="style-hero-dot"
                    aria-label="Show payment and technology banner 3"></button>

        </div>

    </section>


    <%-- =====================================================
         SECTION 6: FEATURED COLLECTIONS
         Collection order: Beauty, Home, Sports, Technology, Footwear
         ===================================================== --%>
    <section class="featured-section">

        <%-- SECTION 6A: COLLECTION SECTION HEADING --%>
        <div class="section-heading">
            <div>
                <span class="eyebrow">TRENDING NOW</span>
                <h2>Featured collections.</h2>
                <p>
                    Explore some of the categories worth discovering
                    on easyBuy.
                </p>
            </div>

            <a href="#product-list" class="text-link">
                View all products <span>→</span>
            </a>
        </div>

        <%-- SECTION 6B: COLLECTION CARDS --%>
        <div class="collection-grid">

            <%-- COLLECTION 1: BEAUTY --%>
            <a href="<%= contextPath %>/products" class="collection-card">
                <img src="<%= contextPath %>/images/products/product_16.jpg"
                     alt="Beauty collection">
                <div class="collection-overlay"></div>
                <div class="collection-content">
                    <h3>Beauty</h3>
                    <p>Everyday beauty essentials.</p>
                </div>
            </a>

            <%-- COLLECTION 2: HOME --%>
            <a href="<%= contextPath %>/products" class="collection-card">
                <img src="<%= contextPath %>/images/products/product_8.jpg"
                     alt="Home collection">
                <div class="collection-overlay"></div>
                <div class="collection-content">
                    <h3>Home</h3>
                    <p>Make your space feel yours.</p>
                </div>
            </a>

            <%-- COLLECTION 3: SPORTS --%>
            <a href="<%= contextPath %>/products" class="collection-card">
                <img src="<%= contextPath %>/images/products/product_13.jpg"
                     alt="Sports and fitness collection">
                <div class="collection-overlay"></div>
                <div class="collection-content">
                    <h3>Sports</h3>
                    <p>Move with confidence.</p>
                </div>
            </a>

            <%-- COLLECTION 4: TECHNOLOGY --%>
            <a href="<%= contextPath %>/products" class="collection-card">
                <img src="<%= contextPath %>/images/products/product_7.jpg"
                     alt="Technology collection">
                <div class="collection-overlay"></div>
                <div class="collection-content">
                    <h3>Technology</h3>
                    <p>Smart products for everyday life.</p>
                </div>
            </a>

            <%-- COLLECTION 5: FOOTWEAR --%>
            <a href="<%= contextPath %>/products" class="collection-card">
                <img src="<%= contextPath %>/images/products/product_12.jpg"
                     alt="Footwear collection">
                <div class="collection-overlay"></div>
                <div class="collection-content">
                    <h3>Footwear</h3>
                    <p>Step into something new.</p>
                </div>
            </a>

        </div>
    </section>


    <%-- =====================================================
         SECTION 7: PRODUCT LISTING AREA
         ===================================================== --%>
    <main class="product-area" id="product-list">

        <%-- SECTION 7A: PRODUCT LISTING HEADING AND COUNT --%>
        <div class="product-header">
            <div>
                <span class="eyebrow">EASYBUY COLLECTION</span>
                <h2><%= categoryTitle %></h2>
                <p><%= categoryDescription %></p>
            </div>

        </div>

        <%-- SECTION 7B: FILTER SIDEBAR AND PRODUCT CONTENT LAYOUT --%>
        <div class="product-layout">

            <%-- SECTION 7C: PRODUCT FILTER FORM --%>
            <aside class="filter-sidebar">

                <div class="filter-heading">
                    <span class="eyebrow">REFINE</span>
                    <h3>Find your product.</h3>
                </div>

                <form action="<%= contextPath %>/products"
                      method="get"
                      class="filter-form">

                    <%-- FILTER 1: SEARCH PRODUCTS --%>
                    <div class="filter-group">
                        <label for="search">Search</label>
                        <input type="text"
                               id="search"
                               name="search"
                               value="<%= search %>"
                               placeholder="Search products...">
                    </div>

                    <%-- FILTER 2: CATEGORY --%>
                    <div class="filter-group">
                        <label for="categoryId">Category</label>

                        <select id="categoryId" name="categoryId">
                            <option value="">All Categories</option>

                            <% for (Category category : categories) { %>
                                <option value="<%= category.getCategoryId() %>"
                                    <%= selectedCategoryId != null
                                        && selectedCategoryId.intValue()
                                        == category.getCategoryId()
                                        ? "selected" : "" %>>
                                    <%= category.getCategoryName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <%-- FILTER 3: MINIMUM AND MAXIMUM PRICE --%>
                    <div class="filter-group">
                        <label>Price Range</label>

                        <div class="price-inputs">
                            <input type="number"
                                   min="0"
                                   step="any"
                                   name="minPrice"
                                   value="<%= minPrice %>"
                                   placeholder="Min">

                            <span>—</span>

                            <input type="number"
                                   min="0"
                                   step="any"
                                   name="maxPrice"
                                   value="<%= maxPrice %>"
                                   placeholder="Max">
                        </div>
                    </div>

                    <%-- FILTER 4: SIZE --%>
                    <div class="filter-group">
                        <label for="size">Size</label>

                        <select id="size" name="size">
                            <option value="">All Sizes</option>

                            <% for (String availableSize : availableSizes) { %>
                                <option value="<%= availableSize %>"
                                    <%= availableSize.equalsIgnoreCase(selectedSize)
                                        ? "selected" : "" %>>
                                    <%= availableSize %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <%-- FILTER 5: COLOR --%>
                    <div class="filter-group">
                        <label for="color">Color</label>

                        <select id="color" name="color">
                            <option value="">All Colors</option>

                            <% for (String availableColor : availableColors) { %>
                                <option value="<%= availableColor %>"
                                    <%= availableColor.equalsIgnoreCase(selectedColor)
                                        ? "selected" : "" %>>
                                    <%= availableColor %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <%-- FILTER 6: SORT PRODUCTS --%>
                    <div class="filter-group">
                        <label for="sort">Sort By</label>

                        <select id="sort" name="sort">
                            <option value="relevance"
                                <%= "relevance".equals(selectedSort)
                                    ? "selected" : "" %>>
                                Relevance
                            </option>

                            <option value="price_asc"
                                <%= "price_asc".equals(selectedSort)
                                    ? "selected" : "" %>>
                                Price: Low to High
                            </option>

                            <option value="price_desc"
                                <%= "price_desc".equals(selectedSort)
                                    ? "selected" : "" %>>
                                Price: High to Low
                            </option>

                            <option value="name_asc"
                                <%= "name_asc".equals(selectedSort)
                                    ? "selected" : "" %>>
                                Name: A to Z
                            </option>

                            <option value="name_desc"
                                <%= "name_desc".equals(selectedSort)
                                    ? "selected" : "" %>>
                                Name: Z to A
                            </option>
                        </select>
                    </div>

                    <%-- FILTER 7: APPLY AND CLEAR FILTERS --%>
                    <div class="filter-actions">
                        <button type="submit" class="apply-button">
                            Apply Filters <span>→</span>
                        </button>

                        <a href="<%= contextPath %>/products"
                           class="clear-button">
                            Clear Filters
                        </a>
                    </div>

                </form>
            </aside>


            <%-- SECTION 7D: PRODUCT GRID AND EMPTY STATE --%>
            <section class="products-content" aria-label="Products">

                <%-- DISPLAY PRODUCT CARDS WHEN PRODUCTS ARE AVAILABLE --%>
                <% if (!products.isEmpty()) { %>

                    <div class="product-grid">

                        <% for (Product product : products) { %>

                            <%-- INDIVIDUAL PRODUCT CARD --%>
                            <article class="product-card">

                                <%-- PRODUCT VISUAL / EASYBUY GRAPHIC --%>
                                
<%-- PRODUCT IMAGE --%>
<div class="product-visual">
    <%
        String imageName = product.getImageName();

        if (imageName != null && !imageName.trim().isEmpty()) {
            // Encode spaces in the filename for a valid URL.
            String encodedImageName = imageName.trim().replace(" ", "%20");
    %>
        
<img
    src="<%= contextPath %>/images/all-products/<%= imageName.trim().replace(" ", "%20") %>"
    alt="<%= product.getProductName() %>"
    class="product-image"
    loading="lazy"
    onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
>
<div class="product-image-placeholder" style="display: none;">
    Image unavailable
</div>

    <%
        } else {
    %>
        <div class="product-image-placeholder">
            Image coming soon
        </div>
    <%
        }
    %>
</div>


                                <%-- PRODUCT NAME, CATEGORY AND PRICE --%>
                                <div class="product-card-content">

                                    <span class="product-category">
                                        EASYBUY COLLECTION
                                    </span>

                                    <h3 class="product-name">
                                        <%= product.getProductName() %>
                                    </h3>

                                    <div class="product-card-bottom">

                                        <div class="product-price">
                                            <small>₹</small><%= String.format(
                                                Locale.US,
                                                "%.2f",
                                                product.getPrice()) %>
                                        </div>

                                        <%-- LINK TO PRODUCT DETAILS --%>
                                        <a href="<%= contextPath %>/product-details?productId=<%= product.getProductId() %>"
                                           class="view-product">
                                            View Product <span>→</span>
                                        </a>

                                    </div>
                                </div>

                            </article>

                        <% } %>

                    </div>

                <% } else { %>

                    <%-- EMPTY STATE: DISPLAYED WHEN NO PRODUCTS MATCH --%>
                    <div class="empty-products">

                        <div class="empty-symbol">—</div>

                        <span class="eyebrow">EASYBUY COLLECTION</span>

                        <h3>No products found</h3>

                        <p>
                            Try changing your filters or browse all
                            available EasyBuy products.
                        </p>

                        <a href="<%= contextPath %>/products"
                           class="dark-button">
                            Browse All Products <span>→</span>
                        </a>

                    </div>

                <% } %>

            </section>

        </div>
    </main>


    <%-- =====================================================
         SECTION 8: FOOTER
         ===================================================== --%>
    <footer class="footer">

        <div class="footer-inner">

            <%-- SECTION 8A: FOOTER BRAND --%>
            <div class="footer-brand">
                <div class="footer-logo">easy<span>Buy</span></div>
                <p>Your simple and smarter shopping experience.</p>
            </div>

            <%-- SECTION 8B: FOOTER ABOUT TEXT --%>
            <div class="footer-about">
                <span class="eyebrow">EASYBUY</span>
                <h3>Shop simply.<br>Choose confidently.</h3>
                <p>
                    Discover products across fashion, technology,
                    beauty, home and more.
                </p>
            </div>

            <%-- SECTION 8C: FOOTER COPYRIGHT --%>
            <div class="footer-meta">
                <span>easyBuy</span>
                <span>© 2026</span>
            </div>

        </div>
    </footer>

</div>


<%-- =========================================================
     SECTION 9: JAVASCRIPT CAROUSEL FUNCTIONALITY
     Controls both carousels and their navigation dots.
     ========================================================= --%>
<script>
(function () {

    // SECTION 9A: COMMON CAROUSEL SETUP FUNCTION
    function setupCarousel(rootSelector, slideSelector, dotSelector, interval) {

        const root = document.querySelector(rootSelector);

        if (!root) {
            return;
        }

        const slides = Array.from(root.querySelectorAll(slideSelector));
        const dots = Array.from(root.querySelectorAll(dotSelector));

        if (!slides.length) {
            return;
        }

        let current = 0;
        let timer;

        // SECTION 9B: DISPLAY THE SELECTED SLIDE
        function show(index) {

            current = (index + slides.length) % slides.length;

            slides.forEach(function (slide, i) {
                slide.classList.toggle("active", i === current);
            });

            dots.forEach(function (dot, i) {
                dot.classList.toggle("active", i === current);
            });
        }

        // SECTION 9C: AUTOMATIC SLIDE ROTATION
        function start() {
            clearInterval(timer);

            timer = setInterval(function () {
                show(current + 1);
            }, interval);
        }

        // SECTION 9D: NAVIGATION DOT CLICK EVENTS
        dots.forEach(function (dot, index) {
            dot.addEventListener("click", function () {
                show(index);
                start();
            });
        });

        // SECTION 9E: PAUSE WHEN THE MOUSE HOVERS OVER THE CAROUSEL
        root.addEventListener("mouseenter", function () {
            clearInterval(timer);
        });

        // SECTION 9F: RESUME ROTATION WHEN THE MOUSE LEAVES
        root.addEventListener("mouseleave", start);

        // SECTION 9G: SHOW THE FIRST SLIDE AND START ROTATION
        show(0);
        start();
    }

    // SECTION 9H: INITIALIZE THE MAIN PROMOTIONAL CAROUSEL
    setupCarousel(
        ".products-promo-carousel",
        ".products-promo-slide",
        ".products-promo-dot",
        5000
    );

    // SECTION 9I: INITIALIZE THE SECONDARY THREE-SLIDE HERO CAROUSEL
    setupCarousel(
        ".style-hero-carousel",
        ".style-hero-slide",
        ".style-hero-dot",
        5000
    );

})();
</script>

</body>
</html>