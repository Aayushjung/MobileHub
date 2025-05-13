package com.mobilehub.controller; // Replace with your actual package name

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

// --- Placeholder Data Structures (Simulate Models/Entities) ---
// In a real app, these would be proper classes in a 'model' or 'entity' package
class Product {
    private int id;
    private String name;
    private double price;
    private String imageUrl;
    private String badge; // e.g., "New", "Sale", "Eco"

    public Product(int id, String name, double price, String imageUrl, String badge) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.imageUrl = imageUrl;
        this.badge = badge;
    }
    public Product(int id2, String name2, String string, String imageUrl2, double d) {
		// TODO Auto-generated constructor stub
	}
	// --- Getters needed for JSP EL access ---
    public int getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getImageUrl() { return imageUrl; }
    public String getBadge() { return badge; }
}

class Brand {
    private String id; // e.g., "apple", "samsung"
    private String name;
    private String logoUrl;

    public Brand(String id, String name, String logoUrl) {
        this.id = id;
        this.name = name;
        this.logoUrl = logoUrl;
    }
    // --- Getters needed for JSP EL access ---
    public String getId() { return id; }
    public String getName() { return name; }
    public String getLogoUrl() { return logoUrl; }
}
// --- End Placeholder Data Structures ---


@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/index"}) // Map requests to /home or /index
public class HomeServlet extends HttpServlet {

    // --- Placeholder Service Methods (Simulate Service Layer) ---
    // In a real app, these would be in separate Service classes (e.g., ProductService, BrandService, CartService)
    // and would interact with a database (DAO layer).

    private List<Product> getMockNewArrivals() {
        List<Product> products = new ArrayList<>();
        // Match placeholders in JSP for consistency during development
        products.add(new Product(123, "Samsung Galaxy Ultra Future", 1199.99, "https://via.placeholder.com/180x180/ffffff/000000?text=Phone+1", "New"));
        products.add(new Product(124, "iPhone 16 Pro Max Concept", 1299.00, "https://via.placeholder.com/180x180/ffffff/000000?text=Phone+2", null)); // No badge
        products.add(new Product(125, "Google Pixel 9 AI Edition - Long Name Here To Test Wrapping", 999.00, "https://via.placeholder.com/180x180/ffffff/000000?text=Phone+3", "Eco"));
        products.add(new Product(126, "OneMore Brand X1 Speed", 750.50, "https://via.placeholder.com/180x180/ffffff/000000?text=Phone+4", null));
        // Add more mock products if needed
        return products;
    }

    private List<Brand> getMockTopBrands() {
        List<Brand> brands = new ArrayList<>();
        // Match placeholders in JSP
        brands.add(new Brand("apple", "Apple", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Apple"));
        brands.add(new Brand("samsung", "Samsung", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Samsung"));
        brands.add(new Brand("google", "Google", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Google"));
        brands.add(new Brand("oneplus", "OnePlus", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=OnePlus"));
        brands.add(new Brand("xiaomi", "Xiaomi", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Xiaomi"));
        return brands;
    }

    private int getMockCartItemCount(HttpSession session) {
        // In a real app, you'd query a CartService using the userId (from session?)
        // For simulation, return a static number or check a session attribute if cart is stored there.
        String username = (String) session.getAttribute("username");
        if (username != null) {
            // Simulate different counts for different users maybe, or just a fixed one
            return 3; // Matching the placeholder in JSP
        }
        return 0; // No items if not logged in (though they shouldn't reach here ideally)
    }
    // --- End Placeholder Service Methods ---


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Don't create session if it doesn't exist

        // --- Authentication/Authorization Check (Ideally done in a Filter) ---
        if (session == null || session.getAttribute("username") == null || !"customer".equalsIgnoreCase((String) session.getAttribute("role"))) {
            // User not logged in as customer, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login.jsp"); // Or your login servlet/page
            return; // Stop further processing
        }

        // --- Fetch Data (using mock methods for now) ---
        try {
            List<Product> newArrivals = getMockNewArrivals();
            List<Brand> topBrands = getMockTopBrands();
            int cartItemCount = getMockCartItemCount(session);
            // Fetch other data like featured products, user-specific recommendations etc. if needed

            // --- Set Data as Request Attributes for JSP ---
            request.setAttribute("newArrivals", newArrivals);
            request.setAttribute("topBrands", topBrands);
            request.setAttribute("cartItemCount", cartItemCount); // For the cart badge
            // Set other attributes: request.setAttribute("featuredProducts", featuredProducts);

        } catch (Exception e) {
            // Log the error
            System.err.println("Error fetching data for home page: " + e.getMessage());
            // Optionally set an error message attribute for the JSP
            request.setAttribute("errorMessage", "Could not load all page elements. Please try again later.");
            // In a production app, you might have a more sophisticated error handling mechanism
            // or forward to a dedicated error page. For now, we'll proceed but some data might be missing.
        }


        // --- Forward to the JSP page ---
        RequestDispatcher dispatcher = request.getRequestDispatcher("/home.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Typically, the home page doesn't handle POST requests directly unless there's a form
     * (like a newsletter signup) directly on it. If so, implement logic here.
     * Otherwise, it's good practice to redirect GET after POST or simply call doGet if appropriate.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Example: If home.jsp had a form submitting via POST
        // processRequest(request, response);

        // For now, just delegate to doGet or send error/redirect
         doGet(request, response); // Or perhaps redirect to home after a POST action elsewhere
         // response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported for this URL.");
    }

    @Override
    public String getServletInfo() {
        return "Servlet that prepares data for and displays the customer home page (home.jsp)";
    }
}