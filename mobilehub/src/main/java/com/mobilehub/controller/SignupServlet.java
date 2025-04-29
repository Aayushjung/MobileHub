package com.mobilehub.controller;

import com.mobilehub.dao.UserDAO;
import com.mobilehub.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
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
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String errorMessage = null;
        String successMessage = null;

        // Basic Server-Side Validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            errorMessage = "All fields except phone are required.";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Passwords do not match.";
        } else if (userDAO.userExists(username)) {
             errorMessage = "Username already exists.";
        } else if (userDAO.emailExists(email)) {
             errorMessage = "Email already registered.";
        } else {
            // Validation passed, attempt to register
            // !! IMPORTANT: HASH the password before creating the User object in production !!
            // String hashedPassword = hashFunction(password); // Implement a hashing function
            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setEmail(email.trim());
            newUser.setPhone(phone != null ? phone.trim() : null); // Phone is optional
            newUser.setPassword(password); // Storing plaintext - INSECURE! Use hashedPassword
            newUser.setRole("customer"); // Default role for signup

            boolean registered = userDAO.addUser(newUser);

            if (registered) {
                successMessage = "Registration successful! Please log in.";
                System.out.println("Signup successful for: " + username);
                // Redirect to login page with success message
                request.setAttribute("successMessage", successMessage);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/login.jsp");
                dispatcher.forward(request, response);
                return; // Important to return after forwarding
            } else {
                errorMessage = "Registration failed due to a server error. Please try again.";
                System.err.println("Signup failed for: " + username);
            }
        }

        // If there was an error or registration failed
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("usernameValue", username);
        request.setAttribute("emailValue", email);
        request.setAttribute("phoneValue", phone);

        // Forward back to signup page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/signup.jsp");
        dispatcher.forward(request, response);
    }

     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show the signup page on GET request
         RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/signup.jsp");
         dispatcher.forward(request, response);
    }
}