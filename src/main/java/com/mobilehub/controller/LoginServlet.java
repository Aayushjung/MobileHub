package com.mobilehub.controller;

import com.mobilehub.dao.UserDAO;
import com.mobilehub.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login") // Mapped to /login
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        System.out.println("LoginServlet Initialized.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("LoginServlet: doPost called.");

        String username = request.getParameter("username");
        String password = request.getParameter("password"); // Plaintext password from form
        String errorMessage = null;
        User user = null;

        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            errorMessage = "Username and password are required.";
            System.out.println("LoginServlet: Validation failed - " + errorMessage);
        } else {
            System.out.println("LoginServlet: Attempting to validate user: " + username);
            // UserDAO.validateUser now handles bcrypt comparison
            user = userDAO.validateUser(username.trim(), password);
        }

        if (user != null) { // Login successful
            HttpSession session = request.getSession(); // Get or create session
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            System.out.println("LoginServlet: Login successful for user: " + user.getUsername() + ", Role: " + user.getRole());

            // ****** REVISED: Redirect based on role ******
            if ("admin".equalsIgnoreCase(user.getRole())) {
                System.out.println("LoginServlet: Redirecting admin to /admin/dashboard");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard"); // Redirect to AdminDashboardServlet
            } else if ("customer".equalsIgnoreCase(user.getRole())) {
                System.out.println("LoginServlet: Redirecting customer to /dashboard");
                response.sendRedirect(request.getContextPath() + "/dashboard"); // Redirect to UserDashboardServlet
            } else {
                // Fallback for unknown role - might redirect to a generic page or error
                System.err.println("LoginServlet: Unknown role for user " + user.getUsername() + ": " + user.getRole());
                errorMessage = "Login successful, but user role is not recognized for redirection.";
                request.setAttribute("errorMessage", errorMessage);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/login.jsp");
                dispatcher.forward(request, response);
            }
           
            return;

        } else { // Login failed (user == null)
            if (errorMessage == null) { // Only set if not already set by empty field check
                 errorMessage = "Invalid username or password.";
            }
            request.setAttribute("errorMessage", errorMessage);
            System.out.println("LoginServlet: Login failed for username: " + username + ". Error: " + errorMessage);

            // Forward back to login page with the error message
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show the login page on GET request
        System.out.println("LoginServlet: doGet called, showing login page.");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/login.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet that handles user login attempts.";
    }
}