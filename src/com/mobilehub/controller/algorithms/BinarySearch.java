/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mobilehub.controller.algorithms;

/**
 *
 * @author ROG STRIX
 */
import com.mobilehub.model.ModelDetails;
import java.util.List;
import javax.swing.table.DefaultTableModel;

public class BinarySearch {

    public static int searchByBrand(List<ModelDetails> modelList, String brand) {
        // Perform binary search
        int left = 0;
        int right = modelList.size() - 1;

        while (left <= right) {
            int mid = left + (right - left) / 2;

            // Compare the brand name at the mid index
            int comparison = modelList.get(mid).getBrand().compareToIgnoreCase(brand);

            if (comparison == 0) {
                return mid; // Brand found at mid index
            } else if (comparison < 0) {
                left = mid + 1; // Search in the right half
            } else {
                right = mid - 1; // Search in the left half
            }
        }

        return -1; // Brand not found
    }

    public static void sortByBrand(List<ModelDetails> modelList) {
        // Perform insertion sort (or any other stable sort) based on brand name
        for (int i = 1; i < modelList.size(); i++) {
            ModelDetails key = modelList.get(i);
            int j = i - 1;

            while (j >= 0 && modelList.get(j).getBrand().compareToIgnoreCase(key.getBrand()) > 0) {
                modelList.set(j + 1, modelList.get(j));
                j--;
            }
            modelList.set(j + 1, key);
        }
    }

    public static void updateTableWithSearchResult(List<ModelDetails> modelList, DefaultTableModel tableModel, String brand) {
        // Clear the table
        tableModel.setRowCount(0);

        // Add rows that match the searched brand
        for (ModelDetails model : modelList) {
            if (model.getBrand().equalsIgnoreCase(brand)) {
                tableModel.addRow(new Object[]{
                    model.getModelId(),
                    model.getModelName(),
                    model.getBrand(),
                    model.getPrice(),
                    model.getStorage(),
                    model.getQuantity()
                });
            }
        }
    }
}
