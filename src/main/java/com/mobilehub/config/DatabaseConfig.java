package com.mobilehub.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseConfig {

   
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mobilehub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
  
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; 
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DB_DRIVER);
            System.out.println("DatabaseConfig: MySQL JDBC Driver registered successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("DatabaseConfig: FATAL - MySQL JDBC Driver not found. Ensure mysql-connector-j.jar is in WEB-INF/lib.");
            e.printStackTrace();
            
            throw new RuntimeException("Failed to load database driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        // System.out.println("DatabaseConfig: Attempting to get connection to " + DB_URL); 
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        // if (conn != null) {
        //     System.out.println("DatabaseConfig: Connection established successfully.");
        // } else {
        //     System.err.println("DatabaseConfig: FAILED to establish connection.");
        // }
        return conn;
    }

    // Consistent closeQuietly methods
    public static void closeQuietly(AutoCloseable resource) {
        if (resource != null) {
            try {
                resource.close();
            } catch (Exception e) {
               
            }
        }
    }
    
    public static void closeQuietly(Statement stmt) { closeQuietly((AutoCloseable)stmt); }
    public static void closeQuietly(ResultSet rs) { closeQuietly((AutoCloseable)rs); }
    public static void closeQuietly(Connection conn) { closeQuietly((AutoCloseable)conn); }
}