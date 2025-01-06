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

public class MergeSort {

    public static void sortByQuantity(List<ModelDetails> modelList, DefaultTableModel tableModel) {
        if (modelList == null || modelList.size() <= 1) {
            return; // No need to sort if the list is empty or has only one element
        }

        // Perform merge sort
        mergeSort(modelList, 0, modelList.size() - 1);

        // Update the table with the sorted data
        updateTable(modelList, tableModel);
    }

    private static void mergeSort(List<ModelDetails> modelList, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2; // Find the middle point

            // Recursively sort the left and right halves
            mergeSort(modelList, left, mid);
            mergeSort(modelList, mid + 1, right);

            // Merge the sorted halves
            merge(modelList, left, mid, right);
        }
    }

    private static void merge(List<ModelDetails> modelList, int left, int mid, int right) {
        // Create temporary arrays for the left and right halves
        int n1 = mid - left + 1;
        int n2 = right - mid;

        ModelDetails[] leftArray = new ModelDetails[n1];
        ModelDetails[] rightArray = new ModelDetails[n2];

        // Copy data to temporary arrays
        for (int i = 0; i < n1; i++) {
            leftArray[i] = modelList.get(left + i);
        }
        for (int j = 0; j < n2; j++) {
            rightArray[j] = modelList.get(mid + 1 + j);
        }

        // Merge the temporary arrays back into the main list
        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2) {
            if (leftArray[i].getQuantity() <= rightArray[j].getQuantity()) {
                modelList.set(k, leftArray[i]);
                i++;
            } else {
                modelList.set(k, rightArray[j]);
                j++;
            }
            k++;
        }

        // Copy remaining elements of leftArray (if any)
        while (i < n1) {
            modelList.set(k, leftArray[i]);
            i++;
            k++;
        }

        // Copy remaining elements of rightArray (if any)
        while (j < n2) {
            modelList.set(k, rightArray[j]);
            j++;
            k++;
        }
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
