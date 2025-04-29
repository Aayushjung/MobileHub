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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String errorMessage = null;
        User user = null;

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            errorMessage = "Username and password are required.";
        } else {
            // !! IMPORTANT: In production, retrieve hashed password and compare hashes !!
            user = userDAO.validateUser(username, password);
        }

        if (user != null) {
            // User is valid, create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // Store the whole user object or just needed info
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            System.out.println("Login successful for: " + user.getUsername() + ", Role: " + user.getRole());


            // Redirect based on role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                 // Forward to admin dashboard JSP inside WEB-INF
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/admindash.jsp");
                dispatcher.forward(request, response);
            } else {
                 // Forward to user dashboard JSP inside WEB-INF
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/userdash.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            // Invalid credentials or error during validation
            if (errorMessage == null) { // Only set if not already set by empty field check
                 errorMessage = "Invalid username or password.";
            }
            request.setAttribute("errorMessage", errorMessage);
            System.out.println("Login failed for username: " + username);

            // Forward back to login page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Optionally handle GET requests, e.g., show the login page
         RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/login.jsp");
         dispatcher.forward(request, response);
    }
}