package com.mobilehub.controller;

import com.mobilehub.dao.UserDAO;
import com.mobilehub.dao.ProductDAO;
import com.mobilehub.dao.OrderDAO;
import com.mobilehub.model.User;    // For session checking
import com.mobilehub.model.Order;   // For the list of recent sales

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList; // For initializing empty lists if DAO returns null
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
        System.out.println("AdminDashboardServlet Initialized with all DAOs.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("AdminDashboardServlet: doGet called for /admin/dashboard.");
        HttpSession session = request.getSession(false);

        // --- Security Check: Admin Role Required ---
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("AdminDashboardServlet: Admin access denied. User not admin or not logged in. Redirecting to login.");
            session = request.getSession(); // Ensure session exists to set the error message
            session.setAttribute("errorMessage", "Admin access required. Please login with admin credentials.");
            response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login servlet
            return;
        }
        
        request.setAttribute("totalSales", 0.0);
        request.setAttribute("totalOrders", 0L);
        request.setAttribute("totalCustomers", 0L);
        request.setAttribute("totalProducts", 0L);
        request.setAttribute("recentSalesList", new ArrayList<Order>());
        request.setAttribute("monthlySalesData", "Placeholder: Monthly sales chart data not loaded.");
        request.setAttribute("weeklyVisitorData", "Placeholder: Weekly visitors chart data not loaded.");

        try {
            System.out.println("AdminDashboardServlet: Fetching dashboard statistics...");

            // Fetch all statistics using the respective DAO methods
            double totalSales = orderDAO.getTotalSalesAmount();
            long totalOrders = orderDAO.getTotalOrderCount();
            long totalCustomers = userDAO.getTotalCustomerCount();
            long totalProducts = productDAO.getTotalProductCount();
            List<Order> recentSales = orderDAO.getRecentSales(5); // Get top 5 recent sales

            // Set the fetched data as request attributes for admindash.jsp
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("recentSalesList", recentSales != null ? recentSales : new ArrayList<Order>()); // Ensure not null

            System.out.println("AdminDashboardServlet: Statistics prepared successfully.");
            System.out.println("  Total Sales: " + totalSales);
            System.out.println("  Total Orders: " + totalOrders);
            System.out.println("  Total Customers: " + totalCustomers);
            System.out.println("  Total Products: " + totalProducts);
            System.out.println("  Recent Sales Fetched: " + (recentSales != null ? recentSales.size() : "null list from DAO"));

        } catch (Exception e) {
            System.err.println("AdminDashboardServlet: CRITICAL ERROR fetching dashboard data - " + e.getMessage());
            e.printStackTrace(); 
            request.setAttribute("dashboardErrorMessage", "Could not load all dashboard statistics due to a server error.");
            
        }

        System.out.println("AdminDashboardServlet: Forwarding request to /WEB-INF/pages/admindash.jsp");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/admindash.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         
         System.out.println("AdminDashboardServlet: doPost called, delegating to doGet.");
         doGet(request, response);
     }

    @Override
    public String getServletInfo() {
        return "Servlet for Admin Dashboard. Fetches and displays site statistics and recent sales.";
    }
}