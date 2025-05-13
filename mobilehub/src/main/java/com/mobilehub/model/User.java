package com.mobilehub.model;

import java.io.Serializable;
import java.sql.Timestamp; // For created_at

public class User implements Serializable {
    private static final long serialVersionUID = 1L; // Keep consistent or update if structure changes significantly

    private int id;
    private String username;
    private String password; // This will store the HASHED password
    private String email;
    private String phone;    // Optional
    private String role;
    private Timestamp createdAt; // For "Joined On" or registration timestamp

    // Default constructor
    public User() {
    }

    // Constructor used by DAO when fetching from DB (could include password hash or not)
    public User(int id, String username, String email, String phone, String role, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.createdAt = createdAt;
    }

    // Constructor potentially used by SignupServlet (before hashing occurs there)
    // Or a constructor that takes the hashed password directly.
    // For simplicity, we'll rely on setters in the servlet.


    // Getters
    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getPassword() { return password; } // Needed by UserDAO to get the (hashed) password
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getRole() { return role; }
    public Timestamp getCreatedAt() { return createdAt; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; } // Servlet sets the HASHED password here
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setRole(String role) { this.role = role; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{" +
               "id=" + id +
               ", username='" + username + '\'' +
               // Avoid logging password, even if hashed: ", password='[PROTECTED]'" +
               ", email='" + email + '\'' +
               ", phone='" + phone + '\'' +
               ", role='" + role + '\'' +
               ", createdAt=" + createdAt +
               '}';
    }
}