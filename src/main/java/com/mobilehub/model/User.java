package com.mobilehub.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private static final long serialVersionUID = 1L; 

    private int id;
    private String username;
    private String password; 
    private String email;
    private String phone;   
    private String role;
    private Timestamp createdAt; 

   
    public User() {
    }

    
    public User(int id, String username, String email, String phone, String role, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.createdAt = createdAt;
       
    }

  
    public User(String username, String password, String email, String phone, String role) {
        this.username = username;
        this.password = password; // 
        this.email = email;
        this.phone = phone;
        this.role = role;
       
    }


    // --- Getters ---
    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    
    public String getPassword() {
        return password;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getRole() {
        return role;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    // --- Setters ---
    public void setId(int id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * Sets the password. The value passed here should be the
     * HASHED password if it's being prepared for database storage.
     */
    public void setPassword(String password) {
        this.password = password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "User{" +
               "id=" + id +
               ", username='" + username + '\'' +
               // Avoid logging password: ", password='[PROTECTED]'" +
               ", email='" + email + '\'' +
               ", phone='" + phone + '\'' +
               ", role='" + role + '\'' +
               ", createdAt=" + createdAt +
               '}';
    }
}