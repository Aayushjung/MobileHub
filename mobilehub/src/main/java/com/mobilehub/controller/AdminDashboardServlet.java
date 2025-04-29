package com.mobilehub.controller; // Ensure this matches your package structure

// Import necessary libraries
import com.mobilehub.dao.UserDAO; // Assuming you might need this for counts
// Import other DAOs if needed (ProductDAO, OrderDAO)

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.NumberFormat; // For formatting currency
import java.util.Locale;       // For currency locale

// --- Simple Bean to hold dashboard stats ---
// (Could also be separate attributes, but this groups them)
class DashboardStats {
    private double totalSales;
    private long totalOrders;
    private long newCustomers;
    private long activeProducts;

    // Constructor
    public DashboardStats(double totalSales, long totalOrders, long newCustomers, long activeProducts) {
        this.totalSales = totalSales;
        this.totalOrders = totalOrders;
        this.newCustomers = newCustomers;
        this.activeProducts = activeProducts;
    }

    // Getters (Needed for EL access in JSP: ${dashboardStats.totalSales})
    public double getTotalSales() { return totalSales; }
    public long getTotalOrders() { return totalOrders; }
    public long getNewCustomers() { return newCustomers; }
    public long getActiveProducts() { return activeProducts; }
}
// --- End Simple Bean ---


@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- Placeholder Service Methods (Simulate fetching data) ---
    // Replace these with calls to your actual Service/DAO layers.
    private DashboardStats getMockDashboardStats() {
        // In a real app, fetch these from DAOs (UserDAO, OrderDAO, ProductDAO)
        System.out.println("AdminDashboardServlet: Fetching mock dashboard stats...");
        // Values similar to the reference image
        double sales = 189245.75;
        long orders = 8294;
        long customers = 3427;
        long products = 529;
        return new DashboardStats(sales, orders, customers, products);
    }

    private Object getMockChartData(String chartType) {
        // Placeholder for chart data. Real implementation is complex.
        // You'd fetch aggregated data and likely format it as JSON for a JS charting library.
        System.out.println("AdminDashboardServlet: Preparing mock data placeholder for chart: " + chartType);
        if ("monthlySales".equals(chartType)) {
            // Return simple placeholder text or a basic structure
            return "Placeholder: Data for 7 months sales bar chart";
        } else if ("weeklyVisitors".equals(chartType)) {
            return "Placeholder: Data for weekly visitors area chart";
        }
        return null;
    }
    // --- End Placeholder Service Methods ---

    @Override
    public void init() {
        // Initialize DAOs here if needed
        System.out.println("AdminDashboardServlet Initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Get existing session

        // --- Security Check: Ensure user is logged in AND is an admin ---
        String errorRedirectMsg = null;
        if (session == null) {
             errorRedirectMsg = "No active session. Please login.";
        } else {
            Object user = session.getAttribute("user");
            String role = (String) session.getAttribute("role");
            if (user == null) {
                 errorRedirectMsg = "User not logged in. Please login.";
            } else if (!"admin".equalsIgnoreCase(role)) {
                 errorRedirectMsg = "Access denied. Admin privileges required.";
            }
        }

        if (errorRedirectMsg != null) {
            System.out.println("AdminDashboardServlet: Security check failed - " + errorRedirectMsg);
            session = request.getSession(); // Ensure session exists to set message
            session.setAttribute("errorMessage", errorRedirectMsg);
            response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login servlet
            return;
        }
        // --- End Security Check ---


        // --- Fetch Data for the Admin Dashboard ---
        try {
            // Replace mock calls with actual service/DAO calls
            DashboardStats stats = getMockDashboardStats();
            Object monthlySalesData = getMockChartData("monthlySales");
            Object weeklyVisitorData = getMockChartData("weeklyVisitors");

            // --- Set Data as Request Attributes for admindash.jsp ---
            request.setAttribute("dashboardStats", stats);
            request.setAttribute("monthlySalesData", monthlySalesData); // Placeholder for now
            request.setAttribute("weeklyVisitorData", weeklyVisitorData); // Placeholder for now

            System.out.println("AdminDashboardServlet: Data prepared for user: " + session.getAttribute("username"));

        } catch (Exception e) {
            System.err.println("AdminDashboardServlet: Error fetching dashboard data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("dashboardErrorMessage", "Could not load dashboard statistics.");
        }

        // --- Forward to the Admin Dashboard JSP ---
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/admindash.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Usually no POST actions directly on dashboard display
         doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet prepares data for and displays the Admin Dashboard page (admindash.jsp) based on reference image.";
    }
}