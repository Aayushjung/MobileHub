package com.mobilehub.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date; // For getOrderDateAsUtilDate

public class Order implements Serializable {
    private static final long serialVersionUID = 2L;

    private String orderId;
    private int userId;
    private String productName;
    private double totalPrice;
    private Timestamp orderDate;
    private String status;
    private String customerUsername; // <-- ADD THIS FIELD

    public Order() {}

    public Order(String orderId, int userId, String productName, double totalPrice, Timestamp orderDate, String status) {
        this.orderId = orderId;
        this.userId = userId;
        this.productName = productName;
        this.totalPrice = totalPrice;
        this.orderDate = orderDate;
        this.status = status;
    }
    // Constructor including customerUsername
    public Order(String orderId, int userId, String productName, double totalPrice, Timestamp orderDate, String status, String customerUsername) {
        this(orderId, userId, productName, totalPrice, orderDate, status); // Call existing constructor
        this.customerUsername = customerUsername;
    }

    // --- Getters & Setters (Add for customerUsername, others remain) ---
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCustomerUsername() { return customerUsername; } // <-- GETTER
    public void setCustomerUsername(String customerUsername) { this.customerUsername = customerUsername; } // <-- SETTER

    public Date getOrderDateAsUtilDate() {
        if (this.orderDate == null) return null;
        return new Date(this.orderDate.getTime());
    }

    @Override
    public String toString() {
        return "Order{orderId='" + orderId + "', customerUsername='" + customerUsername + "', status='" + status + "'}";
    }
}