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
import org.mindrot.jbcrypt.BCrypt; // For hashing

import java.io.IOException;
import java.sql.Timestamp; // For setting created_at

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

        System.out.println("--- SignupServlet: doPost Received ---");
        System.out.println("Raw Username: " + username);
        System.out.println("Raw Email: " + email);
        System.out.println("Raw Phone: " + phone);
        

        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            errorMessage = "All fields except phone are required.";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Passwords do not match.";
        } else if (userDAO.userExists(username.trim())) {
             errorMessage = "Username already exists.";
        } else if (userDAO.emailExists(email.trim())) {
             errorMessage = "Email already registered.";
        } else if (password.length() < 8) {
            errorMessage = "Password must be at least 8 characters long.";
        } else {
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setEmail(email.trim());
            newUser.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null); // Ensure empty string becomes null
            newUser.setPassword(hashedPassword);
            newUser.setRole("customer");
           

            System.out.println("--- SignupServlet: About to call UserDAO.addUser ---");
            System.out.println("User to add - Username: " + newUser.getUsername());
            System.out.println("User to add - Email: " + newUser.getEmail());
            System.out.println("User to add - Phone: " + newUser.getPhone());
            System.out.println("User to add - Hashed Password (length " + newUser.getPassword().length() + "): " + newUser.getPassword());
            System.out.println("User to add - Role: " + newUser.getRole());
            System.out.println("--------------------------------------------------");

            boolean registered = userDAO.addUser(newUser);

            if (registered) {
                System.out.println("SignupServlet: User '" + username + "' registered successfully.");
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Registration successful! Please log in.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            } else {
                errorMessage = "Registration failed due to a server error. Please try again.";
                System.err.println("SignupServlet: Registration failed for user '" + username + "'. UserDAO.addUser returned false. Check DAO logs for SQL errors.");
            }
        }

        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("usernameValue", username);
        request.setAttribute("emailValue", email);
        request.setAttribute("phoneValue", phone);

        System.out.println("SignupServlet: Forwarding back to signup.jsp with error: " + errorMessage);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/signup.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/signup.jsp");
        dispatcher.forward(request, response);
    }
}