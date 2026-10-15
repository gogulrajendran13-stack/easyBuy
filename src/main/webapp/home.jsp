<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Locale" %>
<%@ page import="easyBuy.model.Category" %>
<%@ page import="easyBuy.model.Product" %>

<%!
    private int findCategoryId(List<Category> categories, String wanted) {
        if (categories == null || wanted == null) return -1;

        String target = wanted.trim().toLowerCase(Locale.ROOT);

        for (Category category : categories) {
            if (category == null || category.getCategoryName() == null) {
                continue;
            }

            String name =
                    category.getCategoryName()
                            .trim()
                            .toLowerCase(Locale.ROOT);

            if (name.equals(target)
                    || name.contains(target)
                    || target.contains(name)) {
                return category.getCategoryId();
            }
        }

        return -1;
    }

    private String categoryImage(String categoryName) {

        if (categoryName == null) {
            return "accessories.jpg";
        }

        String name =
                categoryName
                        .trim()
                        .toLowerCase(Locale.ROOT);

        if (name.contains("home")) {
            return "homeequipment.jpg";
        }

        if (name.contains("electronic")) {
            return "headphone.jpg";
        }

        if (name.contains("fashion")) {
            return "clothes.jpg";
        }

        if (name.contains("sport")) {
            return "sports.jpg";
        }

        if (name.contains("furniture")) {
            return "furnitures.jpg";
        }

        if (name.contains("beauty")) {
            return "makeup.jpg";
        }

        if (name.contains("mobile")) {
            return "mobiles.jpg";
        }

        if (name.contains("toy")) {
            return "toys.jpg";
        }

        if (name.contains("grocer")) {
            return "grocery.jpg";
        }

        return "accessories.jpg";
    }

    private String productCategoryImage(
            List<Category> categories,
            int categoryId) {

        if (categories != null) {

            for (Category category : categories) {

                if (category != null
                        && category.getCategoryId() == categoryId) {

                    return categoryImage(
                            category.getCategoryName()
                    );
                }
            }
        }

        return "accessories.jpg";
    }
%>

<%
    String contextPath = request.getContextPath();

    List<Category> categories =
            (List<Category>)
            request.getAttribute("categories");

    List<Product> products =
            (List<Product>)
            request.getAttribute("products");

    if (categories == null) {
        categories = new ArrayList<Category>();
    }

    if (products == null) {
        products = new ArrayList<Product>();
    }

    Integer menCategoryId =
            (Integer)
            request.getAttribute("menCategoryId");

    Integer womenCategoryId =
            (Integer)
            request.getAttribute("womenCategoryId");

    Integer kidsCategoryId =
            (Integer)
            request.getAttribute("kidsCategoryId");

    Object sessionUserObject =
            session.getAttribute("user");

    Object sessionUserId =
            session.getAttribute("userId");

    String sessionUserName =
            (String)
            session.getAttribute("userName");

    boolean loggedIn =
            sessionUserObject != null
                    || sessionUserId != null;

    String profileLetter = "U";

    if (sessionUserName != null
            && !sessionUserName.trim().isEmpty()) {

        profileLetter =
                sessionUserName
                        .trim()
                        .substring(0, 1)
                        .toUpperCase();
    }

    String displayUserName =
            (sessionUserName == null
                    || sessionUserName.trim().isEmpty())
            ? "Login"
            : sessionUserName.trim();

    Boolean loginSuccess =
            (Boolean)
            session.getAttribute("loginSuccess");

    String loginSuccessMessage =
            (String)
            session.getAttribute("loginSuccessMessage");

    if (loginSuccess == null) {
        loginSuccess = false;
    }

    if (loginSuccessMessage == null
            || loginSuccessMessage.trim().isEmpty()) {

        loginSuccessMessage =
                "Welcome back to easyBuy!";
    }

    if (loginSuccess) {

        session.removeAttribute("loginSuccess");

        session.removeAttribute(
                "loginSuccessMessage"
        );
    }

    String menLink =
            (menCategoryId != null
                    && menCategoryId > 0)

            ? contextPath
                    + "/products?categoryId="
                    + menCategoryId

            : contextPath + "/products";

    String womenLink =
            (womenCategoryId != null
                    && womenCategoryId > 0)

            ? contextPath
                    + "/products?categoryId="
                    + womenCategoryId

            : contextPath + "/products";

    String kidsLink =
            (kidsCategoryId != null
                    && kidsCategoryId > 0)

            ? contextPath
                    + "/products?categoryId="
                    + kidsCategoryId

            : contextPath + "/products";

    String[] categoryNames = {
        "Home Equipment",
        "Electronics",
        "Fashion",
        "Sports",
        "Furniture",
        "Beauty",
        "Mobiles",
        "Toys",
        "Groceries"
    };
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>easyBuy | Home</title>

    <link
        rel="stylesheet"
        type="text/css"
        href="<%= contextPath %>/css/home.css?v=7000">

