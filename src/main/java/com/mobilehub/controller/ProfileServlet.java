package com.mobilehub.controller;

import com.mobilehub.model.User;
import com.mobilehub.dao.UserDAO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/profile/update"})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        System.out.println("ProfileServlet Initialized with UserDAO.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ProfileServlet: doGet called for /profile");
        HttpSession session = request.getSession(false);
        User currentUser = null;

        String errorRedirectMsg = null;
        if (session == null) {
             errorRedirectMsg = "No active session. Please login to view your profile.";
        } else {
            currentUser = (User) session.getAttribute("user");
            String role = (String) session.getAttribute("role");
            if (currentUser == null) {
                 errorRedirectMsg = "You are not logged in. Please login to view your profile.";
            } else if (!"customer".equalsIgnoreCase(role)) {
                 errorRedirectMsg = "Access denied. Profile page is for customers only.";
            }
        }

        if (errorRedirectMsg != null) {
            System.out.println("ProfileServlet: Security check failed in doGet - " + errorRedirectMsg);
            session = request.getSession();
            session.setAttribute("errorMessage", errorRedirectMsg);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("userProfile", currentUser);
        System.out.println("ProfileServlet: Displaying profile for user: " + currentUser.getUsername());

        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        String profileErrorMessage = (String) session.getAttribute("errorMessage");
        if (profileErrorMessage != null && errorRedirectMsg == null) {
            request.setAttribute("errorMessage", profileErrorMessage);
            session.removeAttribute("errorMessage");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/profile.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ProfileServlet: doPost called for /profile/update (or /profile)");
        HttpSession session = request.getSession(false);

        User currentUser = null;
        if (session == null || session.getAttribute("user") == null) {
            System.err.println("ProfileServlet: Update attempt without session/user. Redirecting to login.");
            session = request.getSession();
            session.setAttribute("errorMessage", "Your session expired or you are not logged in. Please login again to update your profile.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        } else {
            currentUser = (User) session.getAttribute("user");
            String role = (String) session.getAttribute("role");
            if (!"customer".equalsIgnoreCase(role)) {
                System.err.println("ProfileServlet: Non-customer attempted profile update. User: " + currentUser.getUsername());
                session.setAttribute("errorMessage", "Profile update restricted to customers.");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }
        }

        String userIdStr = request.getParameter("userId");
        String newUsername = request.getParameter("username");
        String newEmail = request.getParameter("email");
        String newPhone = request.getParameter("phone");

        System.out.println("ProfileServlet: Received update request for User ID: " + userIdStr);
        System.out.println("ProfileServlet: New Username: " + newUsername + ", New Email: " + newEmail + ", New Phone: " + newPhone);

        if (newUsername == null || newUsername.trim().isEmpty() ||
            newEmail == null || newEmail.trim().isEmpty()) {
            System.err.println("ProfileServlet: Validation failed - Username or Email is empty.");
            session.setAttribute("errorMessage", "Username and Email cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        try {
            int formUserId = Integer.parseInt(userIdStr);
            if (formUserId != currentUser.getId()) {
                System.err.println("ProfileServlet: Security alert! User ID mismatch. Session User: " + currentUser.getId() + ", Form User ID: " + formUserId);
                session.setAttribute("errorMessage", "Authorization error: Cannot update another user's profile.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
        } catch (NumberFormatException e) {
            System.err.println("ProfileServlet: Invalid User ID format in form: " + userIdStr);
            session.setAttribute("errorMessage", "Invalid user data submitted.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        boolean changed = false;
        if (!newUsername.trim().equals(currentUser.getUsername())) {
            User existingUserWithNewUsername = userDAO.getUserByUsername(newUsername.trim());
            if (existingUserWithNewUsername != null && existingUserWithNewUsername.getId() != currentUser.getId()) {
                session.setAttribute("errorMessage", "Username '" + newUsername.trim() + "' is already taken.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
            currentUser.setUsername(newUsername.trim());
            changed = true;
        }
        if (!newEmail.trim().equals(currentUser.getEmail())) {
            User existingUserWithNewEmail = userDAO.getUserByEmail(newEmail.trim());
            if (existingUserWithNewEmail != null && existingUserWithNewEmail.getId() != currentUser.getId()) {
                session.setAttribute("errorMessage", "Email '" + newEmail.trim() + "' is already registered to another account.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
            currentUser.setEmail(newEmail.trim());
            changed = true;
        }

        String currentPhone = currentUser.getPhone() == null ? "" : currentUser.getPhone();
        String formPhone = newPhone == null ? "" : newPhone.trim();
        if (!formPhone.equals(currentPhone)) {
            currentUser.setPhone(formPhone.isEmpty() ? null : formPhone);
            changed = true;
        }

        if (!changed) {
            session.setAttribute("successMessage", "No changes were made to your profile.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        boolean updateSuccess = userDAO.updateUserProfile(currentUser);

        if (updateSuccess) {
            System.out.println("ProfileServlet: Profile updated successfully for user: " + currentUser.getUsername());
            session.setAttribute("user", currentUser);
            session.setAttribute("username", currentUser.getUsername());
            session.setAttribute("successMessage", "Your profile has been updated successfully!");
        } else {
            System.err.println("ProfileServlet: Failed to update profile in database for user: " + currentUser.getUsername());
            session.setAttribute("errorMessage", "Failed to update your profile due to a server error. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    @Override
    public String getServletInfo() {
        return "Servlet that handles displaying and updating customer profile information.";
    }
}