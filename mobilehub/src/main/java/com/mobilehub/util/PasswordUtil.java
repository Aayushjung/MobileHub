package com.mobilehub.util; // Or adjust package as needed

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for hashing and verifying passwords using BCrypt.
 */
public class PasswordUtil {

    /**
     * Hashes a plaintext password using BCrypt.
     * @param plaintextPassword The password in plaintext.
     * @return The hashed password string, or null if the input is invalid.
     */
    public static String hashPassword(String plaintextPassword) {
        if (plaintextPassword == null || plaintextPassword.trim().isEmpty()) {
            // Handle invalid input appropriately, maybe throw an exception
            return null;
        }
        // BCrypt.hashpw generates a salt automatically. The cost factor (10) can be adjusted.
        return BCrypt.hashpw(plaintextPassword, BCrypt.gensalt(10));
    }

    /**
     * Verifies a plaintext password against a stored hashed password.
     * @param plaintextPassword The password entered by the user.
     * @param hashedPassword The hashed password retrieved from the database.
     * @return true if the plaintext password matches the hash, false otherwise.
     */
    public static boolean checkPassword(String plaintextPassword, String hashedPassword) {
        if (plaintextPassword == null || hashedPassword == null) {
            // Cannot check null passwords
            return false;
        }
        // BCrypt.checkpw handles hashing the plaintext with the salt from the hash
        // and then comparing the resulting hash.
        return BCrypt.checkpw(plaintextPassword, hashedPassword);
    }

    // Example usage (optional main method for testing)
    public static void main(String[] args) {
        String password = "mysecretpassword123";
        String hashedPassword = hashPassword(password);
        System.out.println("Plaintext: " + password);
        System.out.println("Hashed: " + hashedPassword);

        boolean match = checkPassword(password, hashedPassword);
        System.out.println("Matches original password? " + match); // Should be true

        String wrongPassword = "wrongpassword";
        boolean wrongMatch = checkPassword(wrongPassword, hashedPassword);
        System.out.println("Matches wrong password? " + wrongMatch); // Should be false
    }
}