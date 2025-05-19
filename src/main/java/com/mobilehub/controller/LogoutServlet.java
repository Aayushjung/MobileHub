package com.mobilehub.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false); // Don't create session if it doesn't exist
        if (session != null) {
            String username = (String) session.getAttribute("username");
            session.invalidate(); // Invalidate the session
            System.out.println("User logged out: " + (username != null ? username : "Unknown"));
        }

       
        request.setAttribute("successMessage", "You have been logged out successfully.");

        
         RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/login.jsp");
         dispatcher.forward(request, response);
    }
}