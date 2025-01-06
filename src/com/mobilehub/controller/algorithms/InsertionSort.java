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

public class InsertionSort {

    public static void sortByModelId(List<ModelDetails> modelList, DefaultTableModel tableModel) {
        if (modelList == null || modelList.size() <= 1) {
            return; // No need to sort if the list is empty or has only one element
        }

        // Perform insertion sort
        for (int i = 1; i < modelList.size(); i++) {
            ModelDetails key = modelList.get(i);
            int j = i - 1;

            // Move elements of modelList[0..i-1] that are greater than key.modelId
            // to one position ahead of their current position
            while (j >= 0 && modelList.get(j).getModelId() > key.getModelId()) {
                modelList.set(j + 1, modelList.get(j));
                j--;
            }
            modelList.set(j + 1, key);
        }

        // Update the table with the sorted data
        updateTable(modelList, tableModel);
    }

    private static void updateTable(List<ModelDetails> modelList, DefaultTableModel tableModel) {
        // Clear the table
        tableModel.setRowCount(0);

        // Add sorted data to the table
        for (ModelDetails model : modelList) {
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
