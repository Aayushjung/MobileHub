package com.mobilehub.controller;

import com.mobilehub.model.Product; // Use the existing model
import com.mobilehub.model.User; // Import User model

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
import java.util.stream.Collectors; // For potential filtering

@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/dashboard"}) // Handles the main dashboard request
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- Placeholder Data Fetching ---
    // In a real app, these would query the database via Service/DAO layers
    // to get products marked as 'onSale' or 'featured'.

    private List<Product> getMockSaleItems() {
        System.out.println("UserDashboardServlet: Fetching mock SALE items...");
        List<Product> saleItems = new ArrayList<>();
        // Example: Select 1-2 items marked for sale
        saleItems.add(new Product(203, "Google Pixel 8 Pro", "Unmatched camera intelligence.", "https://via.placeholder.com/200x150/cccccc/000000?text=Pixel+8+SALE", 899.00)); // Lower price
        saleItems.add(new Product(206, "Nothing Phone (2)", "Unique Glyph interface.", "https://via.placeholder.com/200x150/cccccc/000000?text=Nothing(2)SALE", 649.00)); // Lower price
        return saleItems;
    }

    private List<Product> getMockFeaturedItems() {
        System.out.println("UserDashboardServlet: Fetching mock FEATURED items...");
        List<Product> featuredItems = new ArrayList<>();
        // Example: Select a few premium/new items
        featuredItems.add(new Product(201, "iPhone 15 Pro", "Experience the future with A17 Bionic.", "https://via.placeholder.com/200x150/cccccc/000000?text=iPhone+15", 1099.00));
        featuredItems.add(new Product(202, "Samsung Galaxy S24 Ultra", "AI-powered features, stunning display.", "https://via.placeholder.com/200x150/cccccc/000000?text=Galaxy+S24", 1199.99));
        featuredItems.add(new Product(204, "OnePlus 12", "Flagship killer performance.", "https://via.placeholder.com/200x150/cccccc/000000?text=OnePlus+12", 799.00));
        return featuredItems;
    }
    // --- End Placeholder Methods ---


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // --- Security Check: Ensure user is logged in AS CUSTOMER ---
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
            session = request.getSession();
            session.setAttribute("errorMessage", errorRedirectMsg);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // --- End Security Check ---

        try {
            // --- Fetch Data for the Home/Dashboard View ---
            List<Product> saleItems = getMockSaleItems();
            List<Product> featuredItems = getMockFeaturedItems();

            // --- Set Data as Request Attributes for userdash.jsp ---
            request.setAttribute("saleItems", saleItems);
            request.setAttribute("featuredItems", featuredItems);
            // No longer setting full product list
            // request.setAttribute("availableProducts", ...);
            // No longer setting profile object here, profile page would have its own servlet/logic
            // request.setAttribute("customerProfile", currentUser);

            System.out.println("UserDashboardServlet: Home data prepared for user: " + currentUser.getUsername());

        } catch (Exception e) {
            System.err.println("UserDashboardServlet: Error fetching dashboard data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("dashboardErrorMessage", "Could not load dashboard content.");
        }

        // --- Forward to the User Dashboard JSP ---
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/userdash.jsp");
        dispatcher.forward(request, response);
    }

    // doPost can remain the same, likely just calling doGet
     @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         doGet(request, response);
     }
    @Override
    public String getServletInfo() { return "Servlet prepares data for the Customer Dashboard/Home page."; }
}

// --- Ensure ProductForSale model class exists (ideally in model package) ---
// class ProductForSale { ... as defined before ... }