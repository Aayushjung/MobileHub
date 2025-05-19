package com.mobilehub.dao;

import com.mobilehub.config.DatabaseConfig; // Your database connection utility
import com.mobilehub.model.User;          // Your User model class
import org.mindrot.jbcrypt.BCrypt;         // For password hashing and checking

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, password, email, phone, role, createdAt) VALUES (?, ?, ?, ?, ?, ?)";
        System.out.println("UserDAO.addUser: Attempting to add user: " + user.getUsername());
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (conn == null) {
                System.err.println("UserDAO.addUser: Database connection is null!");
                return false;
            }

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword()); 
            pstmt.setString(3, user.getEmail());

            if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
                pstmt.setString(4, user.getPhone());
            } else {
                pstmt.setNull(4, Types.VARCHAR);
            }
            pstmt.setString(5, user.getRole());

            if (user.getCreatedAt() != null) {
                pstmt.setTimestamp(6, user.getCreatedAt());
            } else {
                pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            }

            int rowsAffected = pstmt.executeUpdate();
            boolean success = (rowsAffected > 0);

            if (success) {
                System.out.println("UserDAO.addUser: User '" + user.getUsername() + "' added successfully.");
            } else {
                System.err.println("UserDAO.addUser: Failed to add user '" + user.getUsername() + "' (0 rows affected). Check SQL constraints or data.");
            }
            return success;

        } catch (SQLException e) {
            System.err.println("UserDAO.addUser: SQL Error for user '" + user.getUsername() + "' - " + e.getMessage());
            e.printStackTrace(); 
            return false;
        }
    }

   
    public User validateUser(String username, String plainPasswordFromLogin) {
        String sql = "SELECT id, username, password, email, phone, role, createdAt FROM users WHERE username = ?";
        User user = null;
        System.out.println("UserDAO.validateUser: Attempting to validate user: " + username);

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String hashedPasswordFromDB = rs.getString("password");
                    System.out.println("UserDAO.validateUser: User found. Comparing passwords for: " + username);

                    if (hashedPasswordFromDB != null && BCrypt.checkpw(plainPasswordFromLogin, hashedPasswordFromDB)) {
                        user = new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("role"),
                            rs.getTimestamp("createdAt")
                        );
                        System.out.println("UserDAO.validateUser: Password MATCH for " + username);
                    } else {
                        System.out.println("UserDAO.validateUser: Password MISMATCH for " + username);
                    }
                } else {
                    System.out.println("UserDAO.validateUser: User NOT FOUND: " + username);
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.validateUser: SQL Error for user '" + username + "' - " + e.getMessage());
            e.printStackTrace();
        } catch (IllegalArgumentException iae) {
            System.err.println("UserDAO.validateUser: BCrypt error (likely invalid hash in DB for '" + username + "'): " + iae.getMessage());
            iae.printStackTrace();
        }
        return user;
    }

   
    public boolean userExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.userExists: SQL Error checking username '" + username + "' - " + e.getMessage());
            e.printStackTrace();
        }
        return false; 
    }

 
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.emailExists: SQL Error checking email '" + email + "' - " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    
    public User getUserByUsername(String username) {
        String sql = "SELECT id, username, email, phone, role, createdAt FROM users WHERE username = ?";
        User user = null;
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User(
                        rs.getInt("id"), rs.getString("username"),
                        rs.getString("email"), rs.getString("phone"),
                        rs.getString("role"), rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.getUserByUsername: SQL Error for username '" + username + "' - " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }

  
    public User getUserByEmail(String email) {
        String sql = "SELECT id, username, email, phone, role, createdAt FROM users WHERE email = ?";
        User user = null;
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                     user = new User(
                        rs.getInt("id"), rs.getString("username"),
                        rs.getString("email"), rs.getString("phone"),
                        rs.getString("role"), rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.getUserByEmail: SQL Error for email '" + email + "' - " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }

   
    public boolean updateUserProfile(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, phone = ? WHERE id = ?";
        System.out.println("UserDAO.updateUserProfile: Attempting to update profile for User ID: " + user.getId());
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
                pstmt.setString(3, user.getPhone());
            } else {
                pstmt.setNull(3, Types.VARCHAR);
            }
            pstmt.setInt(4, user.getId());

            int rowsAffected = pstmt.executeUpdate();
            boolean success = (rowsAffected > 0);
            if(success) System.out.println("UserDAO.updateUserProfile: Profile updated for User ID: " + user.getId());
            else System.err.println("UserDAO.updateUserProfile: Failed to update profile (0 rows affected or user not found) for ID: " + user.getId());
            return success;

        } catch (SQLException e) {
            System.err.println("UserDAO.updateUserProfile: SQL Error updating profile for User ID: " + user.getId() + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT id, username, email, phone, role, createdAt FROM users ORDER BY username ASC";
        System.out.println("UserDAO.getAllUsers: Attempting to fetch all users.");
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                userList.add(new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("role"),
                    rs.getTimestamp("createdAt")
                ));
            }
            System.out.println("UserDAO.getAllUsers: Fetched " + userList.size() + " users.");
        } catch (SQLException e) {
            System.err.println("UserDAO.getAllUsers: SQL Error - " + e.getMessage());
            e.printStackTrace();
        }
        return userList;
    }

   
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        System.out.println("UserDAO.deleteUser: Attempting to delete user ID: " + userId);
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            int rowsAffected = pstmt.executeUpdate();
            boolean success = (rowsAffected > 0);
            if(success) System.out.println("UserDAO.deleteUser: User ID " + userId + " deleted.");
            else System.err.println("UserDAO.deleteUser: Failed to delete user ID " + userId + " (not found or error).");
            return success;
        } catch (SQLException e) {
            System.err.println("UserDAO.deleteUser: SQL Error for user ID " + userId + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

   
    public long getTotalCustomerCount() {
        String sql = "SELECT COUNT(*) AS customer_count FROM users WHERE role = 'customer'";
        long count = 0;
        System.out.println("UserDAO.getTotalCustomerCount: Attempting to count customers...");
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                count = rs.getLong("customer_count");
            }
            System.out.println("UserDAO.getTotalCustomerCount: Found " + count + " customers.");
        } catch (SQLException e) {
            System.err.println("UserDAO.getTotalCustomerCount: SQL Error - " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
}