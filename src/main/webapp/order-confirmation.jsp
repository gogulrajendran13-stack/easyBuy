
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%!
    private String getStringValue(Object value) {
        if (value == null) {
            return "";
        }
        return String.valueOf(value).trim();
    }

    private BigDecimal getBigDecimalValue(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        try {
            return new BigDecimal(value.toString());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    private String formatDate(Object value) {
        if (value instanceof LocalDateTime) {
            LocalDateTime dateTime = (LocalDateTime) value;
            return dateTime.format(
                DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")
            );
        }
        if (value != null) {
            return value.toString();
        }
        return "";
    }

    private boolean hasAddressValues(
            String houseFlatNumber,
            String buildingName,
            String street,
            String area,
            String landmark,
            String city) {

        return (houseFlatNumber != null && !houseFlatNumber.trim().isEmpty())
            || (buildingName != null && !buildingName.trim().isEmpty())
            || (street != null && !street.trim().isEmpty())
            || (area != null && !area.trim().isEmpty())
            || (landmark != null && !landmark.trim().isEmpty())
            || (city != null && !city.trim().isEmpty());
    }
%>

<%
    String contextPath = request.getContextPath();

    String confirmationError =
        getStringValue(request.getAttribute("confirmationError"));

    Object userObject = session.getAttribute("user");
    Object sessionUserId = session.getAttribute("userId");

    boolean loggedIn = userObject != null || sessionUserId != null;

    if (!loggedIn) {
        response.sendRedirect(contextPath + "/login");
        return;
    }

    String userName = getStringValue(session.getAttribute("userName"));
    String userEmail = getStringValue(session.getAttribute("userEmail"));
    String userPhone = getStringValue(session.getAttribute("userPhone"));

    String orderId = getStringValue(request.getParameter("orderId"));

    if (orderId.isEmpty()) {
        orderId = getStringValue(session.getAttribute("orderId"));
    }

    String orderStatus = getStringValue(session.getAttribute("orderStatus"));

    if (orderStatus.isEmpty()) {
        orderStatus = "CONFIRMED";
    }

    BigDecimal orderTotal =
        getBigDecimalValue(session.getAttribute("orderTotal"));

    String paymentMethod =
        getStringValue(session.getAttribute("paymentMethod"));

    String paymentStatus =
        getStringValue(session.getAttribute("paymentStatus"));

    String paymentTransactionId =
        getStringValue(session.getAttribute("paymentTransactionId"));

    Object paymentDateObject = session.getAttribute("paymentDate");
    String formattedPaymentDate = formatDate(paymentDateObject);

    String receiverName =
        getStringValue(session.getAttribute("checkoutReceiverName"));

    if (receiverName.isEmpty()) {
        receiverName = getStringValue(session.getAttribute("receiverName"));
    }

    String primaryMobile =
        getStringValue(session.getAttribute("checkoutPrimaryMobile"));

    if (primaryMobile.isEmpty()) {
        primaryMobile = getStringValue(session.getAttribute("primaryMobile"));
    }

    String alternateMobile =
        getStringValue(session.getAttribute("checkoutAlternateMobile"));

    if (alternateMobile.isEmpty()) {
        alternateMobile =
            getStringValue(session.getAttribute("alternateMobile"));
    }

    String checkoutEmail =
        getStringValue(session.getAttribute("checkoutEmail"));

    if (checkoutEmail.isEmpty()) {
        checkoutEmail = userEmail;
    }

    String checkoutAddress =
        getStringValue(session.getAttribute("checkoutAddress"));

    String houseFlatNumber =
        getStringValue(session.getAttribute("houseFlatNumber"));

    String buildingName =
        getStringValue(session.getAttribute("buildingName"));

    String street = getStringValue(session.getAttribute("street"));
    String area = getStringValue(session.getAttribute("area"));
    String landmark = getStringValue(session.getAttribute("landmark"));
    String city = getStringValue(session.getAttribute("city"));

    if (receiverName.isEmpty()) {
        receiverName = !userName.isEmpty() ? userName : "Customer";
    }

    if (primaryMobile.isEmpty()) {
        primaryMobile = !userPhone.isEmpty() ? userPhone : "Not available";
    }

    if (checkoutEmail.isEmpty()) {
        checkoutEmail = !userEmail.isEmpty() ? userEmail : "Not available";
    }

    String profileLetter = "U";

    if (!userName.isEmpty()) {
        profileLetter = userName.substring(0, 1).toUpperCase();
    }

    boolean isCashOnDelivery =
        "Cash on Delivery".equalsIgnoreCase(paymentMethod);

    String paymentStatusClass =
        "SUCCESS".equalsIgnoreCase(paymentStatus)
            ? "payment-success"
            : "payment-pending";

    String confirmationTitle;
    String confirmationMessage;

    if (isCashOnDelivery) {
        confirmationTitle = "Order Confirmed";
        confirmationMessage =
            "Your order has been placed successfully. "
            + "Payment will be collected when your order is delivered.";
    } else {
        confirmationTitle = "Payment Successful";
        confirmationMessage =
            "Your payment has been recorded successfully "
            + "and your easyBuy order is confirmed.";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>easyBuy | Order Confirmation</title>

    <style>
        /* ================= GLOBAL STYLES ================= */
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

        /* ================= NAVIGATION BAR ================= */
        .navbar {
            width: 100%;
            padding: 18px 6%;
            background: #FFFFFF;
            border-bottom: 1px solid #E9E2FF;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 30px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        /* Logo: easy black, Buy blue */
.brand {
    color: #242127;
    font-size: 25px;
    font-weight: 800;
    letter-spacing: -0.5px;
    white-space: nowrap;
}

.brand-easy {
    color: #242127;
}

.brand-buy {
    color: #5433EB;
}


        .nav-links {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 26px;
            flex-wrap: wrap;
        }

        .nav-links a {
            color: #3921A7;
            font-size: 15px;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .nav-links a:hover {
            color: #6C55C7;
        }

        .profile-nav-link,
        .cart-nav-link {
            min-height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 0;
            margin: 0;
            background: transparent;
            border: none;
            color: #3921A7;
            font-size: 15px;
            font-weight: 600;
            line-height: 1;
            white-space: nowrap;
        }

        .profile-dp {
            width: 28px;
            height: 28px;
            flex: 0 0 28px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: #E9E2FF;
            color: #3921A7;
            font-size: 12px;
            font-weight: 800;
            line-height: 1;
            text-align: center;
        }

        .profile-text {
            display: inline-flex;
            align-items: center;
            line-height: 1;
            white-space: nowrap;
        }

        /* ================= PAGE CONTAINER ================= */
        .page {
            width: 92%;
            max-width: 1500px;
            margin: 30px auto;
        }

        /* ================= ERROR MESSAGE ================= */
        .confirmation-error {
            max-width: 760px;
            margin: 0 auto 24px;
            padding: 14px 16px;
            border: 1px solid #D8CCFF;
            border-radius: 13px;
            background: #F4F0FF;
            color: #5433EB;
            font-size: 13px;
            line-height: 1.6;
            text-align: center;
        }

        /* ================= CONFIRMATION HERO ================= */
        .confirmation-hero {
            text-align: center;
            padding: 26px 0 28px;
            color: #242127;
        }

        /* Green success tick */
.success-icon {
    width: 54px;
    height: 54px;
    margin: 0 auto 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: #E5F6EA;
    color: #218838;
    font-size: 27px;
    font-weight: 800;
}


        .confirmation-badge {
            display: inline-block;
            margin-bottom: 10px;
            color: #6C55C7;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.2px;
            
        }

        /* Green payment-success heading */
.confirmation-hero h1 {
    margin: 0 0 12px;
    color: #218838;
    font-size: 34px;
    font-weight: 800;
}

        .confirmation-hero p {
            margin: 0 auto;
            max-width: 720px;
            color: #6D6478;
            font-size: 15px;
            line-height: 1.7;
        }

        /* ================= ORDER CONFIRMATION CARD ================= */
        .confirmation-card {
            background: #FFFFFF;
            border: 1px solid #DCD2F6;
            border-radius: 24px;
            box-shadow: 0 15px 40px rgba(84, 51, 235, 0.08);
            overflow: hidden;
        }

        .order-header {
            padding: 25px 28px;
            background: #F5F0FF;
            border-bottom: 1px solid #E9E2FF;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .order-header-label {
            margin-bottom: 6px;
            color: #7B7191;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.7px;
        }

        .order-number {
            color: #3921A7;
            font-size: 24px;
            font-weight: 800;
        }

        /* Subtle green confirmation badge */
.status-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 9px 14px;
    border-radius: 999px;
    background: #E5F6EA;
    color: #218838;
    font-size: 12px;
    font-weight: 800;
}
        /* ================= ORDER INFORMATION GRID ================= */
        .confirmation-content {
            padding: 28px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: 20px;
        }

        .info-box {
            padding: 19px;
            background: #FAF8FF;
            border: 1px solid #E5DDF8;
            border-radius: 15px;
        }

        .info-box h2 {
            margin: 0 0 14px;
            color: #3921A7;
            font-size: 17px;
        }

        .info-line {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 15px;
            padding: 9px 0;
            border-bottom: 1px solid #E9E2FF;
            font-size: 13px;
        }

        .info-line:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .info-label {
            color: #756B86;
        }

        .info-value {
            color: #302642;
            font-weight: 700;
            text-align: right;
            word-break: break-word;
        }

        /* Green SUCCESS status */
.payment-success {
    color: #218838 !important;
    font-weight: 800;
}
        .payment-pending {
            color: #6C55C7 !important;
        }

        /* ================= DELIVERY ADDRESS ================= */
        .address-box {
            grid-column: 1 / -1;
        }

        .address-text {
            color: #6D6478;
            font-size: 13px;
            line-height: 1.7;
        }

        .address-line {
            margin: 4px 0;
        }

        .address-line strong {
            color: #3921A7;
        }

        /* ================= ORDER TOTAL ================= */
        .total-box {
            grid-column: 1 / -1;
            padding: 21px 23px;
            border-radius: 16px;
            background: #F0EAFF;
            border: 1px solid #DCD2F6;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .total-label {
            color: #3921A7;
            font-size: 17px;
            font-weight: 800;
        }

        .total-amount {
            color: #5433EB;
            font-size: 30px;
            font-weight: 800;
        }

        /* ================= CONFIRMATION NOTE ================= */
        .confirmation-note {
            margin: 0 28px 28px;
            padding: 14px 16px;
            border-radius: 13px;
            background: #F5F0FF;
            color: #756B86;
            font-size: 12px;
            line-height: 1.6;
        }

        /* ================= ACTION BUTTONS ================= */
        .confirmation-actions {
            padding: 0 28px 28px;
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 13px;
        }

        .action-button {
            min-height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 18px;
            border-radius: 13px;
            font-size: 14px;
            font-weight: 800;
            text-align: center;
            transition: all 0.2s ease;
        }

        .primary-action {
            background: #5433EB;
            color: #FFFFFF;
            box-shadow: 0 8px 20px rgba(84, 51, 235, 0.17);
        }

        .primary-action:hover {
            background: #3921A7;
            transform: translateY(-1px);
        }

        .secondary-action {
            background: #F0EAFF;
            color: #3921A7;
            border: 1px solid #DCD2F6;
        }

        .secondary-action:hover {
            background: #E9E2FF;
        }

                    
            /* =========================================================

   SECTION 28: FOOTER

   Matches the EasyBuy product-details reference

   ========================================================= */



.site-footer {

    width: 100%;

    margin-top: 40px;

    padding: 65px 32px 0;

    background: #f5f1ff;

    color: #25232a;

}



.footer-main {

    display: grid;

    grid-template-columns: 1.2fr 0.7fr 0.9fr 1fr;

    gap: 40px;

    width: min(100%, var(--page-width));

    margin: 0 auto;

    padding-bottom: 55px;

}



.footer-logo {

    display: inline-block;

    color: #25232a;

    font-family: Georgia, "Times New Roman", serif;

    font-size: 27px;

    font-weight: 700;

    letter-spacing: -1.5px;

    line-height: 1;

    white-space: nowrap;

}



.footer-logo span {

    color: #5635ed;

}



.footer-brand p,

.footer-note p {

    color: #77718a;

    font-size: 11px;

    line-height: 1.8;

}



.footer-column {

    display: flex;

    flex-direction: column;

    align-items: flex-start;

    gap: 12px;

}



.footer-column h3 {

    margin: 5px 0 8px;

    color: #25232a;

    font-size: 10px;

    font-weight: 700;

    letter-spacing: 1.5px;

}



.footer-column a,

.footer-note a {

    color: #69647a;

    font-size: 11px;

    transition: color 0.2s ease;

}



.footer-column a:hover,

.footer-note a:hover {

    color: #5635ed;

}



.footer-note > span {

    color: #5635ed;

    font-size: 9px;

    font-weight: 700;

    letter-spacing: 1.5px;

}



.footer-bottom {

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 20px;

    width: min(100%, var(--page-width));

    margin: 0 auto;

    padding: 22px 0;

    border-top: 1px solid #ded6ff;

    color: #77718a;

    font-size: 10px;

}



.footer-bottom a {

    color: #25232a;

    transition: color 0.2s ease;

}



.footer-bottom a:hover {

    color: #5635ed;

}



/* =========================================================

   SECTION 29: TABLET RESPONSIVE FOOTER AND BENEFITS

   ========================================================= */



@media (max-width: 1100px) {

    .footer-main {

        grid-template-columns: repeat(2, minmax(0, 1fr));

    }

}



@media (max-width: 850px) {

    .benefits-strip {

        padding: 18px 24px;

        gap: 14px;

    }



    .benefit-item {

        gap: 8px;

    }



    .benefit-item strong {

        font-size: 9px;

        letter-spacing: 0.6px;

    }



    .benefit-item div span {

        font-size: 10px;

    }

}



/* =========================================================

   SECTION 30: MOBILE RESPONSIVE FOOTER AND BENEFITS

   ========================================================= */



@media (max-width: 600px) {

    .benefits-strip {

        padding: 20px 22px;

        flex-direction: column;

        align-items: stretch;

        gap: 16px;

    }



    .benefit-item {

        justify-content: flex-start;

    }



    .benefit-divider {

        width: 100%;

        height: 1px;

        flex-basis: 1px;

    }



    .site-footer {

        margin-top: 30px;

        padding: 40px 22px 0;

    }



    .footer-main {

        grid-template-columns: minmax(0, 1fr);

        gap: 28px;

        padding-bottom: 35px;

    }



    .footer-bottom {

        flex-wrap: wrap;

        gap: 12px;

        padding: 18px 0;

        line-height: 1.6;

    }
        }
        
        
/* ==========================================
   ORDER CONFIRMATION - COLOR CORRECTIONS ONLY
   Keep the existing layout and dimensions
========================================== */

/* Main page background */
body {
    background: #FCFBF8;
    color: #29252D;
}

/* Order number section */
.order-number-section,
.order-header {
    background: #F5F0FF;
    border-color: #E5DCFF;
}

/* Order number */
.order-number,
.order-number-section h2 {
    color: #3921A7;
}

/* Customer and payment information cards */
.customer-information,
.payment-information,
.delivery-address,
.info-card {
    background: #FFFFFF;
    border-color: #E9E3ED;
}

/* Card headings: dark charcoal, not purple */
.customer-information h2,
.payment-information h2,
.delivery-address h2,
.info-card h2 {
    color: #30283A;
}

/* Labels and supporting information */
.customer-information label,
.payment-information label,
.delivery-address p,
.info-card p,
.info-label {
    color: #786F7E;
}

/* Customer and transaction values */
.customer-information strong,
.payment-information strong,
.info-card strong {
    color: #29252D;
}

/* Payment status: green */
.payment-status,
.payment-status.success,
.success-text {
    color: #218347;
}

/* Confirmed badge: green */
.confirmed,
.status-confirmed,
.order-status {
    background: #E5F6EA;
    color: #218347;
}

/* Total amount panel: soft neutral lavender */
.total-order-amount,
.total-amount,
.order-total {
    background: #F2EDF9;
    border-color: #E4D9F2;
}

/* Total amount label: dark charcoal */
.total-order-amount h2,
.total-amount h2,
.order-total h2,
.total-label {
    color: #30283A;
}

/* Total price: dark neutral instead of bright purple */
.total-order-amount strong,
.total-amount strong,
.order-total strong,
.total-price {
    color: #51445D;
}

/* Demo payment message */
.demo-payment-note,
.payment-note {
    background: #F7F4F9;
    color: #716780;
}

/* Continue Shopping: soft lavender button */
.continue-shopping,
.btn-continue-shopping {
    background: #F0EBF8;
    border-color: #E1D6EE;
    color: #51445D;
}

/* View My Orders: retain purple */
.view-my-orders,
.btn-view-orders {
    background: #5433EB;
    border-color: #5433EB;
    color: #FFFFFF;
}

/* Hover effects */
.continue-shopping:hover,
.btn-continue-shopping:hover {
    background: #E7DFF1;
}

.view-my-orders:hover,
.btn-view-orders:hover {
    background: #3921A7;
}

/* Keep the easyBuy brand as it is */
.brand,
.logo,
.footer-brand {
    color: #242127;
}

.brand-buy,
.logo-buy {
    color: #5433EB;
}
        
    </style>
</head>

<body>

    <!-- ================= NAVBAR ================= -->
    
<!-- NAVBAR -->
<nav class="navbar">
    <a href="<%= contextPath %>/home" class="brand">
        <span class="brand-easy">easy</span><span class="brand-buy">Buy</span>
    </a>

    <div class="nav-links">
        <a href="<%= contextPath %>/home">Home</a>

        <a href="<%= contextPath %>/profile" class="profile-nav-link">
            <span class="profile-dp"><%= profileLetter %></span>
            <span class="profile-text">Profile</span>
        </a>
    </div>
</nav>


    <!-- ================= MAIN PAGE ================= -->
    <main class="page">

        <% if (!confirmationError.isEmpty()) { %>
            <div class="confirmation-error">
                <%= confirmationError %>
            </div>
        <% } %>

        <!-- ================= CONFIRMATION HERO ================= -->
        <section class="confirmation-hero">
            <div class="success-icon">✓</div>

            <div class="confirmation-badge">
                easyBuy Order
            </div>

            <h1><%= confirmationTitle %></h1>

            <p><%= confirmationMessage %></p>
        </section>

        <!-- ================= CONFIRMATION CARD ================= -->
        <section class="confirmation-card">

            <!-- ORDER HEADER -->
            <div class="order-header">
                <div>
                    <div class="order-header-label">Order Number</div>
                    <div class="order-number">
                        #<%= !orderId.isEmpty() ? orderId : "Unavailable" %>
                    </div>
                </div>

                <div class="status-badge">
                    <%= orderStatus %>
                </div>
            </div>

            <!-- ORDER INFORMATION -->
            <div class="confirmation-content">

                <!-- CUSTOMER INFORMATION -->
                <div class="info-box">
                    <h2>Customer Information</h2>

                    <div class="info-line">
                        <span class="info-label">Receiver</span>
                        <span class="info-value"><%= receiverName %></span>
                    </div>

                    <div class="info-line">
                        <span class="info-label">Mobile</span>
                        <span class="info-value"><%= primaryMobile %></span>
                    </div>

                    <% if (!alternateMobile.isEmpty()) { %>
                        <div class="info-line">
                            <span class="info-label">Alternate Mobile</span>
                            <span class="info-value"><%= alternateMobile %></span>
                        </div>
                    <% } %>

                    <div class="info-line">
                        <span class="info-label">Email</span>
                        <span class="info-value"><%= checkoutEmail %></span>
                    </div>
                </div>

                <!-- PAYMENT INFORMATION -->
                <div class="info-box">
                    <h2>Payment Information</h2>

                    <div class="info-line">
                        <span class="info-label">Method</span>
                        <span class="info-value">
                            <%= !paymentMethod.isEmpty()
                                ? paymentMethod : "Not available" %>
                        </span>
                    </div>

                    <div class="info-line">
                        <span class="info-label">Payment Status</span>
                        <span class="info-value <%= paymentStatusClass %>">
                            <%= !paymentStatus.isEmpty()
                                ? paymentStatus : "PENDING" %>
                        </span>
                    </div>

                    <% if (!paymentTransactionId.isEmpty()) { %>
                        <div class="info-line">
                            <span class="info-label">Transaction Reference</span>
                            <span class="info-value">
                                <%= paymentTransactionId %>
                            </span>
                        </div>
                    <% } %>

                    <% if (!formattedPaymentDate.isEmpty()) { %>
                        <div class="info-line">
                            <span class="info-label">Payment Date</span>
                            <span class="info-value">
                                <%= formattedPaymentDate %>
                            </span>
                        </div>
                    <% } %>
                </div>

                <!-- DELIVERY ADDRESS -->
                <div class="info-box address-box">
                    <h2>Delivery Address</h2>

                    <% if (!checkoutAddress.isEmpty()) { %>
                        <div class="address-text">
                            <%= checkoutAddress %>
                        </div>
                    <% } else if (hasAddressValues(
                            houseFlatNumber,
                            buildingName,
                            street,
                            area,
                            landmark,
                            city)) { %>

                        <div class="address-text">

                            <% if (!houseFlatNumber.isEmpty()) { %>
                                <div class="address-line">
                                    <strong>House/Flat:</strong>
                                    <%= houseFlatNumber %>
                                </div>
                            <% } %>

                            <% if (!buildingName.isEmpty()) { %>
                                <div class="address-line">
                                    <strong>Building:</strong>
                                    <%= buildingName %>
                                </div>
                            <% } %>

                            <% if (!street.isEmpty()) { %>
                                <div class="address-line">
                                    <strong>Street:</strong>
                                    <%= street %>
                                </div>
                            <% } %>

                            <% if (!area.isEmpty()) { %>
                                <div class="address-line">
                                    <strong>Area:</strong>
                                    <%= area %>
                                </div>
                            <% } %>

                            <% if (!landmark.isEmpty()) { %>
                                <div class="address-line">
                                    <strong>Landmark:</strong>
                                    <%= landmark %>
                                </div>
                            <% } %>

                            <% if (!city.isEmpty()) { %>
                                <div class="address-line">
                                    <strong>City:</strong>
                                    <%= city %>
                                </div>
                            <% } %>

                        </div>
                    <% } else { %>
                        <div class="address-text">
                            Delivery address is not available.
                        </div>
                    <% } %>
                </div>

                <!-- ORDER TOTAL -->
                <div class="total-box">
                    <span class="total-label">Total Order Amount</span>

                    <span class="total-amount">
                        Rs.
                        <%= orderTotal.setScale(2, RoundingMode.HALF_UP) %>
                    </span>
                </div>

            </div>

            <!-- CONFIRMATION NOTE -->
            <div class="confirmation-note">
                <% if (isCashOnDelivery) { %>
                    📦 Your payment is pending because this order uses
                    Cash on Delivery. Please pay the displayed amount
                    when your order is delivered.
                <% } else { %>
                    ✅ This is a demo payment flow for the EasyBuy project.
                    The transaction reference shown above is an
                    EasyBuy-generated reference.
                <% } %>
            </div>

            <!-- ACTION BUTTONS -->
            <div class="confirmation-actions">
                <a href="<%= contextPath %>/products"
                   class="action-button secondary-action">
                    Continue Shopping
                </a>

                <a href="<%= contextPath %>/my-orders"
                   class="action-button primary-action">
                    View My Orders →
                </a>
            </div>

        </section>
    </main>

    <!-- ================= EASYBUY FOOTER ================= -->
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
