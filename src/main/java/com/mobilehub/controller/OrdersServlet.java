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

@WebServlet(name = "OrdersServlet", urlPatterns = {"/orders"})
public class OrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = null;
        String errorRedirectMsg = null;

        if (session == null) {
             errorRedirectMsg = "No active session. Please login to view your orders.";
        } else {
            currentUser = (User) session.getAttribute("user");
            String role = (String) session.getAttribute("role");
            if (currentUser == null) {
                 errorRedirectMsg = "You are not logged in. Please login to view your orders.";
            } else if (!"customer".equalsIgnoreCase(role)) {
                 errorRedirectMsg = "Access denied. Order history is available for customers only.";
            }
        }

        if (errorRedirectMsg != null) {
            session = request.getSession();
            session.setAttribute("errorMessage", errorRedirectMsg);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Order> orderList = new ArrayList<>();
        try {
            int userId = currentUser.getId();
            orderList = orderDAO.getOrdersByUserId(userId);

            if (orderList == null) {
                orderList = new ArrayList<>();
            }
            request.setAttribute("orderList", orderList);

            String successMessage = (String) session.getAttribute("orderSuccessMessage");
            if (successMessage != null) {
                request.setAttribute("pageSuccessMessage", successMessage);
                session.removeAttribute("orderSuccessMessage");
            }
            String pageErrorMessage = (String) session.getAttribute("orderErrorMessage");
            if (pageErrorMessage != null) {
                request.setAttribute("pageErrorMessage", pageErrorMessage);
                session.removeAttribute("orderErrorMessage");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("pageErrorMessage", "Could not load your order history at this time. Please try again later.");
            request.setAttribute("orderList", new ArrayList<Order>());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/orders.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet that fetches and displays the customer's order history.";
    }
}