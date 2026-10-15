
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String contextPath = request.getContextPath();
    String inviteUrl = (String) request.getAttribute("inviteUrl");

    if (inviteUrl == null) {
        inviteUrl = request.getScheme() + "://"
                + request.getServerName()
                + contextPath + "/register";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Invite Friends | easyBuy</title>

    <style>
        /* Page */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        
body {
    font-family: Arial, Helvetica, sans-serif;
    background-image:
        linear-gradient(
            rgba(255, 255, 255, 0.35),
            rgba(255, 255, 255, 0.35)
        ),
        url("<%= contextPath %>/images/home-page-image/invite-friends.jpg");
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
    color: #25222b;
    min-height: 100vh;
}


        /* Header */
        .invite-header {
            height: 88px;
            padding: 0 6%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #eee7ff;
        }

        .brand {
            font-family: Georgia, serif;
            font-size: 34px;
            font-weight: bold;
            letter-spacing: -1.5px;
            color: #25222b;
            text-decoration: none;
        }

        .brand span {
            color: #5635ee;
        }

        .home-link {
            color: #292431;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
        }

        .home-link:hover {
            color: #5635ee;
        }

        /* Main content */
        .invite-main {
            width: 100%;
            max-width: 760px;
            margin: 75px auto;
            padding: 0 24px;
        }

        .invite-card {
            border: 1px solid #e7ddff;
            border-radius: 20px;
            padding: 48px 42px;
            background: #ffffff;
            box-shadow: 0 15px 45px rgba(65, 43, 120, 0.06);
        }

        .eyebrow {
            color: #6540e8;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 18px;
        }

        h1 {
            font-family: Georgia, "Times New Roman", serif;
            font-size: clamp(32px, 5vw, 44px);
            line-height: 1.15;
            font-weight: 500;
            margin-bottom: 18px;
        }

        .description {
            color: #77717f;
            font-size: 15px;
            line-height: 1.8;
            margin-bottom: 34px;
        }

        /* Invitation link */
        .link-label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .link-box {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px;
            border: 1px solid #ded2ff;
            border-radius: 10px;
            background: #fbf9ff;
        }

        .invite-url {
            flex: 1;
            min-width: 0;
            padding: 10px;
            overflow-wrap: anywhere;
            color: #5b42b5;
            font-size: 13px;
            line-height: 1.6;
        }

        .copy-button {
            border: none;
            border-radius: 8px;
            padding: 13px 18px;
            background: #5635ee;
            color: #ffffff;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
        }

        .copy-button:hover {
            background: #4325cf;
        }

        /* Share options */
        .share-heading {
            font-size: 13px;
            font-weight: 700;
            margin: 30px 0 14px;
        }

        .share-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .share-button {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            min-height: 54px;
            border: 1px solid #ded2ff;
            border-radius: 10px;
            background: #ffffff;
            color: #292431;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: 0.2s ease;
        }

        .share-button:hover {
            border-color: #6540e8;
            background: #f8f5ff;
            transform: translateY(-2px);
        }

        .whatsapp-icon {
            color: #168b53;
            font-size: 19px;
        }

        .email-icon {
            color: #6540e8;
            font-size: 19px;
        }

        .copy-message {
            min-height: 20px;
            margin-top: 12px;
            color: #168b53;
            font-size: 13px;
        }

        /* Mobile */
        @media (max-width: 560px) {
            .invite-header {
                height: 76px;
                padding: 0 20px;
            }

            .brand {
                font-size: 29px;
            }

            .invite-main {
                margin: 35px auto;
                padding: 0 16px;
            }

            .invite-card {
                padding: 30px 22px;
                border-radius: 16px;
            }

            .link-box {
                align-items: stretch;
                flex-direction: column;
            }

            .copy-button {
                width: 100%;
            }

            .share-options {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

    <!-- Header -->
    <header class="invite-header">
        <a href="<%= contextPath %>/home" class="brand">
            easy<span>Buy</span>
        </a>

        <a href="<%= contextPath %>/home" class="home-link">
            Home
        </a>
    </header>

    <!-- Invite Friends -->
    <main class="invite-main">
        <section class="invite-card">

            <p class="eyebrow">Share the good finds</p>

            <h1>Invite friends to easyBuy.</h1>

            <p class="description">
                Found something you love?
                Share easyBuy with your friends and let them
                explore their next favourite find.
            </p>

            <!-- Invitation link -->
            <label class="link-label" for="inviteUrl">
                Your invitation link
            </label>

            <div class="link-box">
                <div class="invite-url" id="inviteUrl"><%= inviteUrl %></div>

                <button type="button"
                        class="copy-button"
                        onclick="copyInviteLink()">
                    Copy link
                </button>
            </div>

            <p class="copy-message" id="copyMessage"
               role="status" aria-live="polite"></p>

            <!-- Sharing options -->
            <p class="share-heading">Share your invitation</p>

            <div class="share-options">

                <a class="share-button"
                   id="whatsappShare"
                   href="#"
                   target="_blank"
                   rel="noopener noreferrer">
                    <span class="whatsapp-icon">●</span>
                    Share through WhatsApp
                </a>

                <a class="share-button"
                   id="emailShare"
                   href="#">
                    <span class="email-icon">✉</span>
                    Share through Email
                </a>

            </div>

        </section>
    </main>

    <script>
        // Get the invitation URL from the page.
        const inviteUrl =
            document.getElementById("inviteUrl").textContent.trim();

        const invitationMessage =
            "Join me on easyBuy and discover your next favourite find! "
            + inviteUrl;

        // Prepare WhatsApp sharing.
        document.getElementById("whatsappShare").href =
            "https://wa.me/?text="
            + encodeURIComponent(invitationMessage);

        // Prepare email sharing.
        document.getElementById("emailShare").href =
            "mailto:?subject="
            + encodeURIComponent("Join me on easyBuy")
            + "&body="
            + encodeURIComponent(invitationMessage);

        // Copy the invitation URL.
        async function copyInviteLink() {
            const message =
                document.getElementById("copyMessage");

            try {
                await navigator.clipboard.writeText(inviteUrl);
                message.textContent = "Invitation link copied!";
            } catch (error) {
                // Fallback for browsers that block clipboard access.
                const temporaryInput =
                    document.createElement("textarea");

                temporaryInput.value = inviteUrl;
                temporaryInput.style.position = "fixed";
                temporaryInput.style.opacity = "0";

                document.body.appendChild(temporaryInput);
                temporaryInput.select();

                const copied =
                    document.execCommand("copy");

                temporaryInput.remove();

                message.textContent = copied
                    ? "Invitation link copied!"
                    : "Please copy the invitation link manually.";
            }
        }
    </script>

</body>
</html>
