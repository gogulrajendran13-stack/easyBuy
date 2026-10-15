
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="easyBuy.model.Order" %>
<%@ page import="easyBuy.model.OrderItem" %>

<%
    String contextPath = request.getContextPath();

    List<OrderItem> orderItems =
        (List<OrderItem>) request.getAttribute("orderItems");

    Order order = (Order) request.getAttribute("order");

    Integer orderId = (Integer) request.getAttribute("orderId");

    String userName = session.getAttribute("userName") != null
        ? session.getAttribute("userName").toString() : "";

    String profileLetter = "G";
    if (!userName.trim().isEmpty()) {
        profileLetter = userName.trim().substring(0, 1).toUpperCase();
    }

    if (orderId == null && order != null) {
        orderId = order.getOrderId();
    }

    String orderStatus = order != null
        && order.getOrderStatus() != null
        && !order.getOrderStatus().trim().isEmpty()
        ? order.getOrderStatus() : "PENDING";

    String orderDate = order != null && order.getOrderDate() != null
        ? order.getOrderDate().toString() : "Not available";

    String orderTotal = order != null
        ? String.format("%.2f", order.getTotalAmount()) : "0.00";

    String statusClass = "status-pending";
    if ("CONFIRMED".equalsIgnoreCase(orderStatus)
            || "SUCCESS".equalsIgnoreCase(orderStatus)) {
        statusClass = "status-confirmed";
    } else if ("CANCELLED".equalsIgnoreCase(orderStatus)
            || "CANCELED".equalsIgnoreCase(orderStatus)) {
        statusClass = "status-cancelled";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>easyBuy | Order Items</title>

    <style>
        /* =====================================================
           GLOBAL STYLES
        ===================================================== */
        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #FCFBF8;
            color: #242127;
        }

        a {
            text-decoration: none;
        }

        /* =====================================================
           HEADER / NAVIGATION
           Only Home and Profile are displayed
        ===================================================== */
        .navbar {
            width: 100%;
            min-height: 74px;
            padding: 0 6%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            background: #FFFFFF;
            border-bottom: 1px solid #E9E2FF;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        /* easyBuy logo styling */
        .brand {
            color: #242127;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.8px;
            white-space: nowrap;
        }

        .brand-buy {
            color: #5433EB;
        }

        .nav-links {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 28px;
        }

        .nav-links > a {
            color: #4F465B;
            font-size: 15px;
            font-weight: 600;
            white-space: nowrap;
            transition: color 0.2s ease;
        }

        .nav-links > a:hover {
            color: #5433EB;
        }

        /* Profile link and circular profile icon */
        .profile-nav-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
        }

        .profile-dp {
            width: 32px;
            height: 32px;
            flex: 0 0 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: #E9E2FF;
            color: #5433EB;
            font-size: 12px;
            font-weight: 800;
        }

        /* =====================================================
           MAIN PAGE CONTAINER
        ===================================================== */
        .page {
            width: 88%;
            max-width: 1100px;
            margin: 48px auto 70px;
        }

        /* =====================================================
           PAGE INTRODUCTION
        ===================================================== */
        .hero {
            text-align: center;
            margin-bottom: 30px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 14px;
            border-radius: 999px;
            background: #EEE8FF;
            color: #5433EB;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.7px;
            margin-bottom: 13px;
        }

        .hero h1 {
            margin: 0;
            color: #3921A7;
            font-size: 38px;
            letter-spacing: -0.8px;
        }

        .hero p {
            max-width: 680px;
            margin: 11px auto 0;
            color: #716780;
            font-size: 15px;
            line-height: 1.7;
        }

        /* =====================================================
           ORDER SUMMARY
        ===================================================== */
        .order-summary-card {
            margin-bottom: 22px;
            padding: 23px 26px;
            background: #FFFFFF;
            border: 1px solid #E5DCFF;
            border-radius: 19px;
            box-shadow: 0 10px 28px rgba(57, 33, 167, 0.06);
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        .meta-box {
            padding: 13px 15px;
            background: #FAF8FF;
            border: 1px solid #E5DCFF;
            border-radius: 13px;
            min-width: 0;
        }

        .meta-label {
            margin-bottom: 6px;
            color: #796F8B;
            font-size: 10px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.7px;
        }

        .meta-value {
            color: #242127;
            font-size: 14px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .meta-value.status-confirmed {
            color: #16803D;
        }

        .meta-value.status-pending {
            color: #B96A00;
        }

        .meta-value.status-cancelled {
            color: #D62828;
        }

        /* =====================================================
           ORDERED PRODUCTS CARD
        ===================================================== */
        .items-card {
            background: #FFFFFF;
            border: 1px solid #E5DCFF;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(57, 33, 167, 0.06);
            overflow: hidden;
        }

        .items-header {
            padding: 22px 26px;
            background: #FAF8FF;
            border-bottom: 1px solid #E5DCFF;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .items-header h2 {
            margin: 0;
            color: #3921A7;
            font-size: 21px;
        }

        .items-count {
            padding: 7px 12px;
            border-radius: 999px;
            background: #E9E2FF;
            color: #5433EB;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        /* =====================================================
           EMPTY ORDER MESSAGE
        ===================================================== */
        .empty-items {
            padding: 65px 25px;
            text-align: center;
        }

        .empty-icon {
            font-size: 44px;
            margin-bottom: 12px;
        }

        .empty-items h3 {
            margin: 0 0 8px;
            color: #3921A7;
            font-size: 21px;
        }

        .empty-items p {
            margin: 0;
            color: #796F8B;
            font-size: 14px;
        }

        /* =====================================================
           INDIVIDUAL ORDER ITEM
        ===================================================== */
        .item-row {
            display: grid;
            grid-template-columns: 70px minmax(0, 1fr) 95px 110px 120px;
            gap: 17px;
            align-items: center;
            padding: 21px 26px;
            border-bottom: 1px solid #EEE9FA;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-icon {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            background: linear-gradient(135deg, #EEE8FF, #DCD0FF);
            font-size: 27px;
        }

        .item-name-label {
            margin-bottom: 5px;
            color: #6C55C7;
            font-size: 9px;
            font-weight: 800;
            letter-spacing: 1.2px;
            text-transform: uppercase;
        }

        .item-name {
            color: #242127;
            font-size: 16px;
            font-weight: 800;
            line-height: 1.35;
            overflow-wrap: anywhere;
        }

        .item-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
            min-width: 0;
        }

        .item-info span {
            color: #796F8B;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .item-info strong {
            color: #242127;
            font-size: 13px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .item-subtotal {
            color: #5433EB !important;
            font-size: 14px !important;
            font-weight: 800 !important;
        }

        /* =====================================================
           PAGE ACTION BUTTONS
        ===================================================== */
        .actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin-top: 24px;
        }

        .back-button,
        .shop-button {
            min-height: 50px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 19px;
            border-radius: 13px;
            font-size: 14px;
            font-weight: 800;
            transition: all 0.2s ease;
        }

        .back-button {
            background: #F4F0FF;
            color: #3921A7;
            border: 1px solid #E1D6FF;
        }

        .back-button:hover {
            background: #E9E2FF;
        }

        .shop-button {
            background: #5433EB;
            color: #FFFFFF;
            box-shadow: 0 8px 20px rgba(84, 51, 235, 0.15);
        }

        .shop-button:hover {
            background: #3921A7;
            transform: translateY(-1px);
        }

        /* =====================================================
           FOOTER - MATCHING THE CART / PRODUCT DETAILS STYLE
        ===================================================== */
        .site-footer {
            margin-top: 60px;
            padding: 65px 5% 24px;
            background: #F5F1FF;
            border-top: 1px solid #E5DCFF;
            color: #716780;
        }

        .footer-main {
            display: grid;
            grid-template-columns: 1.4fr 0.9fr 1fr 1fr;
            gap: 45px;
            padding-bottom: 45px;
        }

        .footer-brand {
            display: inline-block;
            margin-bottom: 20px;
            color: #242127;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.8px;
        }

        .footer-description {
            margin: 0;
            color: #796F8B;
            font-size: 13px;
            line-height: 1.7;
        }

        .footer-column h3 {
            margin: 7px 0 22px;
            color: #242127;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .footer-column a {
            display: block;
            width: fit-content;
            margin-bottom: 16px;
            color: #716780;
            font-size: 12px;
            transition: color 0.2s ease;
        }

        .footer-column a:hover {
            color: #5433EB;
        }

        .footer-tagline {
            color: #5433EB !important;
            font-size: 10px !important;
            font-weight: 800;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .footer-bottom {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            align-items: center;
            gap: 15px;
            padding-top: 25px;
            border-top: 1px solid #E1D6FF;
            color: #796F8B;
            font-size: 11px;
        }

        .footer-bottom p {
            margin: 0;
        }

        .footer-bottom-center {
            text-align: center;
        }

        .back-to-top {
            justify-self: end;
            color: #3921A7;
            white-space: nowrap;
        }

        .back-to-top:hover {
            color: #5433EB;
        }

        /* =====================================================
           RESPONSIVE - TABLETS
        ===================================================== */
        @media (max-width: 850px) {
            .navbar {
                padding: 17px 6%;
                min-height: auto;
            }

            .nav-links {
                gap: 20px;
            }

            .order-summary-card {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .item-row {
                grid-template-columns: 65px minmax(0, 1fr) 90px;
                gap: 15px;
            }

            .item-info:nth-last-child(-n+2) {
                grid-column: auto;
            }

            .footer-main {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 35px;
            }
        }

        /* =====================================================
           RESPONSIVE - MOBILE
        ===================================================== */
        @media (max-width: 600px) {
            .navbar {
                gap: 15px;
                padding: 15px 5%;
            }

            .brand {
                font-size: 25px;
            }

            .nav-links {
                gap: 14px;
            }

            .nav-links > a {
                font-size: 13px;
            }

            .profile-nav-link {
                gap: 6px;
            }

            .profile-dp {
                width: 28px;
                height: 28px;
                flex-basis: 28px;
            }

            .page {
                width: 92%;
                margin-top: 34px;
            }

            .hero h1 {
                font-size: 31px;
            }

            .order-summary-card {
                grid-template-columns: 1fr;
                padding: 18px;
            }

            .items-header {
                padding: 19px;
                flex-direction: column;
                align-items: flex-start;
            }

            .item-row {
                grid-template-columns: 58px minmax(0, 1fr);
                padding: 18px 19px;
                gap: 14px;
            }

            .item-icon {
                width: 52px;
                height: 52px;
                border-radius: 14px;
            }

            .item-info {
                grid-column: 2;
            }

            .actions {
                flex-direction: column;
            }

            .back-button,
            .shop-button {
                width: 100%;
            }

            .footer-main {
                grid-template-columns: 1fr 1fr;
                gap: 30px 20px;
            }

            .footer-bottom {
                grid-template-columns: 1fr;
                text-align: center;
                gap: 16px;
            }

            .footer-bottom-center {
                text-align: center;
            }

            .back-to-top {
                justify-self: center;
            }
        }

        @media (max-width: 380px) {
            .navbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .nav-links {
                width: 100%;
                justify-content: flex-start;
            }

            .footer-main {
                grid-template-columns: 1fr;
            }
        }
        
        
/* =====================================================
   COLOR CORRECTIONS ONLY
   Keep the existing layout and dimensions unchanged
===================================================== */

/* Page background and normal text */
body {
    background: #FCFBF8;
    color: #242127;
}

/* Navbar: neutral text, retain easyBuy branding */
.nav-links > a {
    color: #4F465B;
}

.nav-links > a:hover {
    color: #5433EB;
}

/* Profile icon: soft lavender, not strong purple */
.profile-dp {
    background: #E9E2FF;
    color: #4F465B;
}

/* Main heading: dark neutral */
.hero h1 {
    color: #30283A;
}

/* Badge: muted lavender */
.hero-badge {
    background: #F1ECFA;
    color: #655477;
}

/* Supporting text */
.hero p {
    color: #716A76;
}

/* Cards: white with subtle neutral borders */
.order-summary-card,
.items-card {
    background: #FFFFFF;
    border-color: #E9E2EE;
}

/* Summary boxes */
.meta-box {
    background: #FBF9FC;
    border-color: #EAE3EF;
}

/* Labels and ordinary values */
.meta-label,
.item-info span {
    color: #817887;
}

.meta-value,
.item-name,
.item-info strong {
    color: #29232D;
}

/* Status colors: meaningful and distinct */
.meta-value.status-confirmed {
    color: #218347;
}

.meta-value.status-pending {
    color: #B96A00;
}

.meta-value.status-cancelled {
    color: #D43838;
}

/* Product section heading: dark neutral */
.items-header {
    background: #FAF8FC;
    border-color: #EAE3EF;
}

.items-header h2 {
    color: #30283A;
}

/* Item count: soft neutral lavender */
.items-count {
    background: #F0EBF8;
    color: #655477;
}

/* Product icon background */
.item-icon {
    background: linear-gradient(135deg, #F3EFF8, #E8E0F2);
}

/* Product label: muted, not bright purple */
.item-name-label {
    color: #81718E;
}

/* Subtotal: dark neutral */
.item-subtotal {
    color: #51445D !important;
}

/* Back buttons: neutral lavender */
.back-button {
    background: #F4F0F7;
    color: #51445D;
    border-color: #E4D9EB;
}

.back-button:hover {
    background: #EAE3F0;
}

/* Continue Shopping: retain purple */
.shop-button {
    background: #5433EB;
    color: #FFFFFF;
}

.shop-button:hover {
    background: #3921A7;
}

/* Footer: same four-column layout, soft lavender background */
.site-footer {
    background: #F5F1FF;
    border-top-color: #E5DCFF;
    color: #716780;
}

.footer-column h3 {
    color: #30283A;
}

.footer-column a {
    color: #716780;
}

.footer-column a:hover {
    color: #5433EB;
}

/* Keep easyBuy brand purple */
.brand,
.footer-brand {
    color: #242127;
}

.brand-buy {
    color: #5433EB;
}

.footer-tagline {
    color: #655477 !important;
}

/* Footer divider and bottom text */
.footer-bottom {
    border-top-color: #E5DCFF;
    color: #817887;
}

.back-to-top {
    color: #51445D;
}

.back-to-top:hover {
    color: #5433EB;
}
        
    </style>
</head>

<body>

    <!-- =====================================================
         HEADER: LOGO, HOME AND PROFILE ONLY
    ===================================================== -->
    <nav class="navbar">
        <a href="<%= contextPath %>/home" class="brand">
            easy<span class="brand-buy">Buy</span>
        </a>

        <div class="nav-links">
            <a href="<%= contextPath %>/home">Home</a>

            <a href="<%= contextPath %>/profile" class="profile-nav-link">
                <span class="profile-dp"><%= profileLetter %></span>
                <span>Profile</span>
            </a>
        </div>
    </nav>

    <!-- =====================================================
         MAIN PAGE
    ===================================================== -->
    <main class="page">

        <!-- PAGE INTRODUCTION -->
        <section class="hero">
            <div class="hero-badge">easyBuy Order Details</div>

            <h1>Order Items</h1>

            <p>Review the products included in your easyBuy order.</p>
        </section>

        <!-- =================================================
             ORDER SUMMARY
        ================================================== -->
        <section class="order-summary-card">

            <div class="meta-box">
                <div class="meta-label">Order ID</div>
                <div class="meta-value">
                    #<%= orderId != null ? orderId : "Not available" %>
                </div>
            </div>

            <div class="meta-box">
                <div class="meta-label">Order Date</div>
                <div class="meta-value"><%= orderDate %></div>
            </div>

            <div class="meta-box">
                <div class="meta-label">Order Status</div>
                <div class="meta-value <%= statusClass %>">
                    <%= orderStatus %>
                </div>
            </div>

            <div class="meta-box">
                <div class="meta-label">Order Total</div>
                <div class="meta-value">Rs. <%= orderTotal %></div>
            </div>

        </section>

        <!-- =================================================
             PRODUCTS IN THIS ORDER
        ================================================== -->
        <section class="items-card">

            <div class="items-header">
                <h2>Products in this Order</h2>

                <span class="items-count">
                    <%= orderItems != null ? orderItems.size() : 0 %>
                    <%= orderItems != null && orderItems.size() == 1
                        ? "Item" : "Items" %>
                </span>
            </div>

            <%
                if (orderItems == null || orderItems.isEmpty()) {
            %>

                <!-- EMPTY ORDER STATE -->
                <div class="empty-items">
                    <div class="empty-icon">📦</div>
                    <h3>No order items found</h3>
                    <p>
                        There are currently no products associated
                        with this order.
                    </p>
                </div>

            <%
                } else {
                    for (OrderItem item : orderItems) {
            %>

                <!-- INDIVIDUAL ORDER ITEM -->
                <div class="item-row">

                    <!-- PRODUCT ICON -->
                    <div class="item-icon">🛍️</div>

                    <!-- PRODUCT NAME -->
                    <div>
                        <div class="item-name-label">Product</div>

                        <div class="item-name">
                            Product #<%= item.getProductId() %>
                        </div>
                    </div>

                    <!-- QUANTITY -->
                    <div class="item-info">
                        <span>Quantity</span>
                        <strong><%= item.getQuantity() %></strong>
                    </div>

                    <!-- UNIT PRICE -->
                    <div class="item-info">
                        <span>Unit Price</span>
                        <strong>
                            Rs. <%= String.format("%.2f", item.getPrice()) %>
                        </strong>
                    </div>

                    <!-- SUBTOTAL -->
                    <div class="item-info">
                        <span>Subtotal</span>
                        <strong class="item-subtotal">
                            Rs. <%= String.format("%.2f", item.getSubtotal()) %>
                        </strong>
                    </div>

                </div>

            <%
                    }
                }
            %>

        </section>

        <!-- =================================================
             PAGE ACTIONS
        ================================================== -->
        <div class="actions">

            <a
                href="<%= contextPath %>/orders?action=view&orderId=<%= orderId %>"
                class="back-button">
                ← Back to Order
            </a>

            <a
                href="<%= contextPath %>/my-orders"
                class="back-button">
                My Orders
            </a>

            <a
                href="<%= contextPath %>/products"
                class="shop-button">
                Continue Shopping →
            </a>

        </div>

    </main>

    <!-- =====================================================
         FOOTER: MATCHING CART / PRODUCT DETAILS FOOTER STYLE
    ===================================================== -->
    <footer class="site-footer">

        <div class="footer-main">

            <!-- FOOTER BRAND -->
            <div class="footer-column">
                <a href="<%= contextPath %>/home" class="footer-brand">
                    easy<span class="brand-buy">Buy</span>
                </a>

                <p class="footer-description">
                    Easy shopping. Thoughtfully chosen.
                </p>
            </div>

            <!-- EXPLORE LINKS -->
            <div class="footer-column">
                <h3>Explore</h3>

                <a href="<%= contextPath %>/home">Home</a>
                <a href="<%= contextPath %>/products">Shop all</a>
                <a href="<%= contextPath %>/home#categories">Categories</a>
            </div>

            <!-- ACCOUNT LINKS -->
            <div class="footer-column">
                <h3>Your Account</h3>

                <a href="<%= contextPath %>/profile">Profile</a>
                <a href="<%= contextPath %>/cart">Shopping cart</a>
                <a href="<%= contextPath %>/wishlist">Wishlist</a>
            </div>

            <!-- FOOTER MESSAGE -->
            <div class="footer-column">
                <h3 class="footer-tagline">Made for your everyday</h3>

                <a href="<%= contextPath %>/products">
                    Discover something you love.
                </a>

                <a href="<%= contextPath %>/products">
                    Start exploring ↗
                </a>
            </div>

        </div>

        <!-- FOOTER COPYRIGHT AND BOTTOM LINKS -->
        <div class="footer-bottom">

            <p>© 2026 easyBuy</p>

            <p class="footer-bottom-center">
                Easy Shopping. Easy Buying.
            </p>

            <a href="#" class="back-to-top">Back to top ↑</a>

        </div>

    </footer>

</body>
</html>
