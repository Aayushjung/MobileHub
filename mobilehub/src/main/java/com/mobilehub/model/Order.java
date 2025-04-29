package com.mobilehub.model; // Make sure this package name is correct for your project structure

import java.io.Serializable;
import java.time.LocalDate; // Using java.time for modern date handling
// Alternatively, import java.util.Date; if you prefer that

/**
 * Represents a customer order in the MobileHub application.
 * Note: This is a simplified version, often an order contains multiple items (Order Lines).
 * For this example, we assume 'productName' represents the primary item or a summary.
 */
public class Order implements Serializable {

    // Recommended for Serializable classes
    private static final long serialVersionUID = 20240516L; // Example Version UID

    private String orderId;     // Unique identifier for the order (e.g., "ORD-2023-001")
    private LocalDate orderDate;  // Date the order was placed (using java.time)
    // private java.util.Date orderDate; // Uncomment and use this if you prefer java.util.Date

    private String productName; // Simplified representation of the product(s) in the order for listing
    private double totalPrice;    // Total cost of the order
    private String status;      // Order status (e.g., "Processing", "Shipped", "Delivered", "Cancelled")
    private int userId;         // Foreign key linking to the User who placed the order

    // Default constructor (required for some frameworks, good practice)
    public Order() {
    }

    // Parameterized constructor for creating Order objects easily
    public Order(String orderId, LocalDate orderDate, String productName, double totalPrice, String status, int userId) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.productName = productName;
        this.totalPrice = totalPrice;
        this.status = status;
        this.userId = userId;
    }

    // --- Getters ---
    // These are essential for accessing the data in JSPs using Expression Language (EL)
    // Example: ${order.orderId}

    public String getOrderId() {
        return orderId;
    }

    public LocalDate getOrderDate() {
        return orderDate;
    }
    /* // Getter for java.util.Date if used
    public java.util.Date getOrderDate() {
        return orderDate;
    }
    */

    public String getProductName() {
        return productName;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public int getUserId() {
        return userId;
    }

    // --- Setters ---
    // Allow modification of the object's state after creation

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

     public void setOrderDate(LocalDate orderDate) {
        this.orderDate = orderDate;
    }
    /* // Setter for java.util.Date if used
    public void setOrderDate(java.util.Date orderDate) {
        this.orderDate = orderDate;
    }
    */

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    // --- toString() ---
    // Useful for logging and debugging purposes

    @Override
    public String toString() {
        return "Order{" +
               "orderId='" + orderId + '\'' +
               ", orderDate=" + orderDate +
               ", productName='" + productName + '\'' +
               ", totalPrice=" + totalPrice +
               ", status='" + status + '\'' +
               ", userId=" + userId +
               '}';
    }

    // Optional: equals() and hashCode() methods if you plan to store Orders in Sets or use them as keys in Maps.
    // @Override
    // public boolean equals(Object o) { ... }
    // @Override
    // public int hashCode() { ... }
}