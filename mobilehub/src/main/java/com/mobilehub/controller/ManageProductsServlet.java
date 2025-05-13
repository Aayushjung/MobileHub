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
import java.util.List;

@WebServlet(name = "ManageProductsServlet", urlPatterns = {"/admin/manage-products"})
public class ManageProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // --- Security Check: Admin Only ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            session = request.getSession();
            session.setAttribute("errorMessage", "Admin access required.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list"; // Default action

        System.out.println("ManageProductsServlet (doGet): Action = " + action);

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete": // Deletion is typically a POST, but can handle confirmation redirect here
                    listProducts(request, response); // After delete, show list
                    break;
                default: // list
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("ManageProductsServlet (doGet): Error processing action " + action + " - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred.");
            listProducts(request, response); // Show list with error
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // --- Security Check: Admin Only ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
             System.err.println("ManageProductsServlet (doPost): Action parameter is null.");
             response.sendRedirect(request.getContextPath() + "/admin/manage-products"); // Redirect to list
             return;
        }
        System.out.println("ManageProductsServlet (doPost): Action = " + action);

        try {
            switch (action) {
                case "insert":
                    insertProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                case "delete": // Handle actual deletion here
                    deleteProduct(request, response);
                    break;
                default:
                    System.err.println("ManageProductsServlet (doPost): Unknown action: " + action);
                    response.sendRedirect(request.getContextPath() + "/admin/manage-products");
                    break;
            }
        } catch (Exception e) {
            System.err.println("ManageProductsServlet (doPost): Error processing action " + action + " - " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("formErrorMessage", "An unexpected error occurred: " + e.getMessage());
             // Redirect to list, GET will pick up message
            response.sendRedirect(request.getContextPath() + "/admin/manage-products?action=" + (request.getParameter("id") != null ? "edit&id=" + request.getParameter("id") : "new") );
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> productList = productDAO.getAllProducts();
        request.setAttribute("productList", productList);
        // Forward messages from POST
        HttpSession session = request.getSession();
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

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/manage_products.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("product", new Product()); // Empty product for the form
        request.setAttribute("formAction", "insert");
        request.setAttribute("formTitle", "Add New Product");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/product_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product existingProduct = productDAO.getProductById(id);
            if (existingProduct != null) {
                request.setAttribute("product", existingProduct);
                request.setAttribute("formAction", "update");
                request.setAttribute("formTitle", "Edit Product");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/product_form.jsp");
                dispatcher.forward(request, response);
            } else {
                request.getSession().setAttribute("manageProductErrorMessage", "Product not found for editing.");
                response.sendRedirect(request.getContextPath() + "/admin/manage-products");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("manageProductErrorMessage", "Invalid product ID for editing.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-products");
        }
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            String category = request.getParameter("category");
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String imageUrl = request.getParameter("imageUrl");

            // Basic Validation
            if (name == null || name.trim().isEmpty() || price <=0 || stockQuantity < 0) {
                 session.setAttribute("formErrorMessage", "Name, valid price, and non-negative stock are required.");
                 // To repopulate form, might need to set attributes and forward instead of redirect for "new"
                 response.sendRedirect(request.getContextPath() + "/admin/manage-products?action=new");
                 return;
            }

            Product newProduct = new Product(name, description, price, category, stockQuantity, imageUrl);
            if (productDAO.addProduct(newProduct)) {
                session.setAttribute("manageProductSuccessMessage", "Product added successfully!");
            } else {
                session.setAttribute("manageProductErrorMessage", "Failed to add product.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("formErrorMessage", "Invalid number format for price or stock quantity.");
        } catch (Exception e) {
            session.setAttribute("formErrorMessage", "Error adding product: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-products"); // Redirect to list view
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            String category = request.getParameter("category");
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String imageUrl = request.getParameter("imageUrl");

            // Basic Validation
            if (name == null || name.trim().isEmpty() || price <=0 || stockQuantity < 0) {
                 session.setAttribute("formErrorMessage", "Name, valid price, and non-negative stock are required.");
                 response.sendRedirect(request.getContextPath() + "/admin/manage-products?action=edit&id=" + id);
                 return;
            }

            Product product = new Product(); // Create new or fetch existing and update fields
            product.setId(id);
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setCategory(category);
            product.setStockQuantity(stockQuantity);
            product.setImageUrl(imageUrl);

            if (productDAO.updateProduct(product)) {
                session.setAttribute("manageProductSuccessMessage", "Product updated successfully!");
            } else {
                session.setAttribute("manageProductErrorMessage", "Failed to update product.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("formErrorMessage", "Invalid number format for price or stock quantity.");
        } catch (Exception e) {
            session.setAttribute("formErrorMessage", "Error updating product: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-products");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (productDAO.deleteProduct(id)) {
                session.setAttribute("manageProductSuccessMessage", "Product deleted successfully!");
            } else {
                session.setAttribute("manageProductErrorMessage", "Failed to delete product.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("manageProductErrorMessage", "Invalid product ID for deletion.");
        } catch (Exception e) {
            session.setAttribute("manageProductErrorMessage", "Error deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-products");
    }
    @Override
    public String getServletInfo() { return "Servlet for Admin to Manage Products (CRUD)"; }
}