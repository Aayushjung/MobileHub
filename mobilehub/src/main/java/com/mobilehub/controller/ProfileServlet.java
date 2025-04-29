package com.mobilehub.controller;

import com.mobilehub.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = null;
        String errorRedirectMsg = null;

        // --- Security Check: Ensure user is logged in AS CUSTOMER ---
        if (session == null) {
             errorRedirectMsg = "No active session. Please login.";
        } else {
            currentUser = (User) session.getAttribute("user");
            String role = (String) session.getAttribute("role");
            if (currentUser == null) {
                 errorRedirectMsg = "User not logged in. Please login.";
            } else if (!"customer".equalsIgnoreCase(role)) {
                 errorRedirectMsg = "Access denied."; // Or redirect admin
            }
        }

        if (errorRedirectMsg != null) {
            System.out.println("ProfileServlet: Security check failed - " + errorRedirectMsg);
            session = request.getSession(); // Ensure session for message
            session.setAttribute("errorMessage", errorRedirectMsg);
            response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login servlet
            return;
        }
        // --- End Security Check ---

        // --- Set User object for the JSP ---
        // The currentUser is already fetched during security check
        request.setAttribute("userProfile", currentUser); // Pass the user object to the JSP
        System.out.println("ProfileServlet: Displaying profile for user: " + currentUser.getUsername());

        // --- Forward to the Profile JSP ---
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/profile.jsp");
        dispatcher.forward(request, response);
    }

     @Override
    public String getServletInfo() {
        return "Servlet that fetches and displays the customer's profile page.";
    }
}