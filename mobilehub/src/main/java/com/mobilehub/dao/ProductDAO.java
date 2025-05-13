package com.mobilehub.dao;

import com.mobilehub.config.DatabaseConfig;
import com.mobilehub.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (name, description, price, category, stock_quantity, image_url, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setString(4, product.getCategory());
            pstmt.setInt(5, product.getStockQuantity());
            pstmt.setString(6, product.getImageUrl());
            Timestamp now = new Timestamp(System.currentTimeMillis());
            pstmt.setTimestamp(7, now); // createdAt
            pstmt.setTimestamp(8, now); // updatedAt

            success = pstmt.executeUpdate() > 0;
            System.out.println("ProductDAO.addProduct: Success = " + success + " for product: " + product.getName());
        } catch (SQLException e) {
            System.err.println("ProductDAO.addProduct: Error adding product - " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return success;
    }

    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE id = ?";
        Product product = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                product = new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("category"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image_url"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at")
                );
            }
        } catch (SQLException e) {
            System.err.println("ProductDAO.getProductById: Error fetching product - " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseConfig.closeQuietly(rs);
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return product;
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY name ASC";
        Connection conn = null;
        Statement stmt = null; // Can use Statement for simple query
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                products.add(new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("category"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image_url"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at")
                ));
            }
            System.out.println("ProductDAO.getAllProducts: Fetched " + products.size() + " products.");
        } catch (SQLException e) {
            System.err.println("ProductDAO.getAllProducts: Error fetching products - " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseConfig.closeQuietly(rs);
            DatabaseConfig.closeQuietly(stmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return products;
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, category = ?, stock_quantity = ?, image_url = ?, updated_at = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setString(4, product.getCategory());
            pstmt.setInt(5, product.getStockQuantity());
            pstmt.setString(6, product.getImageUrl());
            pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis())); // updatedAt
            pstmt.setInt(8, product.getId());

            success = pstmt.executeUpdate() > 0;
            System.out.println("ProductDAO.updateProduct: Success = " + success + " for product ID: " + product.getId());
        } catch (SQLException e) {
            System.err.println("ProductDAO.updateProduct: Error updating product - " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return success;
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            success = pstmt.executeUpdate() > 0;
            System.out.println("ProductDAO.deleteProduct: Success = " + success + " for product ID: " + productId);
        } catch (SQLException e) {
            System.err.println("ProductDAO.deleteProduct: Error deleting product - " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return success;
    }
}