</head>

<body>

<div class="easybuy-shell">

    <!-- SIDEBAR -->

    <aside class="sidebar">

        <a
            href="<%= contextPath %>/home"
            class="sidebar-brand">

            
<span class="brand-name"><span class="brand-easy">easy</span><span class="brand-buy">Buy</span></span>


        </a>

        <nav class="sidebar-main-nav">

            <a
                href="#popular-products"
                class="sidebar-link js-section-link"
                data-section="popular-products">

                <span class="sidebar-icon icon-grid"></span>

                <span>
                    Popular Products
                </span>

            </a>

            <a
                href="#explore-new"
                class="sidebar-link js-section-link"
                data-section="explore-new">

                <span class="sidebar-icon icon-spark"></span>

                <span>
                    Explore New
                </span>

            </a>

            <a
                href="#home-dashboard"
                class="sidebar-link active js-section-link"
                data-section="home-dashboard">

                <span class="sidebar-icon icon-home"></span>

                <span>
                    Home
                </span>

            </a>

        </nav>

        <div class="sidebar-divider"></div>

        <div class="sidebar-section-title">
            SHOP
        </div>

        <nav class="sidebar-shop-nav">

            <a
                href="<%= menLink %>"
                class="sidebar-link small">

                <span class="sidebar-icon icon-person"></span>

                <span>
                    Men
                </span>

            </a>

            <a
                href="<%= womenLink %>"
                class="sidebar-link small">

                <span class="sidebar-icon icon-person"></span>

                <span>
                    Women
                </span>

            </a>

            <a
                href="<%= kidsLink %>"
                class="sidebar-link small">

                <span class="sidebar-icon icon-person"></span>

                <span>
                    Kids
                </span>

            </a>

        </nav>

        <div class="sidebar-bottom">

            <% if (loggedIn) { %>

                <a
                    href="<%= contextPath %>/logout"
                    class="logout-link">

                    <span class="logout-icon">
                        ↗
                    </span>

                    <span>
                        Logout
                    </span>

                </a>

            <% } else { %>

                <a
                    href="<%= contextPath %>/login"
                    class="logout-link">

                    <span class="logout-icon">
                        ↗
                    </span>

                    <span>
                        Login
                    </span>

                </a>

            <% } %>

        </div>

    </aside>


    <!-- MAIN -->

    <main class="main-area">

        <!-- TOP HEADER -->

        <header class="top-header">

            <div></div>

            <div class="view-switcher">

                <a
                    href="<%= contextPath %>/home"
                    class="view-switch active">

                    Dashboard

                </a>

                <a
                    href="<%= contextPath %>/products"
                    class="view-switch">

                    Shop

                </a>

            </div>

            <div class="header-actions">

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

                <% if (loggedIn) { %>

                    <a
                        href="<%= contextPath %>/profile"
                        class="user-area">

                        <span class="profile-dp">
                            <%= profileLetter %>
                        </span>

                        <span class="profile-name">
                            <%= displayUserName %>
                        </span>

                    </a>

                <% } else { %>

                    <a
                        href="<%= contextPath %>/login"
                        class="user-area">

                        <span class="profile-dp">
                            U
                        </span>

                        <span class="profile-name">
                            Login
                        </span>

                    </a>

                <% } %>

            </div>

        </header>


        <!-- EXPLORE HEADER -->

        <section
            class="explore-header"
            id="home-dashboard">

            <div class="explore-title">

                <h1>
                    Explore
                </h1>

            </div>

            <div class="category-pills">

                <a
                    href="<%= contextPath %>/home"
                    class="category-pill selected">

                    <span class="pill-icon icon-all"></span>

                    All

                </a>

                <a
                    href="<%= menLink %>"
                    class="category-pill">

                    <span class="pill-icon icon-person-pill"></span>

                    Men

                </a>

                <a
                    href="<%= womenLink %>"
                    class="category-pill">

                    <span class="pill-icon icon-person-pill"></span>

                    Women

                </a>

                <a
                    href="<%= kidsLink %>"
                    class="category-pill">

                    <span class="pill-icon icon-person-pill"></span>

                    Kids

                </a>

            </div>

            <div class="explore-actions">

                <a
                    href="<%= contextPath %>/products"
                    class="filters-button">

                    Filters

                </a>

                <form
                    action="<%= contextPath %>/products"
                    method="get"
                    class="search-form"
                    id="searchForm">

                    <input
                        type="text"
                        name="search"
                        placeholder="Search"
                        aria-label="Search products">

                    <button
                        type="submit"
                        aria-label="Search products">

                        <span class="search-icon"></span>

                    </button>

                </form>

            </div>

        </section>


        <!-- LOGIN SUCCESS -->

        <% if (loginSuccess) { %>

            <div class="login-success-notification">

                <div class="login-success-icon">
                    ✓
                </div>

                <div class="login-success-content">

                    <strong>
                        Login successful
                    </strong>

                    <span>
                        <%= loginSuccessMessage %>
                    </span>

                </div>

                <button
                    type="button"
                    class="login-success-close"
                    onclick="this.parentElement.remove();">

                    &times;

                </button>

            </div>

        <% } %>


        <!-- DASHBOARD -->

        <section
            class="home-content-board"
            aria-label="easyBuy dashboard">


            <!-- LARGE HERO -->

            <a
                href="<%= contextPath %>/products"
                class="home-hero-card dashboard-card">

                <div class="home-hero-copy">

                    <span class="eyebrow">
                        EASYBUY SPACE
                    </span>

                    <h2>
                        Make your EasyBuy<br>
                        experience yours.
                    </h2>

                    <p>
                        Keep your favourites close,
                        discover collections, invite
                        friends and follow your personal
                        style journey.
                    </p>

                    <div class="home-hero-actions">

                        <span class="offer-button">
                            Start shopping
                        </span>

                        <span class="hero-text-link">
                            View favourites
                            <span class="arrow">→</span>
                        </span>

                    </div>

                </div>

                <div class="home-hero-art">

                    <div class="hero-orbit"></div>

                    <div class="hero-star">
                        ✦
                    </div>

                </div>

            </a>


            <!-- POPULAR CARD -->

            <a
                href="#popular-products"
                class="home-content-card dashboard-card popular-dashboard-card">

                <div class="content-card-topline">

                    <span class="eyebrow">
                        POPULAR
                    </span>

                    <span class="content-card-icon">
                        ▦
                    </span>

                </div>

                <h3>
                    Popular Products
                </h3>

                <p>
                    Discover products customers
                    are exploring now.
                </p>

                <span class="content-card-link">
                    Explore
                    <span class="arrow">→</span>
                </span>

            </a>


            <!-- FRESH FINDS -->

            <a
                href="#explore-new"
                class="home-content-card dashboard-card fresh-finds-card">

                <div class="content-card-topline">

                    <span class="eyebrow">
                        FRESH FINDS
                    </span>

                    <span class="content-card-icon">
                        ✦
                    </span>

                </div>

                <h3>
                    Fresh Finds
                </h3>

                <p>
                    Discover new arrivals and things
                    worth adding to your cart.
                </p>

                <span class="content-card-link">
                    Discover now
                    <span class="arrow">→</span>
                </span>

            </a>


            <!-- FAVOURITES -->

            <a
                href="<%= contextPath %>/wishlist"
                class="home-content-card dashboard-card favourites-card">

                <div class="content-card-topline">

                    <span class="eyebrow">
                        FAVOURITES
                    </span>

                    <span class="content-card-icon">
                        ♡
                    </span>

                </div>

                <h3>
                    Your Favourites
                </h3>

                <p>
                    Keep the things you love close
                    and easy to find.
                </p>

                <span class="content-card-link">
                    View favourites
                    <span class="arrow">→</span>
                </span>

                <div class="mini-avatar-stack">

                    <span>U</span>
                    <span>★</span>
                    <span>+</span>

                </div>

            </a>


            <!-- STYLE TRACK -->

            <a
                href="<%= contextPath %>/products"
                class="home-content-card dashboard-card style-track-card">

                <div class="content-card-topline">

                    <span class="eyebrow">
                        STYLE TRACK
                    </span>

                    <span class="content-card-icon">
                        ↗
                    </span>

                </div>

                <h3>
                    Follow Your Style
                </h3>

                <p>
                    Keep discovering looks and build
                    your own EasyBuy shopping story.
                </p>

                <span class="content-card-link">
                    Continue exploring
                    <span class="arrow">→</span>
                </span>

                <div class="style-track-line">

                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>

                </div>

            </a>


            <!-- INVITE FRIEND -->

            <a
                href="<%= contextPath %>/invite-friend"
                class="home-content-card dashboard-card invite-card">

                <div class="content-card-topline">

                    <span class="eyebrow">
                        QUICK ACTION
                    </span>

                    <span class="content-card-icon">
                        +
                    </span>

                </div>

                <h3>
                    Invite a Friend
                </h3>

                <p>
                    Share EasyBuy and make shopping
                    more fun together.
                </p>

                <span class="content-card-link">
                    Invite now
                    <span class="arrow">→</span>
                </span>

            </a>


            <!-- FULL WIDTH BOTTOM CARD -->

            <a
                href="#popular-products"
                class="home-wide-card dashboard-card offer-wide-card">

                <div>

                    <span class="eyebrow">
                        EASYBUY OFFERS
                    </span>

                    <h3>
                        Discover what is happening now.
                    </h3>

                    <p>
                        Explore current shopping opportunities,
                        fresh arrivals and seasonal selections.
                    </p>

                    <span class="wide-card-link">
                        View offers →
                    </span>

                </div>

                <span class="wide-card-arrow">
                    ↗
                </span>

            </a>

        </section>


        <!-- POPULAR PRODUCTS -->

        <section
            class="popular-section"
            id="popular-products">

            <div class="section-heading-row">

                <div>

                    <span class="section-eyebrow">
                        EASYBUY PICKS
                    </span>

                    <h2>
                        Popular Products
                    </h2>

                    <p>
                        Discover products worth exploring.
                    </p>

                </div>

            </div>


            <div
                class="popular-carousel"
                id="popularCarousel">

                <div
                    class="popular-slides"
                    id="popularSlides">


                    <!-- SLIDE 1 -->

                    <a
                        href="<%= contextPath %>/products"
                        class="popular-slide active">

                        <div class="popular-image">

                            <img
                                src="<%= contextPath %>/images/categories/clothes2.jpg"
                                alt="Sport picks">

                        </div>

                        <div class="popular-overlay"></div>

                        <div class="popular-slide-content">

                            <span class="slide-eyebrow">
                                ACTIVE PICKS
                            </span>

                            <h3>
                                Move with<br>
                                confidence
                            </h3>

                            <strong>
                                SPORT ESSENTIALS
                            </strong>

                            <span class="slide-button">
                                Explore sports
                                <span>→</span>
                            </span>

                        </div>

                    </a>


                    <!-- SLIDE 2 -->

                    <a
                        href="<%= contextPath %>/products"
                        class="popular-slide">

                        <div class="popular-image">

                            <img
                                src="<%= contextPath %>/images/categories/makeup.jpg"
                                alt="Beauty picks">

                        </div>

                        <div class="popular-overlay"></div>

                        <div class="popular-slide-content">

                            <span class="slide-eyebrow">
                                BEAUTY PICKS
                            </span>

                            <h3>
                                Small details,<br>
                                big difference
                            </h3>

                            <strong>
                                BEAUTY ESSENTIALS
                            </strong>

                            <span class="slide-button">
                                Discover beauty
                                <span>→</span>
                            </span>

                        </div>

                    </a>


                    <!-- SLIDE 3 -->

                    <a
                        href="<%= contextPath %>/products"
                        class="popular-slide">

                        <div class="popular-image">

                            <img
                                src="<%= contextPath %>/images/categories/accessories.jpg"
                                alt="Style picks">

                        </div>

                        <div class="popular-overlay"></div>

                        <div class="popular-slide-content">

                            <span class="slide-eyebrow">
                                STYLE PICKS
                            </span>

                            <h3>
                                Dress your<br>
                                moment
                            </h3>

                            <strong>
                                UP TO 60% OFF
                            </strong>

                            <span class="slide-button">
                                Shop now
                                <span>→</span>
                            </span>

                        </div>

                    </a>


                    <!-- SLIDE 4 -->

                    <a
                        href="<%= contextPath %>/products"
                        class="popular-slide">

                        <div class="popular-image">

                            <img
                                src="<%= contextPath %>/images/categories/headphone.jpg"
                                alt="Tech picks">

                        </div>

                        <div class="popular-overlay"></div>

                        <div class="popular-slide-content">

                            <span class="slide-eyebrow">
                                TECH PICKS
                            </span>

                            <h3>
                                Upgrade your<br>
                                everyday
                            </h3>

                            <strong>
                                SMARTER FINDS
                            </strong>

                            <span class="slide-button">
                                Explore tech
                                <span>→</span>
                            </span>

                        </div>

                    </a>


                    <!-- SLIDE 5 -->

                    <a
                        href="<%= contextPath %>/products"
                        class="popular-slide">

                        <div class="popular-image">

                            <img
                                src="<%= contextPath %>/images/categories/homeequipment.jpg"
                                alt="Home picks">

                        </div>

                        <div class="popular-overlay"></div>

                        <div class="popular-slide-content">

                            <span class="slide-eyebrow">
                                HOME PICKS
                            </span>

                            <h3>
                                Make space<br>
                                feel yours
                            </h3>

                            <strong>
                                NEW HOME FINDS
                            </strong>

                            <span class="slide-button">
                                Shop home
                                <span>→</span>
                            </span>

                        </div>

                    </a>

                </div>

            </div>


            <!-- FIVE DOTS -->

            <div
                class="carousel-dots"
                id="popularDots">

                <button
                    type="button"
                    class="carousel-dot active"
                    data-slide-to="0"
                    aria-label="Popular product slide 1">
                </button>

                <button
                    type="button"
                    class="carousel-dot"
                    data-slide-to="1"
                    aria-label="Popular product slide 2">
                </button>

                <button
                    type="button"
                    class="carousel-dot"
                    data-slide-to="2"
                    aria-label="Popular product slide 3">
                </button>

                <button
                    type="button"
                    class="carousel-dot"
                    data-slide-to="3"
                    aria-label="Popular product slide 4">
                </button>

                <button
                    type="button"
                    class="carousel-dot"
                    data-slide-to="4"
                    aria-label="Popular product slide 5">
                </button>

            </div>

        </section>


        <!-- EXPLORE NEW -->

        <section
            class="explore-new-section"
            id="explore-new">

            <div class="section-heading-row">

                <div>

                    <span class="section-eyebrow">
                        EXPLORE THE COLLECTION
                    </span>

                    <h2>
                        Explore New
                    </h2>

                    <p>
                        Discover fresh collections and new
                        things worth adding to your EasyBuy journey.
                    </p>

                </div>

            </div>


            <!-- TWO BANNER CAROUSEL -->

            <div
                class="hero-carousel"
                id="heroCarousel">

                <div
                    class="hero-slides"
                    id="heroSlides">


                    <!-- BANNER 1 -->

                    <a
                        href="<%= contextPath %>/products"
                        class="hero-slide active">

                        <img
                            src="<%= contextPath %>/images/home/hero_banner.png"
                            alt="easyBuy everything you love in one place"
                            class="explore-hero-image">

                    </a>


                    <!-- BANNER 2 -->

                    <a
                        href="<%= contextPath %>/products"
                        class="hero-slide">

                        <img
                            src="<%= contextPath %>/images/home/hero_banner2.png"
                            alt="Easy shopping easy buying"
                            class="explore-hero-image">

                    </a>

                </div>

            </div>


            <!-- SHOP BY CATEGORY -->

            <div class="new-category-header">

                <span class="section-eyebrow">
                    EASYBUY COLLECTION
                </span>

                <h3>
                    Shop by Category
                </h3>

            </div>


            <div class="new-category-row">

                <% for (
                    int i = 0;
                    i < categoryNames.length;
                    i++
                ) {

                    int categoryId =
                            findCategoryId(
                                categories,
                                categoryNames[i]
                            );

                    String categoryHref =
                            categoryId > 0

                            ? contextPath
                              + "/products?categoryId="
                              + categoryId

                            : contextPath
                              + "/products";

                    String imageName =
                            categoryImage(
                                categoryNames[i]
                            );

                %>

                    <a
                        href="<%= categoryHref %>"
                        class="new-category-card">

                        <div class="category-image-area">

                            <img
                                src="<%= contextPath %>/images/categories/<%= imageName %>"
                                alt="<%= categoryNames[i] %>"
                                onerror="this.onerror=null;this.src='<%= contextPath %>/images/categories/accessories.jpg';">

                        </div>

                        <div class="category-card-info">

                            <h4>
                                <%= categoryNames[i] %>
                            </h4>

                        </div>

                    </a>

                <% } %>

            </div>


            <!-- ALL PRODUCTS -->

            <div class="home-products-heading">

                <span class="section-eyebrow">
                    EASYBUY COLLECTION
                </span>

                <h3>
                    All Products
                </h3>

            </div>


            <% if (!products.isEmpty()) { %>

                <%
                    Set<String> renderedProductNames =
                            new HashSet<String>();

                    int renderedProductCount = 0;
                %>

                <div class="home-product-grid">

                    <% for (Product product : products) {

                        if (product == null
                                || product.getProductName() == null) {
                            continue;
                        }

                        String productKey =
                                product
                                    .getProductName()
                                    .trim()
                                    .toLowerCase(Locale.ROOT);

                        if (!renderedProductNames.add(productKey)) {
                            continue;
                        }

                        renderedProductCount++;

                    %>

                        <a
                            href="<%= contextPath %>/product-details?productId=<%= product.getProductId() %>"
                            class="home-product-card">

                                                       <%-- INDIVIDUAL PRODUCT IMAGE FROM MYSQL --%>
                           <div class="home-product-image">

                               <%
                                   String imageName = product.getImageName();

                                   if (imageName != null
                                           && !imageName.trim().isEmpty()) {

                                       imageName = imageName.trim()
                                               .replace(" ", "%20");
                               %>

                                   <img
                                       src="<%= contextPath %>/images/all-products/<%= imageName %>"
                                       alt="<%= product.getProductName() %>"
                                       loading="lazy"
                                       onerror="this.onerror=null; this.src='<%= contextPath %>/images/categories/accessories.jpg';"
                                   >

                               <%
                                   } else {
                               %>

                                   <img
                                       src="<%= contextPath %>/images/categories/accessories.jpg"
                                       alt="<%= product.getProductName() %>"
                                       loading="lazy"
                                   >

                               <%
                                   }
                               %>

                           </div>

                            <div class="home-product-info">

                                <h4>
                                    <%= product.getProductName() %>
                                </h4>

                                <div class="home-product-bottom">

                                    <strong>
                                        ₹ <%= product.getPrice() %>
                                    </strong>

                                    <span>
                                        View →
                                    </span>

                                </div>

                            </div>

                        </a>

                    <% } %>

                </div>

                <% if (renderedProductCount == 0) { %>

                    <div class="home-products-empty">
                        No products are currently available.
                    </div>

                <% } %>

            <% } else { %>

                <div class="home-products-empty">
                    No products are currently available.
                </div>

            <% } %>

        </section>


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

    </main>

</div>


<script
    src="<%= contextPath %>/js/home.js?v=7000">
</script>

</body>

</html>