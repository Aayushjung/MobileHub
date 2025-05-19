package com.mobilehub.controller;

import com.mobilehub.model.Product;
import com.mobilehub.model.User;
import com.mobilehub.dao.ProductDAO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/dashboard"})
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        System.out.println("UserDashboardServlet Initialized with ProductDAO.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("UserDashboardServlet: doGet called for /dashboard");
        HttpSession session = request.getSession(false);

        String errorRedirectMsg = null;
        User currentUser = null;
        if (session == null) { errorRedirectMsg = "No active session. Please login."; }
        else {
            currentUser = (User) session.getAttribute("user");
            String role = (String) session.getAttribute("role");
            if (currentUser == null) { errorRedirectMsg = "User not logged in. Please login."; }
            else if (!"customer".equalsIgnoreCase(role)) { errorRedirectMsg = "Access denied."; }
        }
        if (errorRedirectMsg != null) {
            System.out.println("UserDashboardServlet: Security check failed - " + errorRedirectMsg);
            session = request.getSession(); // Create session if null to set message
            session.setAttribute("errorMessage", errorRedirectMsg);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Product> premiumMobiles = new ArrayList<>();
        List<Product> standardMobiles = new ArrayList<>();

        try {
            System.out.println("UserDashboardServlet: Attempting to fetch Premium Mobiles...");
            premiumMobiles = productDAO.getProductsByCategory("Premium"); // Call getProductsByCategory
             // Ensure list is not null from DAO
            if (premiumMobiles == null) {
                System.err.println("UserDashboardServlet: DAO returned null for Premium Mobiles! Using empty list.");
                premiumMobiles = new ArrayList<>();
            }
            System.out.println("UserDashboardServlet: Fetched " + premiumMobiles.size() + " Premium Mobiles.");


            System.out.println("UserDashboardServlet: Attempting to fetch Standard Mobiles...");
            standardMobiles = productDAO.getProductsByCategory("Standard"); // Call getProductsByCategory
             // Ensure list is not null from DAO
            if (standardMobiles == null) {
                 System.err.println("UserDashboardServlet: DAO returned null for Standard Mobiles! Using empty list.");
                standardMobiles = new ArrayList<>();
            }
             System.out.println("UserDashboardServlet: Fetched " + standardMobiles.size() + " Standard Mobiles.");


            request.setAttribute("premiumMobiles", premiumMobiles);
            request.setAttribute("standardMobiles", standardMobiles);

            System.out.println("UserDashboardServlet: Data prepared for user: " + currentUser.getUsername());

        } catch (Exception e) {
            System.err.println("UserDashboardServlet: CRITICAL ERROR fetching dashboard data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("dashboardErrorMessage", "Could not load products for the dashboard. Please try again later or contact support.");
            request.setAttribute("premiumMobiles", new ArrayList<>()); 
            request.setAttribute("standardMobiles", new ArrayList<>());
        }

       
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/userdash.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         System.out.println("UserDashboardServlet: doPost called, delegating to doGet.");
         doGet(request, response);
     }
    @Override
    public String getServletInfo() { return "Servlet for Customer Dashboard/Home page, showing categorized products."; }
}