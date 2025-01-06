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

public class SelectionSort {

    public static void sortByPrice(List<ModelDetails> modelList, DefaultTableModel tableModel) {
        int n = modelList.size();

        for (int i = 0; i < n - 1; i++) {
            int minIndex = i;
            for (int j = i + 1; j < n; j++) {
                if (modelList.get(j).getPrice() < modelList.get(minIndex).getPrice()) {
                    minIndex = j;
                }
            }
            // Swap the found minimum element with the first element
            ModelDetails temp = modelList.get(minIndex);
            modelList.set(minIndex, modelList.get(i));
            modelList.set(i, temp);
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
