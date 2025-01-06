/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.ModelDetails to edit this template
 */
package com.mobilehub.model;

/**
 *
 * @author aayush
 */
public class ModelDetails {
    private int modelId;
    private String modelName;
    private String brand;
    private int price;
    private String storage;
    private int quantity;

    public ModelDetails(int modelId, String modelName, String brand, int price, String storage, int quantity) {
        this.modelId = modelId;
        this.modelName = modelName;
        this.brand = brand;
        this.price = price;
        this.storage = storage;
        this.quantity = quantity;
    }

    public int getModelId() {
        return modelId;
    }

    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getBrand() {
        return brand;
    }

     public void setBrand(String brand) {
        this.brand = brand;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getStorage() {
        return storage;
    }
    
    public void setStorage(String storage){
        this.storage = storage;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}