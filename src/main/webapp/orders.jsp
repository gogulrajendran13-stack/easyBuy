
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="easyBuy.model.Order" %>

<%
    String contextPath = request.getContextPath();

    List<Order> orders =
        (List<Order>) request.getAttribute("orders");

    Object sessionUser = session.getAttribute("user");
    Object sessionUserId = session.getAttribute("userId");

    String userName = session.getAttribute("userName") != null
        ? session.getAttribute("userName").toString()
        : "";

    boolean loggedIn = sessionUser != null || sessionUserId != null;

    String profileLetter = "U";

    if (!userName.trim().isEmpty()) {
        profileLetter = userName.trim().substring(0, 1).toUpperCase();
    }

    int orderCount = orders != null ? orders.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>easyBuy | My Orders</title>

    <!-- External stylesheet only: all CSS stays in orders.css -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/orders.css?v=4">
</head>

<body>

    <!-- =====================================================
         SECTION 1: NAVBAR - HOME AND PROFILE ONLY
         ===================================================== -->
    <header class="site-header">
        <nav class="navbar">
            <a href="<%= contextPath %>/home" class="logo">
                easy<span>Buy</span>
            </a>

            <div class="nav-links">
                <a href="<%= contextPath %>/home">Home</a>

                <a href="<%= contextPath %>/profile"
                   class="profile-nav-link">
                    <span class="profile-dp"><%= profileLetter %></span>
                    <span>Profile</span>
                </a>
            </div>
        </nav>
    </header>

    <!-- =====================================================
         SECTION 2: ORDERS PAGE CONTAINER
         ===================================================== -->
    <main class="orders-page">

        <!-- =================================================
             SECTION 3: HERO BANNER
             ================================================= -->
        <section class="orders-hero">
            <div class="orders-hero-content">
                <div class="orders-small-text">easyBuy shopping</div>
                <h1>My Orders</h1>
                <p>View and manage your EasyBuy orders.</p>
            </div>
        </section>

        <!-- =================================================
             SECTION 4: ORDER HISTORY
             ================================================= -->
        <section class="orders-section">

            <div class="section-heading">
                <div>
                    <div class="section-label">Order History</div>
                    <h2>Your Orders</h2>
                </div>

                <div class="orders-heading-actions">
                    <span class="orders-count-badge">
                        <%= orderCount %>
                        <%= orderCount == 1 ? "Order" : "Orders" %>
                    </span>

                    <a href="<%= contextPath %>/products"
                       class="shop-button">
                        Continue Shopping
                    </a>
                </div>
            </div>

            <!-- =============================================
                 SECTION 5: LOGIN MESSAGE
                 ============================================= -->
            <% if (!loggedIn) { %>

                <div class="no-orders-card">
                    <div class="no-orders-icon">↗</div>
                    <h3>Please log in</h3>
                    <p>Sign in to view your easyBuy order history.</p>

                    <a href="<%= contextPath %>/login"
                       class="primary-button">
                        Login to Continue
                    </a>
                </div>

            <!-- =============================================
                 SECTION 6: EMPTY ORDER HISTORY
                 ============================================= -->
            <% } else if (orders == null || orders.isEmpty()) { %>

                <div class="no-orders-card">
                    <div class="no-orders-icon">□</div>
                    <h3>No orders yet</h3>
                    <p>
                        You haven't placed any orders yet.
                        Start shopping and your orders will appear here.
                    </p>

                    <a href="<%= contextPath %>/products"
                       class="primary-button">
                        Start Shopping
                    </a>
                </div>

            <!-- =============================================
                 SECTION 7: ORDER LIST
                 ============================================= -->
            <% } else { %>

                <div class="orders-list">

                    <% for (Order order : orders) {

                        String status = order.getOrderStatus();

                        if (status == null || status.trim().isEmpty()) {
                            status = "PENDING";
                        }

                        String statusClass;

                        if ("CONFIRMED".equalsIgnoreCase(status)
                                || "SUCCESS".equalsIgnoreCase(status)
                                || "DELIVERED".equalsIgnoreCase(status)) {
                            statusClass = "status-confirmed";
                        } else if ("PENDING".equalsIgnoreCase(status)
                                || "PROCESSING".equalsIgnoreCase(status)) {
                            statusClass = "status-pending";
                        } else if ("CANCELLED".equalsIgnoreCase(status)
                                || "CANCELED".equalsIgnoreCase(status)
                                || "FAILED".equalsIgnoreCase(status)) {
                            statusClass = "status-cancelled";
                        } else {
                            statusClass = "status-other";
                        }

                        String orderDateText =
                            order.getOrderDate() != null
                                ? order.getOrderDate().toString()
                                : "Not available";
                    %>

                        <!-- =================================
                             SECTION 8: INDIVIDUAL ORDER CARD
                             ================================= -->
                        <article class="order-card">

                            <!-- Order number only; no duplicate status badge -->
                            <div class="order-card-header">
                                <div>
                                    <div class="order-label">Order</div>
                                    <h3>Order #<%= order.getOrderId() %></h3>
                                </div>
                            </div>

                            <!-- =================================
                                 SECTION 9: ORDER DETAILS
                                 Status appears only here.
                                 ================================= -->
                            <div class="order-card-details">

                                <div class="order-detail">
                                    <span>Order Date</span>
                                    <strong><%= orderDateText %></strong>
                                </div>

                                <div class="order-detail">
                                    <span>Total</span>
                                    <strong class="order-amount">
                                        Rs. <%= String.format(
                                            java.util.Locale.US,
                                            "%.2f",
                                            order.getTotalAmount()
                                        ) %>
                                    </strong>
                                </div>

                                <div class="order-detail">
                                    <span>Status</span>
                                    <strong class="<%= statusClass %>">
                                        <%= status %>
                                    </strong>
                                </div>

                            </div>

                            <!-- =================================
                                 SECTION 10: ORDER ACTIONS
                                 ================================= -->
                            <div class="order-card-actions">

                                <a href="<%= contextPath %>/orders?action=view&amp;orderId=<%= order.getOrderId() %>"
                                   class="view-order-button">
                                    View Order
                                </a>

                                <a href="<%= contextPath %>/orders?action=items&amp;orderId=<%= order.getOrderId() %>"
                                   class="items-button">
                                    View Items
                                </a>

                                <% if (!status.equalsIgnoreCase("CANCELLED")
                                        && !status.equalsIgnoreCase("CANCELED")
                                        && !status.equalsIgnoreCase("DELIVERED")
                                        && !status.equalsIgnoreCase("FAILED")) { %>

                                    <form action="<%= contextPath %>/orders"
                                          method="post"
                                          class="cancel-order-form">

                                        <input type="hidden"
                                               name="action"
                                               value="cancel">

                                        <input type="hidden"
                                               name="orderId"
                                               value="<%= order.getOrderId() %>">

                                        <button type="submit"
                                                class="cancel-order-button"
                                                onclick="return confirm('Are you sure you want to cancel Order #<%= order.getOrderId() %>?');">
                                            Cancel Order
                                        </button>
                                    </form>

                                <% } %>

                            </div>

                        </article>

                    <% } %>

                </div>

            <% } %>

        </section>
    </main>

    <!-- =====================================================
         SECTION 11: EXACT FOOTER MARKUP FROM PRODUCT DETAILS
         Keep these classes matched with orders.css.
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
         SECTION 12: BACK-TO-TOP INTERACTION
         ===================================================== -->
    <script>
        const backToTopLink = document.getElementById("backToTop");

        if (backToTopLink) {
            backToTopLink.addEventListener("click", function (event) {
                event.preventDefault();

                window.scrollTo({
                    top: 0,
                    behavior: "smooth"
                });
            });
        }
    </script>

</body>
</html>
