package com.mobilehub.controller;

import com.mobilehub.dao.OrderDAO;
import com.mobilehub.model.Order;
import com.mobilehub.model.User;

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

@WebServlet(name = "ManageSalesServlet", urlPatterns = {"/admin/manage-sales"})
public class ManageSalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        System.out.println("ManageSalesServlet Initialized with OrderDAO.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageSalesServlet: doGet called.");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("ManageSalesServlet: Admin access denied. Redirecting to login.");
            session = request.getSession();
            session.setAttribute("errorMessage", "Admin access required.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("list".equals(action)) {
                System.out.println("ManageSalesServlet: Listing all sales for admin.");
                List<Order> allSales = orderDAO.getAllOrdersAdminView(); // Use the new DAO method

                if (allSales == null) {
                    System.err.println("ManageSalesServlet: DAO returned null for allSales! Initializing empty list.");
                    allSales = new ArrayList<>();
                }
                request.setAttribute("salesList", allSales); // Pass to JSP

                String successMessage = (String) session.getAttribute("manageSalesSuccessMessage");
                if (successMessage != null) {
                    request.setAttribute("successMessage", successMessage);
                    session.removeAttribute("manageSalesSuccessMessage");
                }
                String errorMessage = (String) session.getAttribute("manageSalesErrorMessage");
                if (errorMessage != null) {
                    request.setAttribute("errorMessage", errorMessage);
                    session.removeAttribute("manageSalesErrorMessage");
                }
                System.out.println("ManageSalesServlet: Forwarding to manage_sales.jsp with " + allSales.size() + " sales.");
            }
            // Add other GET actions like viewing a specific sale detail if needed
            // else if ("view".equals(action)) { /* ... */ }
            else {
                System.out.println("ManageSalesServlet: Unknown GET action: " + action + ". Defaulting to list.");
                List<Order> allSales = orderDAO.getAllOrdersAdminView();
                request.setAttribute("salesList", allSales != null ? allSales : new ArrayList<Order>());
            }
        } catch (Exception e) {
            System.err.println("ManageSalesServlet (doGet): Error - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading sales data: " + e.getMessage());
            request.setAttribute("salesList", new ArrayList<Order>()); // Send empty list on error
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/manage-sales.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageSalesServlet: doPost called.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
            return;
        }

        String action = request.getParameter("action");
        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("newStatus");

        System.out.println("ManageSalesServlet: doPost action: " + action + ", orderId: " + orderId + ", newStatus: " + newStatus);

        try {
            if ("updateStatus".equals(action) && orderId != null && !orderId.trim().isEmpty() &&
                newStatus != null && !newStatus.trim().isEmpty()) {
                boolean updated = orderDAO.updateOrderStatus(orderId.trim(), newStatus.trim());
                if (updated) {
                    session.setAttribute("manageSalesSuccessMessage", "Order " + orderId.trim() + " status updated to '" + newStatus.trim() + "'.");
                } else {
                    session.setAttribute("manageSalesErrorMessage", "Failed to update status for order " + orderId.trim() + ". Order not found or DB error.");
                }
            } else {
                session.setAttribute("manageSalesErrorMessage", "Invalid action or missing parameters for updating order status.");
            }
        } catch (Exception e) {
            System.err.println("ManageSalesServlet (doPost): Error processing updateStatus - " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("manageSalesErrorMessage", "An error occurred while updating status: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-sales"); // PRG pattern
    }

    @Override
    public String getServletInfo() { return "Servlet for Admin to Manage All Sales/Orders."; }
}