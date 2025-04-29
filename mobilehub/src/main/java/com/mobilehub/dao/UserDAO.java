package com.mobilehub.dao;

import com.mobilehub.config.DatabaseConfig;
import com.mobilehub.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    /**
     * Validates user credentials and returns the User object if valid.
     * IMPORTANT: Compares plaintext passwords - Replace with hash comparison in production!
     * @param username The username to validate.
     * @param password The password to validate.
     * @return User object if credentials are valid, null otherwise.
     */
    public User validateUser(String username, String password) {
        String sql = "SELECT id, username, email, phone, role FROM users WHERE username = ? AND password = ?";
        User user = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password); // Plaintext comparison - INSECURE!

            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
            }
        } catch (SQLException e) {
            System.err.println("Error validating user: " + e.getMessage());
            // Handle exception appropriately (log, throw custom exception)
        } finally {
            DatabaseConfig.closeQuietly(rs);
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return user;
    }

    /**
     * Adds a new user to the database.
     * IMPORTANT: Stores plaintext password - Use hashing in production!
     * @param user The User object containing signup details.
     * @return true if user was added successfully, false otherwise.
     */
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, password, email, phone, role) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword()); // Plaintext storage - INSECURE!
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getRole() != null ? user.getRole() : "customer"); // Default role

            int rowsAffected = pstmt.executeUpdate();
            success = (rowsAffected > 0);

        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            // Handle specific errors like duplicate entry if needed
        } finally {
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return success;
    }

    /**
     * Checks if a username already exists in the database.
     * @param username The username to check.
     * @return true if username exists, false otherwise.
     */
     public boolean userExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;

        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
             System.err.println("Error checking username existence: " + e.getMessage());
        } finally {
            DatabaseConfig.closeQuietly(rs);
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return exists;
     }

     /**
     * Checks if an email already exists in the database.
     * @param email The email to check.
     * @return true if email exists, false otherwise.
     */
     public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;

        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
             System.err.println("Error checking email existence: " + e.getMessage());
        } finally {
            DatabaseConfig.closeQuietly(rs);
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        return exists;
     }
}