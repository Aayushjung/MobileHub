/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.Validation to edit this template
 */
package com.mobilehub.util;

/**
 *
 * @author ROG STRIX
 */
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


}
