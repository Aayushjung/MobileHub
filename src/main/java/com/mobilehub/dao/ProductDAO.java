package com.mobilehub.dao;

import com.mobilehub.config.DatabaseConfig;
import com.mobilehub.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

   
    private Product mapRowToProduct(ResultSet rs) throws SQLException {
        
        return new Product(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getDouble("price"),
            rs.getString("category"),
            rs.getInt("stockQuantity"), 
            rs.getString("imageUrl"), 
            rs.getTimestamp("createdAt"), 
            rs.getTimestamp("updatedAt")  
        );
    }

   
    public boolean addProduct(Product product) {
        
        String sql = "INSERT INTO products (name, description, price, category, stockQuantity, imageUrl, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        System.out.println("ProductDAO.addProduct: Attempting to add product: " + product.getName());
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setString(4, product.getCategory());
            pstmt.setInt(5, product.getStockQuantity());
            pstmt.setString(6, product.getImageUrl()); 

            Timestamp now = new Timestamp(System.currentTimeMillis());
           
            pstmt.setTimestamp(7, product.getCreatedAt() != null ? product.getCreatedAt() : now);
            pstmt.setTimestamp(8, now); // updatedAt is always set to now on insert/update

            int rowsAffected = pstmt.executeUpdate();
            boolean success = (rowsAffected > 0);

            if (success) System.out.println("ProductDAO.addProduct: Product '" + product.getName() + "' added successfully.");
            else System.err.println("ProductDAO.addProduct: Failed to add product '" + product.getName() + "' (0 rows affected).");
            return success;

        } catch (SQLException e) {
            System.err.println("ProductDAO.addProduct: SQL Error adding product '" + product.getName() + "' - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

   
    public Product getProductById(int productId) {
        String sql = "SELECT id, name, description, price, category, stockQuantity, imageUrl, createdAt, updatedAt FROM products WHERE id = ?";
        System.out.println("ProductDAO.getProductById: Attempting to fetch product with ID: " + productId);
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Product product = mapRowToProduct(rs);
                    System.out.println("ProductDAO.getProductById: Found product: " + product.getName());
                    return product;
                } else {
                    System.out.println("ProductDAO.getProductById: No product found with ID: " + productId);
                }
            }
        } catch (SQLException e) {
            System.err.println("ProductDAO.getProductById: SQL Error fetching product ID " + productId + " - " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, name, description, price, category, stockQuantity, imageUrl, createdAt, updatedAt FROM products ORDER BY name ASC";
        System.out.println("ProductDAO.getAllProducts: Attempting to fetch all products.");
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                products.add(mapRowToProduct(rs));
            }
            System.out.println("ProductDAO.getAllProducts: Fetched " + products.size() + " products.");
        } catch (SQLException e) {
            System.err.println("ProductDAO.getAllProducts: SQL Error fetching all products - " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    
    public List<Product> getProductsByCategory(String categoryName) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, name, description, price, category, stockQuantity, imageUrl, createdAt, updatedAt FROM products WHERE category = ? ORDER BY name ASC";
        System.out.println("ProductDAO.getProductsByCategory: Fetching products for category: '" + categoryName + "'");
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, categoryName);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapRowToProduct(rs));
                }
            }
            System.out.println("ProductDAO.getProductsByCategory: Found " + products.size() + " products for category '" + categoryName + "'.");
        } catch (SQLException e) {
            System.err.println("ProductDAO.getProductsByCategory: SQL Error for category '" + categoryName + "' - " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

  
    public boolean updateProduct(Product product) {
        // SQL uses column names from your schema: stockQuantity, imageUrl, updatedAt
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, category = ?, stockQuantity = ?, imageUrl = ?, updatedAt = ? WHERE id = ?";
        boolean success = false;
        System.out.println("ProductDAO.updateProduct: Attempting to update product ID: " + product.getId());
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setString(4, product.getCategory());
            pstmt.setInt(5, product.getStockQuantity());
            pstmt.setString(6, product.getImageUrl());
            pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis())); // Set updatedAt
            pstmt.setInt(8, product.getId());

            int rowsAffected = pstmt.executeUpdate();
            success = (rowsAffected > 0);
            if (success) System.out.println("ProductDAO.updateProduct: Product ID '" + product.getId() + "' updated successfully.");
            else System.err.println("ProductDAO.updateProduct: Failed to update product ID '" + product.getId() + "' (0 rows affected).");
        } catch (SQLException e) {
            System.err.println("ProductDAO.updateProduct: SQL Error updating product ID " + product.getId() + " - " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

   
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE id = ?";
        boolean success = false;
        System.out.println("ProductDAO.deleteProduct: Attempting to delete product ID: " + productId);
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            int rowsAffected = pstmt.executeUpdate();
            success = (rowsAffected > 0);
            if (success) System.out.println("ProductDAO.deleteProduct: Product ID '" + productId + "' deleted successfully.");
            else System.err.println("ProductDAO.deleteProduct: Failed to delete product ID '" + productId + "' (0 rows affected or product not found).");
        } catch (SQLException e) {
            System.err.println("ProductDAO.deleteProduct: SQL Error deleting product ID " + productId + " - " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

   
    public long getTotalProductCount() {
        String sql = "SELECT COUNT(*) AS product_count FROM products";
        long count = 0;
        System.out.println("ProductDAO.getTotalProductCount: Attempting to get total product count...");
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                count = rs.getLong("product_count");
            }
            System.out.println("ProductDAO.getTotalProductCount: Total product count from DB: " + count);
        } catch (SQLException e) {
            System.err.println("ProductDAO.getTotalProductCount: SQL Error - " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
}