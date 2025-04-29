package com.mobilehub.model;

import java.io.Serializable; // Optional: Good practice for objects stored in session or transferred

/**
 * Represents a product available for sale in the MobileHub application.
 */
public class ProductForSale implements Serializable { // Implement Serializable (optional but recommended)

    private static final long serialVersionUID = 1L; // Optional: for Serializable

    private int id;
    private String name;
    private String description;
    private String imageUrl;
    private double price;

    // Default constructor (required by some frameworks/libraries, good practice)
    public ProductForSale() {
    }

    // Constructor to initialize all fields
    public ProductForSale(int id, String name, String description, String imageUrl, double price) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
        this.price = price;
    }

    // --- Getters --- (Needed for accessing data in JSPs using EL: ${product.name})

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public double getPrice() {
        return price;
    }

    // --- Setters --- (Optional for this specific use case, but good practice)

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    // --- Optional: toString() method for debugging ---

    @Override
    public String toString() {
        return "ProductForSale{" +
               "id=" + id +
               ", name='" + name + '\'' +
               ", price=" + price +
               ", imageUrl='" + imageUrl + '\'' +
               ", description='" + description + '\'' +
               '}';
    }
}