package com.mobilehub.dao;

import com.mobilehub.config.DatabaseConfig;
import com.mobilehub.model.Order;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private Order mapRowToOrderWithCustomer(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getString("orderId"));
        order.setUserId(rs.getInt("userId"));
        order.setProductName(rs.getString("productName"));
        order.setTotalPrice(rs.getDouble("totalPrice"));
        order.setOrderDate(rs.getTimestamp("orderDate"));
        order.setStatus(rs.getString("status"));
        if (hasColumn(rs, "customerUsername")) {
            order.setCustomerUsername(rs.getString("customerUsername"));
        }
        return order;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData rsmd = rs.getMetaData();
        int columns = rsmd.getColumnCount();
        for (int x = 1; x <= columns; x++) {
            if (columnName.equalsIgnoreCase(rsmd.getColumnName(x))) {
                return true;
            }
        }
        return false;
    }

    public boolean createOrder(Order order) {
        String sql = "INSERT INTO orders (orderId, userId, productName, totalPrice, orderDate, status) VALUES (?, ?, ?, ?, ?, ?)";
        // Your DB table 'orders' has 'orderDate' as TIMESTAMP DEFAULT current_timestamp()
        // It does not have a separate `created_at` as per your latest SQL dump for `orders`.
        // We will set orderDate from the application.
        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, order.getOrderId());
            pstmt.setInt(2, order.getUserId());
            pstmt.setString(3, order.getProductName());
            pstmt.setDouble(4, order.getTotalPrice());
            pstmt.setTimestamp(5, order.getOrderDate() != null ? order.getOrderDate() : new Timestamp(System.currentTimeMillis()));
            pstmt.setString(6, order.getStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.orderId, o.userId, o.productName, o.totalPrice, o.orderDate, o.status, u.username AS customerUsername " +
                     "FROM orders o JOIN users u ON o.userId = u.id " +
                     "WHERE o.userId = ? ORDER BY o.orderDate DESC";
        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) orders.add(mapRowToOrderWithCustomer(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }

    public double getTotalSalesAmount() {
        String sql = "SELECT SUM(totalPrice) AS total_sales FROM orders";
        double totalSales = 0.0;
        try (Connection conn = DatabaseConfig.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) totalSales = rs.getDouble("total_sales");
        } catch (SQLException e) { e.printStackTrace(); }
        return totalSales;
    }

    public long getTotalOrderCount() {
        String sql = "SELECT COUNT(*) AS order_count FROM orders";
        long count = 0;
        try (Connection conn = DatabaseConfig.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) count = rs.getLong("order_count");
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    public List<Order> getRecentSales(int limit) {
        List<Order> recentSales = new ArrayList<>();
        String sql = "SELECT o.orderId, o.userId, o.productName, o.totalPrice, o.orderDate, o.status, u.username AS customerUsername " +
                     "FROM orders o JOIN users u ON o.userId = u.id " +
                     "ORDER BY o.orderDate DESC LIMIT ?"; 
        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) recentSales.add(mapRowToOrderWithCustomer(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return recentSales;
    }
    
    public List<Order> getAllOrdersAdminView() { 
        List<Order> allOrders = new ArrayList<>();
        String sql = "SELECT o.orderId, o.userId, o.productName, o.totalPrice, o.orderDate, o.status, u.username AS customerUsername " +
                     "FROM orders o JOIN users u ON o.userId = u.id " +
                     "ORDER BY o.orderDate DESC, o.orderId DESC";
        try (Connection conn = DatabaseConfig.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) allOrders.add(mapRowToOrderWithCustomer(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return allOrders;
    }

    public boolean updateOrderStatus(String orderId, String newStatus) {
       
        String sql = "UPDATE orders SET status = ? WHERE orderId = ?";
        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setString(2, orderId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}