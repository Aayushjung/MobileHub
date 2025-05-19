package com.mobilehub.controller;

import com.mobilehub.model.User;
import com.mobilehub.dao.UserDAO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Crucial Import
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

// ****** ENSURE THIS ANNOTATION IS CORRECT AND MATCHES THE LINK ******
@WebServlet(name = "ManageUsersServlet", urlPatterns = {"/admin/manage-users"})
// ********************************************************************
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        System.out.println("ManageUsersServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageUsersServlet: doGet called for /admin/manage-users");
        HttpSession session = request.getSession(false);

        // --- Security Check: Admin Only ---
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("ManageUsersServlet: Admin access denied. Redirecting to login.");
            session = request.getSession();
            session.setAttribute("errorMessage", "Admin access required. Please login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            System.out.println("ManageUsersServlet: Fetching all users.");
            List<User> allUsers = userDAO.getAllUsers();

            User loggedInAdmin = (User) session.getAttribute("user");
            if (loggedInAdmin != null && allUsers != null) {
                final int adminId = loggedInAdmin.getId();
                allUsers = allUsers.stream()
                                  .filter(u -> u.getId() != adminId)
                                  .collect(Collectors.toList());
                System.out.println("ManageUsersServlet: Filtered current admin. Users to display: " + (allUsers != null ? allUsers.size() : "null"));
            }

            request.setAttribute("userList", allUsers);

            String successMessage = (String) session.getAttribute("manageUserSuccessMessage");
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("manageUserSuccessMessage");
            }
            String errorMessage = (String) session.getAttribute("manageUserErrorMessage");
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("manageUserErrorMessage");
            }
            System.out.println("ManageUsersServlet: Forwarding to /WEB-INF/pages/admin/manage_users.jsp");
        } catch (Exception e) {
            System.err.println("ManageUsersServlet (doGet): Error fetching user list: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading user data.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/manage_users.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageUsersServlet: doPost called for /admin/manage-users");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("ManageUsersServlet: Admin access denied for POST.");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
            return;
        }

        String action = request.getParameter("action");
        String successMessage = null;
        String errorMessage = null;
        System.out.println("ManageUsersServlet: doPost action: " + action);

        if ("delete".equals(action)) {
            try {
                String userIdParam = request.getParameter("userId");
                if (userIdParam == null || userIdParam.trim().isEmpty()) {
                    throw new NumberFormatException("User ID parameter is missing or empty for deletion.");
                }
                int userIdToDelete = Integer.parseInt(userIdParam);
                User loggedInAdmin = (User) session.getAttribute("user");

                if (loggedInAdmin != null && userIdToDelete == loggedInAdmin.getId()) {
                    errorMessage = "You cannot delete your own admin account.";
                } else {
                    boolean deleted = userDAO.deleteUser(userIdToDelete);
                    if (deleted) {
                        successMessage = "User (ID: " + userIdToDelete + ") successfully deleted.";
                    } else {
                        errorMessage = "Failed to delete user (ID: " + userIdToDelete + ").";
                    }
                }
            } catch (NumberFormatException e) {
                errorMessage = "Invalid user ID for deletion.";
                e.printStackTrace();
            } catch (Exception e) {
                errorMessage = "An error occurred while deleting the user.";
                e.printStackTrace();
            }
        } else {
            errorMessage = "Invalid action specified: " + action;
        }

        if (successMessage != null) session.setAttribute("manageUserSuccessMessage", successMessage);
        if (errorMessage != null) session.setAttribute("manageUserErrorMessage", errorMessage);

        response.sendRedirect(request.getContextPath() + "/admin/manage-users");
    }

    @Override
    public String getServletInfo() {
        return "Servlet for administrators to manage user accounts.";
    }
}