package com.mobilehub.controller;

import com.mobilehub.model.Product;
import com.mobilehub.dao.ProductDAO; 

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp; 
import java.util.List;
import java.util.ArrayList;
@WebServlet(name = "ManageProductsServlet", urlPatterns = {"/admin/manage-products"})
public class ManageProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        System.out.println("ManageProductsServlet Initialized with ProductDAO.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageProductsServlet: doGet called. Action: " + request.getParameter("action"));
        HttpSession session = request.getSession(false);

        // --- Security Check: Admin Only ---
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("ManageProductsServlet: Admin access denied in doGet. Redirecting to login.");
            session = request.getSession(); // Ensure session exists to set message
            session.setAttribute("errorMessage", "Admin access required. Please login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; 
        }

        try {
            switch (action) {
                case "new":
                    showNewProductForm(request, response);
                    break;
                case "edit":
                    showEditProductForm(request, response);
                    break;
               
                case "list":
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("ManageProductsServlet (doGet): Error processing action '" + action + "' - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
           
            try {
                listProducts(request, response);
            } catch (Exception ex) {
                System.err.println("ManageProductsServlet (doGet): Further error trying to list products: " + ex.getMessage());
                // Final fallback
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "A critical error occurred. Please check server logs.");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageProductsServlet: doPost called. Action: " + request.getParameter("action"));
        HttpSession session = request.getSession(false); // Use existing session

        // --- Security Check: Admin Only ---
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("ManageProductsServlet: Admin access denied for POST request.");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
             System.err.println("ManageProductsServlet (doPost): Action parameter is null. Redirecting to list.");
             response.sendRedirect(request.getContextPath() + "/admin/manage-products");
             return;
        }

        try {
            switch (action) {
                case "insert":
                    insertProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    System.err.println("ManageProductsServlet (doPost): Unknown action received: " + action);
                    session.setAttribute("manageProductErrorMessage", "Unknown action: " + action);
                    response.sendRedirect(request.getContextPath() + "/admin/manage-products");
                    break;
            }
        } catch (Exception e) { // Catch any unexpected exceptions from action methods
            System.err.println("ManageProductsServlet (doPost): CRITICAL Error processing action '" + action + "' - " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("formErrorMessage", "An unexpected server error occurred: " + e.getMessage());
            
            // Try to redirect back to the appropriate form 
            String idParam = request.getParameter("id");
            String redirectPath = "/admin/manage-products"; // Default fallback
            if ("insert".equals(action)) {
                redirectPath += "?action=new";
            } else if ("update".equals(action) && idParam != null && !idParam.isEmpty()) {
                redirectPath += "?action=edit&id=" + idParam;
            }
            response.sendRedirect(request.getContextPath() + redirectPath);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageProductsServlet.listProducts: Fetching product list.");
        List<Product> productList = productDAO.getAllProducts();
        request.setAttribute("productList", productList != null ? productList : new ArrayList<Product>());

        HttpSession session = request.getSession(); // Get session to retrieve/clear messages
        String successMessage = (String) session.getAttribute("manageProductSuccessMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("manageProductSuccessMessage");
        }
        String errorMessage = (String) session.getAttribute("manageProductErrorMessage");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("manageProductErrorMessage");
        }
        
        System.out.println("ManageProductsServlet.listProducts: Forwarding to manage_products.jsp");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/manage_products.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageProductsServlet.showNewProductForm: Preparing new product form.");
        request.setAttribute("product", new Product()); // For form binding, provides empty values
        request.setAttribute("formAction", "insert");
        request.setAttribute("formTitle", "Add New Product");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/add_product_form.jsp"); 
        dispatcher.forward(request, response);
    }

    private void showEditProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ManageProductsServlet.showEditProductForm: Preparing edit product form.");
        String idParam = request.getParameter("id");
        try {
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new NumberFormatException("Product ID is missing for edit.");
            }
            int id = Integer.parseInt(idParam);
            Product existingProduct = productDAO.getProductById(id);
            if (existingProduct != null) {
                request.setAttribute("product", existingProduct);
                request.setAttribute("formAction", "update");
                request.setAttribute("formTitle", "Edit Product (ID: " + id + ")");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/edit_product_form.jsp");
                dispatcher.forward(request, response);
            } else {
                System.err.println("ManageProductsServlet.showEditProductForm: Product not found for ID: " + id);
                request.getSession().setAttribute("manageProductErrorMessage", "Product not found for editing (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/admin/manage-products");
            }
        } catch (NumberFormatException e) {
            System.err.println("ManageProductsServlet.showEditProductForm: Invalid product ID format: " + idParam);
            request.getSession().setAttribute("manageProductErrorMessage", "Invalid product ID for editing: '" + idParam + "'.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-products");
        }
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException { // Added ServletException for forwarding
        HttpSession session = request.getSession();
        System.out.println("ManageProductsServlet.insertProduct: Attempting to insert new product.");

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String imageUrl = request.getParameter("imageUrl");

        // --- Server-side Validation ---
        if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() ||
            stockQuantityStr == null || stockQuantityStr.trim().isEmpty()) {
            repopulateAndForwardToForm("insert", request, response, null, "Name, Price, and Stock Quantity are required.");
            return;
        }

        double price;
        int stockQuantity;
        try {
            price = Double.parseDouble(priceStr);
            stockQuantity = Integer.parseInt(stockQuantityStr);
            if (price <= 0) {
                repopulateAndForwardToForm("insert", request, response, null, "Price must be a positive value.");
                return;
            }
            if (stockQuantity < 0) {
                repopulateAndForwardToForm("insert", request, response, null, "Stock quantity cannot be negative.");
                return;
            }
        } catch (NumberFormatException e) {
            repopulateAndForwardToForm("insert", request, response, null, "Invalid number format for Price or Stock Quantity.");
            return;
        }

        Product newProduct = new Product(
                name.trim(),
                description,
                price,
                category,
                stockQuantity,
                imageUrl != null ? imageUrl.trim() : null // Handle null imageUrl 
        );
        // DAO will set createdAt and updatedAt

        if (productDAO.addProduct(newProduct)) {
            session.setAttribute("manageProductSuccessMessage", "Product '" + newProduct.getName() + "' added successfully!");
            response.sendRedirect(request.getContextPath() + "/admin/manage-products");
        } else {
            repopulateAndForwardToForm("insert", request, response, null, "Failed to add product to the database. Please check server logs.");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException { // Added ServletException
        HttpSession session = request.getSession();
        System.out.println("ManageProductsServlet.updateProduct: Attempting to update product.");

        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String imageUrl = request.getParameter("imageUrl");

        if (idParam == null || idParam.trim().isEmpty() ||
            name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() ||
            stockQuantityStr == null || stockQuantityStr.trim().isEmpty()) {
            repopulateAndForwardToForm("update", request, response, idParam, "ID, Name, Price, and Stock Quantity are required for update.");
            return;
        }

        int id;
        double price;
        int stockQuantity;
        try {
            id = Integer.parseInt(idParam);
            price = Double.parseDouble(priceStr);
            stockQuantity = Integer.parseInt(stockQuantityStr);
            if (price <= 0) {
                 repopulateAndForwardToForm("update", request, response, idParam, "Price must be a positive value.");
                return;
            }
            if (stockQuantity < 0) {
                 repopulateAndForwardToForm("update", request, response, idParam, "Stock quantity cannot be negative.");
                return;
            }
        } catch (NumberFormatException e) {
            repopulateAndForwardToForm("update", request, response, idParam, "Invalid number format for ID, Price, or Stock Quantity.");
            return;
        }

        Product product = productDAO.getProductById(id); // Fetch existing product
        if (product == null) {
            session.setAttribute("manageProductErrorMessage", "Product with ID " + id + " not found. Cannot update.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-products");
            return;
        }

        // Update fields
        product.setName(name.trim());
        product.setDescription(description);
        product.setPrice(price);
        product.setCategory(category);
        product.setStockQuantity(stockQuantity);
        product.setImageUrl(imageUrl != null ? imageUrl.trim() : null);
        

        if (productDAO.updateProduct(product)) {
            session.setAttribute("manageProductSuccessMessage", "Product '" + product.getName() + "' (ID: " + id + ") updated successfully!");
            response.sendRedirect(request.getContextPath() + "/admin/manage-products");
        } else {
            repopulateAndForwardToForm("update", request, response, idParam, "Failed to update product in the database. Please check server logs.");
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        System.out.println("ManageProductsServlet.deleteProduct: Attempting to delete product.");
        String idParam = request.getParameter("id"); // Changed from "userId"
        try {
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new NumberFormatException("Product ID for deletion is missing.");
            }
            int id = Integer.parseInt(idParam);
            if (productDAO.deleteProduct(id)) {
                session.setAttribute("manageProductSuccessMessage", "Product (ID: " + id + ") deleted successfully!");
            } else {
                session.setAttribute("manageProductErrorMessage", "Failed to delete product (ID: " + id + "). It might not exist or a database error occurred.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("manageProductErrorMessage", "Invalid product ID format for deletion: '" + idParam + "'.");
        } catch (Exception e) {
            session.setAttribute("manageProductErrorMessage", "Error deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-products");
    }

   
    private void repopulateAndForwardToForm(String targetAction, HttpServletRequest request, HttpServletResponse response, String idParam, String errorMessage)
        throws ServletException, IOException {
        System.err.println("ManageProductsServlet: Validation/DB Error in " + targetAction + " - " + errorMessage);
        request.setAttribute("formErrorMessageLocal", errorMessage); // For JSP display

        Product productToRepopulate = new Product();
        if ("update".equals(targetAction) && idParam != null && !idParam.isEmpty()) {
            try {
                productToRepopulate.setId(Integer.parseInt(idParam)); 
                Product originalProduct = productDAO.getProductById(Integer.parseInt(idParam));
                if (originalProduct != null) {
                   
                    productToRepopulate = originalProduct;
                }
            } catch (NumberFormatException e) {  }
        }

       
        productToRepopulate.setName(request.getParameter("name") != null ? request.getParameter("name") : productToRepopulate.getName());
        productToRepopulate.setDescription(request.getParameter("description") != null ? request.getParameter("description") : productToRepopulate.getDescription());
        try { productToRepopulate.setPrice(request.getParameter("price") != null ? Double.parseDouble(request.getParameter("price")) : productToRepopulate.getPrice()); } catch (Exception e) { /* Use existing or default */ }
        productToRepopulate.setCategory(request.getParameter("category") != null ? request.getParameter("category") : productToRepopulate.getCategory());
        try { productToRepopulate.setStockQuantity(request.getParameter("stockQuantity") != null ? Integer.parseInt(request.getParameter("stockQuantity")) : productToRepopulate.getStockQuantity()); } catch (Exception e) { /* Use existing or default */ }
        productToRepopulate.setImageUrl(request.getParameter("imageUrl") != null ? request.getParameter("imageUrl") : productToRepopulate.getImageUrl());

        request.setAttribute("product", productToRepopulate);
        request.setAttribute("formAction", targetAction); // "insert" or "update"
        String formTitle = "insert".equals(targetAction) ? "Add New Product" : "Edit Product (ID: " + (idParam != null ? idParam : "Error") + ")";
        request.setAttribute("formTitle", formTitle);

        String targetJSP = "/WEB-INF/pages/admin/" + ("insert".equals(targetAction) ? "add_product_form.jsp" : "edit_product_form.jsp");
        System.out.println("ManageProductsServlet: Forwarding to " + targetJSP + " due to error.");
        RequestDispatcher dispatcher = request.getRequestDispatcher(targetJSP);
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for Admin to Manage Products (CRUD operations)";
    }
}