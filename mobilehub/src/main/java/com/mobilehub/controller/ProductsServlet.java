package com.mobilehub.controller; // Ensure this matches your package structure

// Import necessary classes (Product model, List, Servlet APIs)
import com.mobilehub.model.Product; // Assuming ProductForSale is in the model package now
// Import ProductDAO/Service if you have one

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Needed for basic login check

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductsServlet", urlPatterns = {"/products"}) // URL for the products page
public class ProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- Placeholder Service/DAO Method ---
    // Replace with actual call to ProductDAO/ProductService
    private List<Product> getAvailableMobiles() {
        // This method should ideally live in a Service or DAO class
        System.out.println("ProductsServlet: Fetching mock available mobiles...");
        List<Product> products = new ArrayList<>();
        // Same mock data as before for consistency
        products.add(new Product(201, "iPhone 15 Pro", "Experience the future with the A17 Bionic chip and advanced camera.", "https://via.placeholder.com/200x150/cccccc/000000?text=iPhone+15", 1099.00));
        products.add(new Product(202, "Samsung Galaxy S24 Ultra", "AI-powered features, stunning display, and powerful performance.", "https://via.placeholder.com/200x150/cccccc/000000?text=Galaxy+S24", 1199.99));
        products.add(new Product(203, "Google Pixel 8 Pro", "Unmatched camera intelligence and Google AI integration.", "https://via.placeholder.com/200x150/cccccc/000000?text=Pixel+8", 999.00));
        products.add(new Product(204, "OnePlus 12", "Flagship killer performance with Hasselblad camera.", "https://via.placeholder.com/200x150/cccccc/000000?text=OnePlus+12", 799.00));
        products.add(new Product(205, "Xiaomi 14", "Compact powerhouse with Leica optics.", "https://via.placeholder.com/200x150/cccccc/000000?text=Xiaomi+14", 749.00));
        products.add(new Product(206, "Nothing Phone (2)", "Unique Glyph interface and balanced performance.", "https://via.placeholder.com/200x150/cccccc/000000?text=Nothing(2)", 699.00));
        return products;
    }
    // --- End Placeholder Method ---


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Optional: Basic Login Check (Allow any logged-in user to view products)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in, redirect to login
            session = request.getSession(); // Create session to store message
            session.setAttribute("errorMessage", "Please login to view products.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // --- Fetch Product Data ---
        try {
            List<Product> productList = getAvailableMobiles();
            request.setAttribute("productList", productList); // Use a distinct attribute name
            System.out.println("ProductsServlet: Forwarding product list to products.jsp");

        } catch (Exception e) {
            System.err.println("ProductsServlet: Error fetching product data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("pageErrorMessage", "Could not load products at this time.");
            // Consider forwarding to an error page or showing the products page with the error
        }

        // --- Forward to the Products JSP ---
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/products.jsp"); // Path to the new JSP
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet that fetches and displays the main product listing page.";
    }
}

// --- Ensure ProductForSale class/model exists ---
// (Included here from previous examples, ideally move to model package)
