package com.mobilehub.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {

    // IMPORTANT: Use environment variables or a config file for sensitive data in production
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mobilehub_db?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // No password as requested
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            // Load the MySQL JDBC driver
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("Error loading MySQL JDBC Driver: " + e.getMessage());
            // Consider throwing a RuntimeException or handling appropriately
            // throw new RuntimeException("Failed to load database driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // Optional: Method to close resources quietly
    public static void closeQuietly(AutoCloseable resource) {
        if (resource != null) {
            try {
                resource.close();
            } catch (Exception e) {
                // Log or ignore
                System.err.println("Error closing resource: " + e.getMessage());
            }
        }
    }
}