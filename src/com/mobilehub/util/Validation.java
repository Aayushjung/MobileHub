/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.Validation to edit this template
 */
package com.mobilehub.util;

/**
 *
 * @author aayush
 */
import com.mobilehub.model.ModelDetails;
import java.util.List;
import javax.swing.JOptionPane;

public class Validation {
   public static boolean isNotNullOrEmpty(String value, String fieldName, javax.swing.JFrame frame) {
        if (value == null || value.trim().isEmpty()) {
            JOptionPane.showMessageDialog(frame, fieldName + " cannot be empty", "Input Error", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        return true;
    }

    public static boolean isValidInteger(String value, String fieldName, javax.swing.JFrame frame) {
        try {
            Integer.valueOf(value);
            return true;
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(frame, "Invalid " + fieldName + ". Must be a number.", "Input Error", JOptionPane.ERROR_MESSAGE);
            return false;
        }
    }

    public static boolean isPositive(int value, String fieldName, javax.swing.JFrame frame) {
        if (value < 0) {
            JOptionPane.showMessageDialog(frame, fieldName + " must be positive.", "Input Error", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        return true;
    }

    public static boolean isUniqueModelId(int modelId, List<ModelDetails> existingModels, javax.swing.JFrame frame) {
        for (ModelDetails model : existingModels) {
            if (model.getModelId() == modelId) {
                JOptionPane.showMessageDialog(frame, "Model ID already exists.", "Input Error", JOptionPane.ERROR_MESSAGE);
                return false;
            }
        }
        return true;
    }

    public static boolean isUniqueModelIdForUpdate(int newModelId, int originalModelId, List<ModelDetails> existingModels, javax.swing.JFrame frame) {
        // Allow update if new ID is the same as the original
        if (newModelId == originalModelId) {
            return true;
        }
        // Check if the new ID is unique among other models
        for (ModelDetails model : existingModels) {
            if (model.getModelId() == newModelId) {
                JOptionPane.showMessageDialog(frame, "Model ID already exists.", "Input Error", JOptionPane.ERROR_MESSAGE);
                return false;
            }
        }
        return true;
    }


}
