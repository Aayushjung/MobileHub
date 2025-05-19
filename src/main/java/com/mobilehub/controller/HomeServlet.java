package com.mobilehub.controller; 
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


class Product {
    private int id;
    private String name;
    private double price;
    private String imageUrl;
    private String badge;

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
	//  Getters needed for JSP 
    public int getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getImageUrl() { return imageUrl; }
    public String getBadge() { return badge; }
}

class Brand {
    private String id; 
    private String name;
    private String logoUrl;

    public Brand(String id, String name, String logoUrl) {
        this.id = id;
        this.name = name;
        this.logoUrl = logoUrl;
    }
    //  Getters needed for JSP 
    public String getId() { return id; }
    public String getName() { return name; }
    public String getLogoUrl() { return logoUrl; }
}



@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/index"}) // Map requests to /home or /index
public class HomeServlet extends HttpServlet {

   
    private List<Product> getMockNewArrivals() {
        List<Product> products = new ArrayList<>();
        products.add(new Product(123, "Samsung Galaxy Ultra Future", 1199.99, "https://via.placeholder.com/180x180/ffffff/000000?text=Phone+1", "New"));
        products.add(new Product(124, "iPhone 16 Pro Max Concept", 1299.00, "https://via.placeholder.com/180x180/ffffff/000000?text=Phone+2", null)); // No badge
        products.add(new Product(125, "Google Pixel 9 AI Edition - Long Name Here To Test Wrapping", 999.00, "https://via.placeholder.com/180x180/ffffff/000000?text=Phone+3", "Eco"));
        products.add(new Product(126, "OneMore Brand X1 Speed", 750.50, "https://via.placeholder.com/180x180/ffffff/000000?text=Phone+4", null));
        // Add more mock products if needed
        return products;
    }

    private List<Brand> getMockTopBrands() {
        List<Brand> brands = new ArrayList<>();
        brands.add(new Brand("apple", "Apple", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Apple"));
        brands.add(new Brand("samsung", "Samsung", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Samsung"));
        brands.add(new Brand("google", "Google", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Google"));
        brands.add(new Brand("oneplus", "OnePlus", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=OnePlus"));
        brands.add(new Brand("xiaomi", "Xiaomi", "https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Xiaomi"));
        return brands;
    }

    private int getMockCartItemCount(HttpSession session) {
       
        String username = (String) session.getAttribute("username");
        if (username != null) {
           
            return 3; 
        }
        return 0; 
    }
    


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); 

       
        if (session == null || session.getAttribute("username") == null || !"customer".equalsIgnoreCase((String) session.getAttribute("role"))) {
            // User not logged in as customer, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login.jsp"); // Or your login servlet/page
            return; // Stop further processing
        }

        
        try {
            List<Product> newArrivals = getMockNewArrivals();
            List<Brand> topBrands = getMockTopBrands();
            int cartItemCount = getMockCartItemCount(session);
            
            request.setAttribute("newArrivals", newArrivals);
            request.setAttribute("topBrands", topBrands);
            request.setAttribute("cartItemCount", cartItemCount); // For the cart badge
          
        } catch (Exception e) {
            
            System.err.println("Error fetching data for home page: " + e.getMessage());
            
            request.setAttribute("errorMessage", "Could not load all page elements. Please try again later.");
          
        }


        //Forward to the JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/home.jsp");
        dispatcher.forward(request, response);
    }

  
     
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
         doGet(request, response); 
    }

    @Override
    public String getServletInfo() {
        return "Servlet that prepares data for and displays the customer home page (home.jsp)";
    }
}