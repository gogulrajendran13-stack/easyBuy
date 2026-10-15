
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="easyBuy.model.User" %>
<%@ page import="easyBuy.model.Order" %>

<%
    String contextPath = request.getContextPath();

    Object userObject = session.getAttribute("user");
    User loggedInUser = userObject instanceof User
            ? (User) userObject : null;

    Object orderObject = request.getAttribute("order");
    Order currentOrder = orderObject instanceof Order
            ? (Order) orderObject : null;

    String orderId = "";
    Object orderIdObject = request.getAttribute("orderId");

    if (orderIdObject != null) {
        orderId = String.valueOf(orderIdObject);
    } else if (session.getAttribute("checkoutOrderId") != null) {
        orderId = String.valueOf(session.getAttribute("checkoutOrderId"));
    } else if (session.getAttribute("orderId") != null) {
        orderId = String.valueOf(session.getAttribute("orderId"));
    }

    Object totalObject = request.getAttribute("orderTotal");

    if (totalObject == null) {
        totalObject = session.getAttribute("checkoutOrderTotal");
    }

    if (totalObject == null) {
        totalObject = session.getAttribute("orderTotal");
    }

    BigDecimal orderTotal = BigDecimal.ZERO;

    try {
        if (totalObject != null) {
            orderTotal = new BigDecimal(String.valueOf(totalObject));
        } else if (currentOrder != null) {
            orderTotal = BigDecimal.valueOf(currentOrder.getTotalAmount());
        }
    } catch (Exception e) {
        orderTotal = BigDecimal.ZERO;
    }

    NumberFormat currencyFormat =
            NumberFormat.getCurrencyInstance(new Locale("en", "IN"));

    String formattedTotal = currencyFormat.format(orderTotal);

    String receiverName = "";
    String receiverEmail = "";
    String primaryMobile = "";
    String deliveryAddress = "";

    Object nameObject = request.getAttribute("receiverName");
    Object emailObject = request.getAttribute("checkoutEmail");
    Object mobileObject = request.getAttribute("primaryMobile");

    if (nameObject == null) {
        nameObject = session.getAttribute("receiverName");
    }

    if (emailObject == null) {
        emailObject = session.getAttribute("checkoutEmail");
    }

    if (mobileObject == null) {
        mobileObject = session.getAttribute("primaryMobile");
    }

    if (nameObject != null) {
        receiverName = String.valueOf(nameObject);
    } else if (loggedInUser != null && loggedInUser.getName() != null) {
        receiverName = loggedInUser.getName();
    }

    if (emailObject != null) {
        receiverEmail = String.valueOf(emailObject);
    } else if (loggedInUser != null && loggedInUser.getEmail() != null) {
        receiverEmail = loggedInUser.getEmail();
    }

    if (mobileObject != null) {
        primaryMobile = String.valueOf(mobileObject);
    } else if (loggedInUser != null && loggedInUser.getPhone() != null) {
        primaryMobile = loggedInUser.getPhone();
    }

    String[] addressKeys = {
        "houseFlatNumber", "buildingName", "street",
        "area", "landmark", "city"
    };

    StringBuilder addressBuilder = new StringBuilder();

    for (String key : addressKeys) {
        Object value = request.getAttribute(key);

        if (value == null) {
            value = session.getAttribute(key);
        }

        if (value != null && !String.valueOf(value).trim().isEmpty()) {
            if (addressBuilder.length() > 0) {
                addressBuilder.append(", ");
            }

            addressBuilder.append(String.valueOf(value).trim());
        }
    }

    Object fullAddressObject = request.getAttribute("checkoutAddress");

    if (fullAddressObject == null) {
        fullAddressObject = session.getAttribute("checkoutAddress");
    }

    if (fullAddressObject != null
            && !String.valueOf(fullAddressObject).trim().isEmpty()) {
        deliveryAddress = String.valueOf(fullAddressObject).trim();
    } else {
        deliveryAddress = addressBuilder.toString();
    }

    String selectedMethod = "";
    Object selectedMethodObject = request.getAttribute("paymentMethod");

    if (selectedMethodObject == null) {
        selectedMethodObject = session.getAttribute("paymentMethod");
    }

    if (selectedMethodObject != null) {
        selectedMethod = String.valueOf(selectedMethodObject);
    }

    String paymentStatus = "";
    Object statusObject = request.getAttribute("paymentStatus");

    if (statusObject != null) {
        paymentStatus = String.valueOf(statusObject);
    }

    String errorMessage = "";
    Object errorObject = request.getAttribute("errorMessage");

    if (errorObject != null) {
        errorMessage = String.valueOf(errorObject);
    }

    String profileLetter = "U";

    if (receiverName != null && !receiverName.trim().isEmpty()) {
        profileLetter = receiverName.trim().substring(0, 1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Payment | easyBuy</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/payment.css">
</head>

<body>

    <nav class="topbar">
        <a href="<%= contextPath %>/home" class="brand">
            easy<span>Buy</span>
        </a>

        <div class="nav-right">
            <a href="<%= contextPath %>/home" class="nav-link">Home</a>

            <a href="<%= contextPath %>/profile" class="profile-link">
                <span class="profile-avatar"><%= profileLetter %></span>
                <span>Profile</span>
            </a>
        </div>
    </nav>

    <main class="checkout-page">

        <section class="hero">
            <div class="hero-content">
                <div class="eyebrow">EasyBuy checkout · Step 3 of 3</div>

                <h1>Complete your order</h1>

                <p>
                    Choose your preferred payment method and review your order
                    details before placing your order.
                </p>

                <div class="hero-points">
                    <div class="hero-point">
                        <span>✓</span> Simple checkout
                    </div>

                    <div class="hero-point">
                        <span>◇</span> Multiple payment options
                    </div>

                    <div class="hero-point">
                        <span>♡</span> EasyBuy experience
                    </div>
                </div>
            </div>
        </section>

        <div class="steps">
            <div class="step">
                <span class="step-number">1</span>
                <span>Cart</span>
            </div>

            <span class="step-line"></span>

            <div class="step">
                <span class="step-number">2</span>
                <span>Delivery</span>
            </div>

            <span class="step-line"></span>

            <div class="step active">
                <span class="step-number">3</span>
                <span>Payment</span>
            </div>
        </div>

        <% if (!errorMessage.trim().isEmpty()) { %>
            <div class="error-message">
                <%= errorMessage %>
            </div>
        <% } %>

        <div class="checkout-grid">

            <section class="panel">
                <div class="panel-heading">
                    <h2>Payment method</h2>
                    <p>Select your preferred way to pay for this order.</p>
                </div>

                <div class="panel-body">

                    <div class="section-label">Delivery details</div>

                    <div class="delivery-card">
                        <div class="delivery-top">
                            <div class="delivery-name">
                                <%= receiverName.isEmpty()
                                        ? "Customer" : receiverName %>
                            </div>

                            <span class="address-badge">Delivery address</span>
                        </div>

                        <% if (!receiverEmail.isEmpty()) { %>
                            <div class="delivery-detail">
                                <%= receiverEmail %>
                            </div>
                        <% } %>

                        <% if (!primaryMobile.isEmpty()) { %>
                            <div class="delivery-detail">
                                Mobile: <%= primaryMobile %>
                            </div>
                        <% } %>

                        <div class="delivery-detail">
                            <%= deliveryAddress.isEmpty()
                                    ? "Your saved delivery address"
                                    : deliveryAddress %>
                        </div>
                    </div>

                    <div class="section-divider"></div>

                    <div class="section-label">Choose a payment option</div>

                    <form id="paymentForm"
                          action="<%= contextPath %>/payment"
                          method="post">

                        <input type="hidden"
                               name="orderId"
                               value="<%= orderId %>">

                        <div class="payment-options">

                            <label class="payment-option"
                                   data-method="UPI">

                                <input type="radio"
                                       name="paymentMethod"
                                       value="UPI"
                                       <%= "UPI".equalsIgnoreCase(selectedMethod)
                                                ? "checked" : "" %>
                                       required>

                                <span class="payment-icon">↗</span>

                                <span class="payment-copy">
                                    <strong>UPI</strong>
                                    <small>Pay using your UPI app or UPI ID.</small>
                                </span>

                                <span class="radio-visual"></span>
                            </label>

                            <label class="payment-option"
                                   data-method="Card">

                                <input type="radio"
                                       name="paymentMethod"
                                       value="Card"
                                       <%= "Card".equalsIgnoreCase(selectedMethod)
                                                ? "checked" : "" %>
                                       required>

                                <span class="payment-icon">▤</span>

                                <span class="payment-copy">
                                    <strong>Credit / Debit Card</strong>
                                    <small>Use your preferred bank card.</small>
                                </span>

                                <span class="radio-visual"></span>
                            </label>

                            <label class="payment-option"
                                   data-method="Cash on Delivery">

                                <input type="radio"
                                       name="paymentMethod"
                                       value="Cash on Delivery"
                                       <%= "Cash on Delivery".equalsIgnoreCase(selectedMethod)
                                                ? "checked" : "" %>
                                       required>

                                <span class="payment-icon">₹</span>

                                <span class="payment-copy">
                                    <strong>Cash on Delivery</strong>
                                    <small>Pay when your order arrives.</small>
                                </span>

                                <span class="radio-visual"></span>
                            </label>

                        </div>

                        <div id="upiFields" class="payment-fields">
                            <h3>UPI payment details</h3>
                            <p>Enter your UPI ID if required for your payment flow.</p>

                            <label class="field-label" for="upiId">
                                UPI ID
                            </label>

                            <input class="text-field"
                                   type="text"
                                   id="upiId"
                                   name="upiId"
                                   placeholder="example@bank">
                        </div>

                        <div id="cardFields" class="payment-fields">
                            <h3>Card details</h3>
                            <p>
                                Card payments must be processed through a secure
                                payment provider.
                            </p>

                            <div class="field-group">
                                <label class="field-label" for="cardName">
                                    Name on card
                                </label>

                                <input class="text-field"
                                       type="text"
                                       id="cardName"
                                       autocomplete="cc-name"
                                       placeholder="Cardholder name">
                            </div>

                            <div class="field-group">
                                <label class="field-label" for="cardNumber">
                                    Card number
                                </label>

                                <input class="text-field"
                                       type="text"
                                       id="cardNumber"
                                       inputmode="numeric"
                                       autocomplete="cc-number"
                                       maxlength="19"
                                       placeholder="1234 5678 9012 3456">
                            </div>

                            <div class="field-row">
                                <div class="field-group">
                                    <label class="field-label" for="expiry">
                                        Expiry date
                                    </label>

                                    <input class="text-field"
                                           type="text"
                                           id="expiry"
                                           autocomplete="cc-exp"
                                           maxlength="5"
                                           placeholder="MM/YY">
                                </div>

                                <div class="field-group">
                                    <label class="field-label" for="cvv">
                                        CVV
                                    </label>

                                    <input class="text-field"
                                           type="password"
                                           id="cvv"
                                           inputmode="numeric"
                                           autocomplete="cc-csc"
                                           maxlength="4"
                                           placeholder="CVV">
                                </div>
                            </div>
                        </div>

                        <div class="secure-note">
                            <span class="secure-icon">✦</span>

                            <span>
                                Choose your preferred payment method carefully.
                                Payment confirmation depends on the payment
                                processing configured for your application.
                            </span>
                        </div>

                        <button type="submit"
                                class="place-order-button"
                                id="placeOrderButton">
                            Place order · <%= formattedTotal %>
                        </button>

                        <a href="<%= contextPath %>/checkout"
                           class="back-link">
                            ← Back to delivery details
                        </a>

                    </form>
                </div>
            </section>

            <aside class="panel summary-panel">
                <div class="panel-heading">
                    <h2>Order summary</h2>
                    <p>Review your order before confirming.</p>
                </div>

                <div class="summary-body">

                    <div class="summary-row">
                        <span>Order number</span>
                        <strong>
                            #<%= orderId.isEmpty() ? "—" : orderId %>
                        </strong>
                    </div>

                    <div class="summary-row">
                        <span>Order total</span>
                        <strong><%= formattedTotal %></strong>
                    </div>

                    <div class="summary-row">
                        <span>Delivery</span>
                        <strong>As shown at checkout</strong>
                    </div>

                    <div class="summary-divider"></div>

                    <div class="total-row">
                        <span>Total to pay</span>
                        <strong><%= formattedTotal %></strong>
                    </div>

                    <div class="summary-note">
                        <strong>EasyBuy order summary</strong>
                        Your selected payment method will be submitted
                        with this order.
                    </div>

                    <% if (!paymentStatus.trim().isEmpty()) { %>
                        <div class="summary-row"
                             style="margin-top:18px; margin-bottom:0;">
                            <span>Payment status</span>
                            <strong><%= paymentStatus %></strong>
                        </div>
                    <% } %>

                </div>
            </aside>

        </div>
    </main>

    <footer class="footer">
        <div class="footer-grid">

            <div>
                <div class="footer-brand">easy<span>Buy</span></div>

                <p class="footer-description">
                    Discover your style and enjoy a simpler way to shop
                    for the things you love.
                </p>
            </div>

            <div class="footer-column">
                <h3>Explore</h3>
                <a href="<%= contextPath %>/home">Home</a>
                <a href="<%= contextPath %>/products">Shop products</a>
                <a href="<%= contextPath %>/wishlist">Favorites</a>
            </div>

            <div class="footer-column">
                <h3>Your account</h3>
                <a href="<%= contextPath %>/profile">Profile</a>
                <a href="<%= contextPath %>/orders">My orders</a>
                <a href="<%= contextPath %>/cart">Shopping cart</a>
            </div>

            <div class="footer-column">
                <h3>Help</h3>
                <a href="<%= contextPath %>/orders">Track order</a>
                <a href="<%= contextPath %>/profile">Account details</a>
                <a href="<%= contextPath %>/home">Continue shopping</a>
            </div>

        </div>

        <div class="footer-bottom">
            <span>
                © <%= java.time.Year.now().getValue() %> easyBuy.
                All rights reserved.
            </span>

            <span>Made for a better shopping experience.</span>
        </div>
    </footer>

    <script>
        const paymentForm = document.getElementById("paymentForm");
        const paymentOptions = document.querySelectorAll(".payment-option");
        const upiFields = document.getElementById("upiFields");
        const cardFields = document.getElementById("cardFields");
        const placeOrderButton = document.getElementById("placeOrderButton");

        const upiIdInput = document.getElementById("upiId");
        const cardNameInput = document.getElementById("cardName");
        const cardNumberInput = document.getElementById("cardNumber");
        const expiryInput = document.getElementById("expiry");
        const cvvInput = document.getElementById("cvv");

        function updatePaymentSelection() {
            const selected = document.querySelector(
                'input[name="paymentMethod"]:checked'
            );

            paymentOptions.forEach(function(option) {
                const radio = option.querySelector('input[type="radio"]');

                option.classList.toggle("selected", radio.checked);
            });

            const method = selected ? selected.value : "";

            upiFields.classList.toggle("visible", method === "UPI");
            cardFields.classList.toggle("visible", method === "Card");

            if (method !== "UPI") {
                upiIdInput.value = "";
            }

            if (method !== "Card") {
                cardNameInput.value = "";
                cardNumberInput.value = "";
                expiryInput.value = "";
                cvvInput.value = "";
            }
        }

        document.querySelectorAll('input[name="paymentMethod"]')
            .forEach(function(radio) {
                radio.addEventListener("change", updatePaymentSelection);
            });

        cardNumberInput.addEventListener("input", function() {
            let value = this.value.replace(/\D/g, "").substring(0, 16);
            this.value = value.replace(/(\d{4})(?=\d)/g, "$1 ");
        });

        expiryInput.addEventListener("input", function() {
            let value = this.value.replace(/\D/g, "").substring(0, 4);

            if (value.length >= 3) {
                value = value.substring(0, 2) + "/" + value.substring(2);
            }

            this.value = value;
        });

        cvvInput.addEventListener("input", function() {
            this.value = this.value.replace(/\D/g, "").substring(0, 4);
        });

        paymentForm.addEventListener("submit", function(event) {
            const selected = document.querySelector(
                'input[name="paymentMethod"]:checked'
            );

            if (!selected) {
                event.preventDefault();
                alert("Please select a payment method.");
                return;
            }

            if (selected.value === "UPI") {
                const upi = upiIdInput.value.trim();

                if (upi && !/^[\w.-]+@[\w.-]+$/.test(upi)) {
                    event.preventDefault();
                    alert("Please enter a valid UPI ID.");
                    upiIdInput.focus();
                    return;
                }
            }

            /*
             * Card information is not submitted to the servlet.
             * Connect a secure payment gateway before accepting cards.
             */
            if (selected.value === "Card") {
                event.preventDefault();

                alert(
                    "Card payments require a secure payment gateway. " +
                    "Please choose UPI or Cash on Delivery until it is connected."
                );

                return;
            }

            placeOrderButton.disabled = true;
            placeOrderButton.textContent = "Processing order...";
        });

        updatePaymentSelection();
    </script>

</body>
</html>
