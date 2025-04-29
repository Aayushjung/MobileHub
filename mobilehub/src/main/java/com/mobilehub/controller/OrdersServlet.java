package com.mobilehub.controller;

import com.mobilehub.model.Order; // Import the Order model
import com.mobilehub.model.User;  // Import User model to get user ID

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate; // Use if Order model uses LocalDate
import java.util.ArrayList;
import java.util.List;
// Import Date if Order model uses java.util.Date

@WebServlet(name = "OrdersServlet", urlPatterns = {"/orders"})
public class OrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- Placeholder Service/DAO Method ---
    // Replace this with a call to your OrderDAO/OrderService
    // It should take the userId and return their orders
    private List<Order> getMockOrdersForUser(int userId) {
        System.out.println("OrdersServlet: Fetching mock orders for user ID: " + userId);
        List<Order> userOrders = new ArrayList<>();
        // Example data matching the reference image
        userOrders.add(new Order("ORD-2023-001", LocalDate.of(2023, 12, 15), "iPhone 14 Pro", 999.00, "Delivered", userId));
        userOrders.add(new Order("ORD-2023-002", LocalDate.of(2023, 11, 22), "Samsung Galaxy S23", 899.00, "Shipped", userId));
        userOrders.add(new Order("ORD-2023-003", LocalDate.of(2023, 10, 30), "Google Pixel 7", 699.00, "Processing", userId));
        userOrders.add(new Order("ORD-2024-001", LocalDate.of(2024, 1, 5), "AirPods Pro", 249.00, "Delivered", userId));
        userOrders.add(new Order("ORD-2024-002", LocalDate.of(2024, 2, 18), "Apple Watch Series 8", 399.00, "Delivered", userId));
        return userOrders;
    }
    // --- End Placeholder ---

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
                 errorRedirectMsg = "Access denied. Please login as a customer.";
                 // Optional: Redirect admins elsewhere if needed
                 // response.sendRedirect(request.getContextPath() + "/admin/dashboard"); return;
            }
        }

        if (errorRedirectMsg != null) {
            System.out.println("OrdersServlet: Security check failed - " + errorRedirectMsg);
            session = request.getSession(); // Ensure session for message
            session.setAttribute("errorMessage", errorRedirectMsg);
            response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login servlet
            return;
        }
        // --- End Security Check ---

        try {
            // --- Fetch Orders for the Logged-in User ---
            int userId = currentUser.getId(); // Get ID from the User object in session
            List<Order> orderList = getMockOrdersForUser(userId); // Pass the user ID

            // --- Set Data for JSP ---
            request.setAttribute("orderList", orderList);
            System.out.println("OrdersServlet: Fetched " + orderList.size() + " orders for user " + currentUser.getUsername());

        } catch (Exception e) {
            System.err.println("OrdersServlet: Error fetching order data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("pageErrorMessage", "Could not load your order history.");
        }

        // --- Forward to the Orders JSP ---
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/orders.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet that fetches and displays the customer's order history.";
    }
}