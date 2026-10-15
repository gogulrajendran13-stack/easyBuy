package easyBuy.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import easyBuy.dao.UserDAO;
import easyBuy.dao.UserDAOImpl;
import easyBuy.model.User;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;


    @Override
    public void init() throws ServletException {

        userDAO = new UserDAOImpl();

        System.out.println("=================================");
        System.out.println("REGISTER CONTROLLER INITIALIZED");
        System.out.println("=================================");
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/register.jsp"
        ).forward(
                request,
                response
        );
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        System.out.println("=================================");
        System.out.println("REGISTER CONTROLLER - doPost()");
        System.out.println("=================================");


        /* =====================================================
           GET FORM VALUES
        ===================================================== */

        String name =
                request.getParameter("name");

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");

        String phone =
                request.getParameter("phone");


        /* =====================================================
           REMOVE UNNECESSARY SPACES
        ===================================================== */

        if (name != null) {
            name = name.trim();
        }

        if (email != null) {
            email = email.trim();
        }

        if (phone != null) {
            phone = phone.trim();
        }


        /* =====================================================
           BASIC VALIDATION
        ===================================================== */

        if (name == null
                || name.isEmpty()
                || email == null
                || email.isEmpty()
                || password == null
                || password.isEmpty()
                || phone == null
                || phone.isEmpty()) {

            request.setAttribute(
                    "error",
                    "All fields are required."
            );

            request.getRequestDispatcher(
                    "/register.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        /* =====================================================
           CONFIRM PASSWORD
        ===================================================== */

        if (confirmPassword == null
                || confirmPassword.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please confirm your password."
            );

            request.getRequestDispatcher(
                    "/register.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "error",
                    "Passwords do not match."
            );

            request.getRequestDispatcher(
                    "/register.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        /* =====================================================
           CHECK EMAIL
        ===================================================== */

        if (userDAO.emailExists(email)) {

            request.setAttribute(
                    "error",
                    "This email is already registered."
            );

            request.getRequestDispatcher(
                    "/register.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        /* =====================================================
           HASH PASSWORD
        ===================================================== */

        String passwordHash =
                hashPassword(password);


        /* =====================================================
           CREATE USER
        ===================================================== */

        User user = new User(
                name,
                email,
                passwordHash,
                phone
        );


        /* =====================================================
           SAVE USER
        ===================================================== */

        boolean registered =
                userDAO.registerUser(user);


        if (registered) {

            System.out.println(
                    "================================="
            );

            System.out.println(
                    "USER REGISTRATION SUCCESSFUL"
            );

            System.out.println(
                    "Email: " + email
            );

            System.out.println(
                    "================================="
            );


            /*
             * Redirect to login page.
             *
             * registered=true tells login.jsp
             * that registration was successful.
             */

            response.sendRedirect(
                    request.getContextPath()
                            + "/login?registered=true"
            );

            return;
        }


        /* =====================================================
           REGISTRATION FAILED
        ===================================================== */

        System.out.println(
                "USER REGISTRATION FAILED"
        );


        request.setAttribute(
                "error",
                "Registration failed. Please try again."
        );


        request.getRequestDispatcher(
                "/register.jsp"
        ).forward(
                request,
                response
        );
    }


    /* =========================================================
       PASSWORD HASHING
    ========================================================= */

    private String hashPassword(
            String password) {

        try {

            MessageDigest messageDigest =
                    MessageDigest.getInstance("SHA-256");


            byte[] hash =
                    messageDigest.digest(
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


        } catch (Exception e) {

            throw new RuntimeException(
                    "Password hashing failed",
                    e
            );
        }
    }
}