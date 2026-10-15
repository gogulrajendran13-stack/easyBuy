
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="easyBuy.model.Order" %>
<%@ page import="easyBuy.model.OrderItem" %>

<%@ page import="java.util.Map" %>
<%@ page import="easyBuy.model.Product" %>


<%
    String contextPath = request.getContextPath();
    Order order = (Order) request.getAttribute("order");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");

    String status = order == null || order.getOrderStatus() == null
            ? "" : order.getOrderStatus().trim();

    String statusClass = "status-pending";

    if ("CONFIRMED".equalsIgnoreCase(status)
            || "PLACED".equalsIgnoreCase(status)
            || "PROCESSING".equalsIgnoreCase(status)) {
        statusClass = "status-confirmed";
    } else if ("CANCELLED".equalsIgnoreCase(status)
            || "CANCELED".equalsIgnoreCase(status)
            || "FAILED".equalsIgnoreCase(status)) {
        statusClass = "status-cancelled";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>easyBuy | Order Details</title>

    <!-- External CSS only; styling is in order.css -->
    <link rel="stylesheet" href="<%= contextPath %>/css/order.css?v=3">
</head>
<body>

    <!-- NAVBAR: Home and Profile only -->
    <nav class="navbar">
        <a href="<%= contextPath %>/home" class="logo">easy<span>Buy</span></a>

        <div class="nav-links">
            <a href="<%= contextPath %>/home">Home</a>
            
<!-- Profile navigation link with circular profile icon -->
<a href="<%= contextPath %>/profile" class="order-header-action">
    <span class="order-profile-icon" aria-hidden="true">G</span>
    <span>Profile</span>
</a>

        </div>
    </nav>

    <main class="order-page">

        <!-- HERO BANNER -->
        <section class="order-hero">
            <div class="order-hero-content">
                <div class="order-small-text">easyBuy order</div>
                <h1>Order Details</h1>
                <p>Review your order information and selected products.</p>
            </div>
        </section>

        <% if (order == null) { %>

            <!-- ORDER NOT FOUND -->
            <section class="order-empty">
                <div class="order-empty-icon">!</div>
                <h2>Order not found</h2>
                <p>We could not find the requested order.</p>
                <a href="<%= contextPath %>/products" class="primary-button">
                    Continue Shopping
                </a>
            </section>

        <% } else { %>

            <!-- ORDER SUMMARY -->
            <section class="order-summary-card">

                <div class="order-title-row">
                    <div>
                        <div class="section-label">ORDER</div>
                        <h2>Order #<%= order.getOrderId() %></h2>
                    </div>
                </div>

                <div class="order-details-grid">

                    <div class="order-detail-box">
                        <span>ORDER ID</span>
                        <strong><%= order.getOrderId() %></strong>
                    </div>

                    <div class="order-detail-box">
                        <span>USER ID</span>
                        <strong><%= order.getUserId() %></strong>
                    </div>

                    <div class="order-detail-box">
                        <span>ORDER DATE</span>
                        <strong><%= order.getOrderDate() %></strong>
                    </div>

                    <div class="order-detail-box">
                        <span>TOTAL AMOUNT</span>
                        <strong class="order-total">
                            Rs. <%= order.getTotalAmount() %>
                        </strong>

                        <!-- Status appears only once, beside the total -->
                        <span class="order-status <%= statusClass %>">
                            <%= status.isEmpty() ? "PENDING" : status %>
                        </span>
                    </div>

                </div>
            </section>

            <!-- ORDERED PRODUCTS -->
            <section class="order-items-section">

                <div class="section-heading">
                    <div>
                        <div class="section-label">PRODUCTS</div>
                        <h2>Your Ordered Products</h2>
                    </div>

                    <span class="item-count">
                        <%= orderItems == null ? 0 : orderItems.size() %> item(s)
                    </span>
                </div>

                <% if (orderItems == null || orderItems.isEmpty()) { %>

                    <div class="no-order-items">
                        <div class="no-items-icon">🛍</div>
                        <h3>No items found</h3>
                        <p>This order does not contain any products.</p>
                    </div>

                <% } else { %>

                    <div class="order-items-card">

                        <% for (OrderItem item : orderItems) { %>

                            <article class="order-item">

                                <!-- Product image -->
                                
<%
    Map<Integer, Product> orderedProducts =
            (Map<Integer, Product>) request.getAttribute("orderedProducts");

    Product orderedProduct = orderedProducts == null
            ? null
            : orderedProducts.get(item.getProductId());

    String imageName = orderedProduct == null
            ? null
            : orderedProduct.getImageName();

    String imagePath = null;

    if (imageName != null && !imageName.trim().isEmpty()) {
        imagePath = contextPath + "/images/all-products/"
                + java.net.URLEncoder.encode(
                        imageName.trim(),
                        "UTF-8"
                ).replace("+", "%20");
    }
%>

<!-- Product image: use the image belonging to this order item -->
<div class="order-item-image">
    <% if (imagePath != null) { %>
        <img
            src="<%= imagePath %>"
            alt="<%= orderedProduct.getProductName() %>"
            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
    <% } %>

    <span class="image-fallback"
          style="<%= imagePath == null ? "display:flex;" : "display:none;" %>">🛍</span>
</div>


                                <!-- Product information -->
                                <div class="order-item-info">
                                    <div class="item-label">PRODUCT</div>
                                    <h3>Product #<%= item.getProductId() %></h3>
                                    <p>
                                        Product ID:
                                        <strong><%= item.getProductId() %></strong>
                                    </p>
                                </div>

                                <!-- Quantity -->
                                <div class="order-item-quantity">
                                    <span>QUANTITY</span>
                                    <strong><%= item.getQuantity() %></strong>
                                </div>

                                <!-- Price -->
                                <div class="order-item-price">
                                    <span>PRICE</span>
                                    <strong>Rs. <%= item.getPrice() %></strong>
                                </div>

                                <!-- Subtotal -->
                                <div class="order-item-subtotal">
                                    <span>SUBTOTAL</span>
                                    <strong>Rs. <%= item.getSubtotal() %></strong>
                                </div>

                            </article>

                        <% } %>

                    </div>

                <% } %>
            </section>

            <!-- PAGE ACTIONS -->
            <section class="order-actions">
                <a href="<%= contextPath %>/products" class="secondary-button">
                    Continue Shopping
                </a>

                <a href="<%= contextPath %>/cart" class="primary-button">
                    View Cart
                </a>
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

</body>
</html>
