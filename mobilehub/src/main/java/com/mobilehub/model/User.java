package com.mobilehub.model;

import java.io.Serializable;
import java.sql.Timestamp; // Use Timestamp if coming directly from SQL DATETIME/TIMESTAMP
// Or import java.time.LocalDateTime; if you convert it

public class User implements Serializable {
    private static final long serialVersionUID = 1L; // Keep consistent

    private int id;
    private String username;
    private String password; // Keep internal, don't display
    private String email;
    private String phone;
    private String role;
    private Timestamp createdAt; // Added field for "Joined On"

    // Constructors (keep existing)
    public User() {}
    // Ensure your constructor used during login populates createdAt if available
    public User(int id, String username, String email, String phone, String role, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.createdAt = createdAt;
    }
     // Other constructors...


    // Getters (Ensure getter for createdAt exists)
    public int getId() { return id; }
    public String getUsername() { return username; }
    // No getter for password needed externally
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getRole() { return role; }
    public Timestamp getCreatedAt() { return createdAt; } // Getter for joined date

    // Setters (Keep existing, add for createdAt)
    public void setId(int id) { this.id = id; }
    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setRole(String role) { this.role = role; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        // Include createdAt if needed for debugging
        return "User{" + /* ... other fields ... */ ", createdAt=" + createdAt + '}';
    }
	public String getPassword() {
		// TODO Auto-generated method stub
		return null;
	}
}