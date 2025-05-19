package com.mobilehub.util; 
import org.mindrot.jbcrypt.BCrypt;


public class PasswordUtil {

   
    public static String hashPassword(String plaintextPassword) {
        if (plaintextPassword == null || plaintextPassword.trim().isEmpty()) {
           
            return null;
        }
       
        return BCrypt.hashpw(plaintextPassword, BCrypt.gensalt(10));
    }

   
    public static boolean checkPassword(String plaintextPassword, String hashedPassword) {
        if (plaintextPassword == null || hashedPassword == null) {
            // Cannot check null passwords
            return false;
        }
        
        return BCrypt.checkpw(plaintextPassword, hashedPassword);
    }

 
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