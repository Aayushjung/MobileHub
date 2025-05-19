package com.mobilehub.controller;

import com.mobilehub.model.Product; //  Product model
import com.mobilehub.dao.ProductDAO;   //  ProductDAO

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

@WebServlet(name = "ProductsServlet", urlPatterns = {"/products"})
public class ProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        System.out.println("ProductsServlet Initialized with ProductDAO.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ProductsServlet: doGet called for /products");
        HttpSession session = request.getSession(false);

       
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("ProductsServlet: User not logged in. Redirecting to login.");
            session = request.getSession(); 
            session.setAttribute("errorMessage", "Please login to view our products.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Product> productList = new ArrayList<>(); // Initialize to prevent null pointer in JSP
        try {
            System.out.println("ProductsServlet: Attempting to fetch all products from DAO...");
            productList = productDAO.getAllProducts(); // Fetch all products

            if (productList != null) {
                System.out.println("ProductsServlet: Fetched " + productList.size() + " products from DAO.");
            } else {
                System.err.println("ProductsServlet: ProductDAO.getAllProducts() returned null! Initializing empty list.");
                productList = new ArrayList<>(); // Defensive initialization
            }
            request.setAttribute("productList", productList);

            if (productList.isEmpty()) {
                System.out.println("ProductsServlet: No products found by DAO. Setting informational message.");
                request.setAttribute("pageInfoMessage", "No products are currently available. Please check back soon!");
            }

        } catch (Exception e) {
            System.err.println("ProductsServlet: CRITICAL ERROR fetching product data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("pageErrorMessage", "Sorry, we encountered an error while trying to load products. Please try again later.");
            request.setAttribute("productList", new ArrayList<Product>()); // Send empty list on error
        }

        // Forward to the Products JSP page
        System.out.println("ProductsServlet: Forwarding to /WEB-INF/pages/products.jsp");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/products.jsp");
        dispatcher.forward(request, response);
    }

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ProductsServlet: doPost called, delegating to doGet (or implement POST specific logic).");
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet that fetches and displays the main product listing (shop) page.";
    }
}