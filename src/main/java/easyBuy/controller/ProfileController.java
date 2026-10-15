package easyBuy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import easyBuy.dao.UserProfileDAO;
import easyBuy.dao.UserProfileDAOImpl;
import easyBuy.model.User;
import easyBuy.model.UserProfile;
import easyBuy.util.DBConnection;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserProfileDAO userProfileDAO;


    // =========================================================
    // INITIALIZE
    // =========================================================

    @Override
    public void init() throws ServletException {

        userProfileDAO = new UserProfileDAOImpl();
    }


    // =========================================================
    // GET PROFILE
    // =========================================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // -----------------------------------------------------
        // USER MUST BE LOGGED IN
        // -----------------------------------------------------

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        // -----------------------------------------------------
        // GET USER ID
        // -----------------------------------------------------

        Integer userId = getUserIdFromSession(session);

        if (userId == null || userId <= 0) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        // -----------------------------------------------------
        // GET USER
        // -----------------------------------------------------

        User user = getUserFromSession(session);


        // -----------------------------------------------------
        // GET PROFILE
        // -----------------------------------------------------

        UserProfile profile =
                userProfileDAO.getProfileByUserId(userId);


        // -----------------------------------------------------
        // SEND DATA TO JSP
        // -----------------------------------------------------

        request.setAttribute("user", user);
        request.setAttribute("profile", profile);
        request.setAttribute("userId", userId);

        request.getRequestDispatcher(
                "/profile.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // SAVE / UPDATE PROFILE
    // =========================================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // -----------------------------------------------------
        // USER MUST BE LOGGED IN
        // -----------------------------------------------------

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        // -----------------------------------------------------
        // GET USER ID
        // -----------------------------------------------------

        Integer userId = getUserIdFromSession(session);

        if (userId == null || userId <= 0) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        // -----------------------------------------------------
        // READ FORM VALUES
        // -----------------------------------------------------

        String firstName =
                clean(request.getParameter("firstName"));

        String lastName =
                clean(request.getParameter("lastName"));

        String phone =
                clean(request.getParameter("phone"));

        String gender =
                clean(request.getParameter("gender"));

        String address =
                clean(request.getParameter("address"));


        // -----------------------------------------------------
        // VALIDATION
        // -----------------------------------------------------

        if (firstName.isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "First name is required."
            );

            loadProfileForRequest(
                    request,
                    session,
                    userId
            );

            request.getRequestDispatcher(
                    "/profile.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        if (phone.isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Mobile number is required."
            );

            loadProfileForRequest(
                    request,
                    session,
                    userId
            );

            request.getRequestDispatcher(
                    "/profile.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // -----------------------------------------------------
        // BASIC PHONE VALIDATION
        // -----------------------------------------------------

        String phoneForValidation =
                phone.replaceAll("[\\s()+-]", "");

        if (!phoneForValidation.matches("\\d{10,15}")) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter a valid mobile number."
            );

            loadProfileForRequest(
                    request,
                    session,
                    userId
            );

            request.getRequestDispatcher(
                    "/profile.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // -----------------------------------------------------
        // CREATE PROFILE OBJECT
        // -----------------------------------------------------

        UserProfile profile =
                new UserProfile();

        profile.setUserId(userId);
        profile.setFirstName(firstName);
        profile.setLastName(lastName);
        profile.setGender(gender);
        profile.setAddress(address);


        // -----------------------------------------------------
        // GET EXISTING PROFILE
        // -----------------------------------------------------

        UserProfile existingProfile =
                userProfileDAO.getProfileByUserId(userId);

        boolean profileSuccess;


        // -----------------------------------------------------
        // CREATE OR UPDATE PROFILE
        // -----------------------------------------------------

        if (existingProfile == null) {

            profileSuccess =
                    userProfileDAO.createProfile(profile);

        } else {

            profile.setProfileId(
                    existingProfile.getProfileId()
            );

            profileSuccess =
                    userProfileDAO.updateProfile(profile);
        }


        // -----------------------------------------------------
        // UPDATE MOBILE NUMBER IN users TABLE
        // -----------------------------------------------------

        boolean phoneSuccess =
                updatePhoneNumber(
                        userId,
                        phone
                );


        // -----------------------------------------------------
        // CHECK BOTH OPERATIONS
        // -----------------------------------------------------

        if (profileSuccess && phoneSuccess) {

            // -------------------------------------------------
            // UPDATE USER OBJECT IN SESSION
            // -------------------------------------------------

            User sessionUser =
                    getUserFromSession(session);

            if (sessionUser != null) {

                sessionUser.setPhone(phone);

                session.setAttribute(
                        "user",
                        sessionUser
                );
            }


            // -------------------------------------------------
            // UPDATE INDIVIDUAL SESSION ATTRIBUTE
            // -------------------------------------------------

            session.setAttribute(
                    "userPhone",
                    phone
            );


            // -------------------------------------------------
            // SUCCESS MESSAGE
            // -------------------------------------------------

            session.setAttribute(
                    "profileSuccessMessage",
                    "Profile details updated successfully."
            );


            response.sendRedirect(
                    request.getContextPath() + "/profile"
            );

            return;
        }


        // -----------------------------------------------------
        // FAILURE
        // -----------------------------------------------------

        request.setAttribute(
                "errorMessage",
                "Unable to save your profile details. Please try again."
        );

        loadProfileForRequest(
                request,
                session,
                userId
        );

        request.getRequestDispatcher(
                "/profile.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // UPDATE PHONE NUMBER
    // =========================================================

    private boolean updatePhoneNumber(
            int userId,
            String phone) {

        String sql =
                "UPDATE users " +
                "SET phone = ? " +
                "WHERE user_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, phone);
            statement.setInt(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }


    // =========================================================
    // GET USER ID FROM SESSION
    // =========================================================

    private Integer getUserIdFromSession(
            HttpSession session) {

        Object userIdObject =
                session.getAttribute("userId");

        if (userIdObject instanceof Integer) {

            return (Integer) userIdObject;
        }

        if (userIdObject instanceof String) {

            try {

                return Integer.parseInt(
                        (String) userIdObject
                );

            } catch (NumberFormatException e) {

                return null;
            }
        }

        return null;
    }


    // =========================================================
    // GET USER OBJECT FROM SESSION
    // =========================================================

    private User getUserFromSession(
            HttpSession session) {

        Object userObject =
                session.getAttribute("user");

        if (userObject instanceof User) {

            return (User) userObject;
        }

        return null;
    }


    // =========================================================
    // CLEAN FORM VALUES
    // =========================================================

    private String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }


    // =========================================================
    // LOAD PROFILE FOR ERROR RESPONSE
    // =========================================================

    private void loadProfileForRequest(
            HttpServletRequest request,
            HttpSession session,
            int userId) {

        User user =
                getUserFromSession(session);

        UserProfile profile =
                userProfileDAO.getProfileByUserId(userId);

        request.setAttribute(
                "user",
                user
        );

        request.setAttribute(
                "profile",
                profile
        );

        request.setAttribute(
                "userId",
                userId
        );
    }
}