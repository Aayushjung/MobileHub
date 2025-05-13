package com.mobilehub.dao;

import com.mobilehub.config.DatabaseConfig;
import com.mobilehub.model.User;
import org.mindrot.jbcrypt.BCrypt; // For validateUser

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types; // For Types.VARCHAR
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, password, email, phone, role, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        System.out.println("--- UserDAO.addUser Method Invoked ---");
        if (user == null) {
            System.err.println("UserDAO.addUser: CRITICAL - User object passed to addUser is null!");
            return false;
        }
        System.out.println("UserDAO.addUser: Received User object for DB insertion:");
        System.out.println("  Username: " + user.getUsername());
        System.out.println("  Hashed Password (length " + (user.getPassword() != null ? user.getPassword().length() : "null") + "): " + user.getPassword());
        System.out.println("  Email: " + user.getEmail());
        System.out.println("  Phone: " + user.getPhone());
        System.out.println("  Role: " + user.getRole());
        // System.out.println("  CreatedAt from User obj: " + user.getCreatedAt()); // If User model can hold this before DB

        try {
            conn = DatabaseConfig.getConnection();
            if (conn == null) {
                System.err.println("UserDAO.addUser: CRITICAL - Database connection is null! Check DatabaseConfig.");
                return false;
            }
            System.out.println("UserDAO.addUser: Database connection obtained successfully.");

            pstmt = conn.prepareStatement(sql);
            System.out.println("UserDAO.addUser: PreparedStatement created for SQL: " + sql);

            // Set parameters carefully
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword()); // This should be the HASHED password

            // Check for null email, though it's usually required
            if (user.getEmail() != null) {
                 pstmt.setString(3, user.getEmail());
            } else {
                 System.err.println("UserDAO.addUser: Warning - Email is null for user: " + user.getUsername());
                 pstmt.setNull(3, Types.VARCHAR); // Or handle as error if email is NOT NULL in DB
            }

            // Handle optional phone number
            if (user.getPhone() != null && !user.getPhone().isEmpty()) {
                pstmt.setString(4, user.getPhone());
            } else {
                pstmt.setNull(4, Types.VARCHAR); // Correct way to insert NULL for VARCHAR
            }

             // Check for null role, though usually set to "customer" by default
            if (user.getRole() != null) {
                pstmt.setString(5, user.getRole());
            } else {
                System.err.println("UserDAO.addUser: Warning - Role is null for user: " + user.getUsername() + ". Setting to 'customer'.");
                pstmt.setString(5, "customer"); // Default if not set
            }


            // Set created_at timestamp
            Timestamp createdAtToInsert;
            if (user.getCreatedAt() != null) {
                createdAtToInsert = user.getCreatedAt(); // If User object already has it
            } else {
                createdAtToInsert = new Timestamp(System.currentTimeMillis()); // Default to current time
            }
            pstmt.setTimestamp(6, createdAtToInsert);
            System.out.println("UserDAO.addUser: Parameters set. create_at is: " + createdAtToInsert);


            System.out.println("UserDAO.addUser: Attempting to execute update...");
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("UserDAO.addUser: Rows affected by INSERT: " + rowsAffected);
            success = (rowsAffected > 0);

            if (success) {
                System.out.println("UserDAO.addUser: User '" + user.getUsername() + "' ADDED successfully to database.");
            } else {
                System.err.println("UserDAO.addUser: User '" + user.getUsername() + "' ADD FAILED (0 rows affected). This usually indicates a problem but no SQLException was thrown.");
            }

        } catch (SQLException e) {
            System.err.println("!!!!!!!! UserDAO.addUser - SQLException CAUGHT !!!!!!!");
            System.err.println("Failed to add user: " + (user != null ? user.getUsername() : "UNKNOWN (User object was null)"));
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace(); // THIS IS THE MOST IMPORTANT PART FOR DEBUGGING SQL ISSUES
            success = false; // Ensure success is false if an exception occurs
        } finally {
            System.out.println("UserDAO.addUser: In finally block, closing PreparedStatement and Connection.");
            DatabaseConfig.closeQuietly(pstmt);
            DatabaseConfig.closeQuietly(conn);
        }
        System.out.println("UserDAO.addUser: Returning success status: " + success);
        System.out.println("--- UserDAO.addUser Method End ---");
        return success;
    }

    // --- validateUser (for login - ensure it uses BCrypt.checkpw) ---
    public User validateUser(String username, String plainPasswordFromLogin) {
        String sql = "SELECT id, username, password, email, phone, role, created_at FROM users WHERE username = ?";
        User user = null;
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        System.out.println("--- UserDAO.validateUser Invoked for: " + username + " ---");
        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                String hashedPasswordFromDB = rs.getString("password");
                System.out.println("UserDAO.validateUser: Found user. DB Hash: " + hashedPasswordFromDB);
                System.out.println("UserDAO.validateUser: Plain pass received: " + "[PROTECTED]"); // Don't log plain pass in prod

                if (hashedPasswordFromDB != null && BCrypt.checkpw(plainPasswordFromLogin, hashedPasswordFromDB)) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    System.out.println("UserDAO.validateUser: Password MATCH for " + username);
                } else {
                    System.out.println("UserDAO.validateUser: Password MISMATCH for " + username);
                }
            } else {
                System.out.println("UserDAO.validateUser: User NOT FOUND " + username);
            }
        } catch (SQLException e) {
            System.err.println("UserDAO - Error validating user: " + e.getMessage()); e.printStackTrace();
        } catch (IllegalArgumentException iae) {
            System.err.println("UserDAO - BCrypt error (likely invalid hash in DB for " + username + "): " + iae.getMessage()); iae.printStackTrace();
        }
        finally { DatabaseConfig.closeQuietly(rs); DatabaseConfig.closeQuietly(pstmt); DatabaseConfig.closeQuietly(conn); }
        System.out.println("--- UserDAO.validateUser End ---");
        return user;
    }


    // --- userExists ---
    public boolean userExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; boolean exists = false;
        try {
            conn = DatabaseConfig.getConnection(); pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username); rs = pstmt.executeQuery();
            if (rs.next()) { exists = rs.getInt(1) > 0; }
        } catch (SQLException e) { System.err.println("UserDAO - Error checking username: " + e.getMessage()); e.printStackTrace(); }
        finally { DatabaseConfig.closeQuietly(rs); DatabaseConfig.closeQuietly(pstmt); DatabaseConfig.closeQuietly(conn); }
        return exists;
    }

    // --- emailExists ---
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; boolean exists = false;
        try {
            conn = DatabaseConfig.getConnection(); pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email); rs = pstmt.executeQuery();
            if (rs.next()) { exists = rs.getInt(1) > 0; }
        } catch (SQLException e) { System.err.println("UserDAO - Error checking email: " + e.getMessage()); e.printStackTrace(); }
        finally { DatabaseConfig.closeQuietly(rs); DatabaseConfig.closeQuietly(pstmt); DatabaseConfig.closeQuietly(conn); }
        return exists;
    }

    // --- getAllUsers and deleteUser methods (keep as they were if needed for admin) ---
    public List<User> getAllUsers() { /* ... */ return new ArrayList<>(); }
    public boolean deleteUser(int userId) { /* ... */ return false; }

}