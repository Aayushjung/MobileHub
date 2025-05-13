package com.mobilehub.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement; // For PreparedStatement
import java.sql.ResultSet;  // For ResultSet

public class DatabaseConfig {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/mobilehub_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"; // Added allowPublicKeyRetrieval
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // Your DB password
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("FATAL: MySQL JDBC Driver not found. Ensure mysql-connector-j JAR is in WEB-INF/lib.");
            e.printStackTrace();
            throw new RuntimeException("Failed to load database driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        System.out.println("DatabaseConfig: Attempting to get connection to " + DB_URL);
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        if (conn != null) {
            System.out.println("DatabaseConfig: Connection established successfully.");
        } else {
            System.err.println("DatabaseConfig: FAILED to establish connection.");
        }
        return conn;
    }

    public static void closeQuietly(AutoCloseable resource) {
        if (resource != null) {
            try {
                resource.close();
            } catch (Exception e) {
                // System.err.println("DatabaseConfig - Error closing resource: " + e.getMessage());
                // In production, might log this less verbosely or only on error
            }
        }
    }

    // Overload for Statement specifically if you don't want AutoCloseable everywhere
    public static void closeQuietly(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) { /* ignore */ }
        }
    }
    public static void closeQuietly(ResultSet rs) {
         if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) { /* ignore */ }
        }
    }
    public static void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) { /* ignore */ }
        }
    }
}