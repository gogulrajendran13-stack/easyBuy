package easyBuy.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import easyBuy.dao.UserDAO;
import easyBuy.dao.UserDAOImpl;
import easyBuy.model.User;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;


    // =========================================================
    // INITIALIZE
    // =========================================================

    @Override
    public void init() throws ServletException {

        userDAO = new UserDAOImpl();
    }


    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String registered =
                request.getParameter("registered");

        if ("true".equalsIgnoreCase(registered)) {

            request.setAttribute(
                    "successMessage",
                    "Account created successfully. Please log in."
            );
        }

        request.getRequestDispatcher(
                "/login.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email =
                clean(request.getParameter("email"));

        String phone =
                clean(request.getParameter("phone"));

        String password =
                request.getParameter("password");


        // -----------------------------------------------------
        // VALIDATE INPUT
        // -----------------------------------------------------

        if (email.isEmpty()) {

            showLoginError(
                    request,
                    response,
                    "Please enter your email address."
            );

            return;
        }


        if (phone.isEmpty()) {

            showLoginError(
                    request,
                    response,
                    "Please enter your mobile number."
            );

            return;
        }


        if (password == null || password.isEmpty()) {

            showLoginError(
                    request,
                    response,
                    "Please enter your password."
            );

            return;
        }


        // -----------------------------------------------------
        // FIND USER
        // -----------------------------------------------------

        User user =
                userDAO.getUserByEmail(email);
        

System.out.println("LOGIN CHECK - User found: " + (user != null));

if (user != null) {
    System.out.println("LOGIN CHECK - Phone matches: "
            + clean(user.getPhone()).equals(phone));

    String storedPassword = user.getPasswordHash();

    System.out.println("LOGIN CHECK - Stored hash length: "
            + (storedPassword == null ? 0 : storedPassword.length()));
}


        if (user == null) {

            showLoginError(
                    request,
                    response,
                    "Invalid email, mobile number, or password."
            );

            return;
        }


        // -----------------------------------------------------
        // VERIFY PHONE
        // -----------------------------------------------------

        String registeredPhone =
                user.getPhone();

        if (registeredPhone == null) {
            registeredPhone = "";
        }

        registeredPhone =
                registeredPhone.trim();

        if (!registeredPhone.equals(phone)) {

            showLoginError(
                    request,
                    response,
                    "Invalid email, mobile number, or password."
            );

            return;
        }


        // -----------------------------------------------------
        // HASH PASSWORD
        // -----------------------------------------------------

        String hashedPassword;

        try {

            hashedPassword =
                    hashPassword(password);

        } catch (Exception e) {

            e.printStackTrace();

            showLoginError(
                    request,
                    response,
                    "Unable to process login. Please try again."
            );

            return;
        }


        // -----------------------------------------------------
        // VERIFY PASSWORD
        // -----------------------------------------------------

        String storedPassword =
                user.getPasswordHash();

        if (storedPassword == null
                || !storedPassword.equals(hashedPassword)) {

            showLoginError(
                    request,
                    response,
                    "Invalid email, mobile number, or password."
            );

            return;
        }


        // -----------------------------------------------------
        // LOGIN SUCCESS
        // -----------------------------------------------------

        HttpSession session =
                request.getSession(true);


        session.setAttribute(
                "userId",
                user.getUserId()
        );

        session.setAttribute(
                "user",
                user
        );

        session.setAttribute(
                "userName",
                user.getName()
        );

        session.setAttribute(
                "userEmail",
                user.getEmail()
        );

        session.setAttribute(
                "userPhone",
                user.getPhone()
        );

        session.setAttribute(
                "loginSuccess",
                true
        );

        session.setAttribute(
                "loginSuccessMessage",
                "Login successful. Welcome back!"
        );


        // -----------------------------------------------------
        // REDIRECT HOME
        // -----------------------------------------------------

        response.sendRedirect(
                request.getContextPath() + "/home"
        );
    }


    // =========================================================
    // SHOW LOGIN ERROR
    // =========================================================

    private void showLoginError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute(
                "errorMessage",
                message
        );

        request.getRequestDispatcher(
                "/login.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // CLEAN INPUT
    // =========================================================

    private String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }


    // =========================================================
    // SHA-256 PASSWORD HASH
    // =========================================================

    private String hashPassword(
            String password)
            throws Exception {

        MessageDigest digest =
                MessageDigest.getInstance("SHA-256");

        byte[] hash =
                digest.digest(
                        password.getBytes(
                                StandardCharsets.UTF_8
                        )
                );

        StringBuilder hexString =
                new StringBuilder();

        for (byte b : hash) {

            String hex =
                    Integer.toHexString(
                            0xff & b
                    );

            if (hex.length() == 1) {
                hexString.append('0');
            }

            hexString.append(hex);
        }

        return hexString.toString();
    }
}