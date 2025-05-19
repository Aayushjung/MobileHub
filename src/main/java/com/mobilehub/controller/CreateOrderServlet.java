package com.mobilehub.controller;

import com.mobilehub.dao.OrderDAO;
import com.mobilehub.model.Order;
import com.mobilehub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.UUID;

@WebServlet("/createOrder")
public class CreateOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            session = request.getSession();
            session.setAttribute("errorMessage", "You must be logged in to place an order.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"customer".equalsIgnoreCase(currentUser.getRole())) {
             session.setAttribute("errorMessage", "Only customers can place orders.");
             response.sendRedirect(request.getContextPath() + "/dashboard");
             return;
        }

        String productName = request.getParameter("productName");
        String productPriceStr = request.getParameter("productPrice");

        if (productName == null || productName.trim().isEmpty() ||
            productPriceStr == null || productPriceStr.trim().isEmpty()) {
            session.setAttribute("orderErrorMessage", "Incomplete product information. Order could not be placed.");
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            double productPrice = Double.parseDouble(productPriceStr);
            int userId = currentUser.getId();

            String orderId = "ORD-" + LocalDate.now().getYear() + "-" +
                             (System.currentTimeMillis() % 100000) + "-" +
                             UUID.randomUUID().toString().substring(0, 4).toUpperCase();

            Order newOrder = new Order();
            newOrder.setOrderId(orderId);
            newOrder.setUserId(userId);
            newOrder.setProductName(productName.trim());
            newOrder.setTotalPrice(productPrice);
            newOrder.setOrderDate(new Timestamp(System.currentTimeMillis()));
            newOrder.setStatus("Completed");

            boolean orderCreated = orderDAO.createOrder(newOrder);

            if (orderCreated) {
                session.setAttribute("orderSuccessMessage", "Your order for '" + productName.trim() + "' has been placed successfully! Order ID: " + orderId);
            } else {
                session.setAttribute("orderErrorMessage", "There was an issue placing your order. Please try again or contact support.");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("orderErrorMessage", "Invalid product price. Order could not be placed.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("orderErrorMessage", "An unexpected error occurred while placing your order. Please try again.");
        }
        response.sendRedirect(request.getContextPath() + "/orders");
    }
}