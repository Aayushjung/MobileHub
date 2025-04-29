package com.mobilehub.controller; // Using a sub-package for admin actions

import com.mobilehub.dao.UserDAO; // Assuming you might need user data
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// Map this servlet to the URL you use in the navbar link
@WebServlet("/admin/manage-users")
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO; // Optional: Inject or create DAO if needed

    @Override
    public void init() {
        userDAO = new UserDAO(); // Initialize DAO if needed by this servlet
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Get existing session

        // --- Security Check ---
        // Ensure user is logged in AND is an admin before proceeding
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {

            // Not authorized - redirect to login with an error message
            response.sendRedirect(request.getContextPath() + "/login?errorMessage=Admin+access+required.");
            return; // Stop processing
        }
        // --- End Security Check ---


        // --- Servlet Logic ---
        // This is where you would fetch data needed for the manage users page
        // For example, fetch a list of all users (except maybe the admin themselves)
        System.out.println("Admin user accessing Manage Users page.");

        /*
        try {
            // Example: Fetching users (implement listUsers() in UserDAO)
             List<User> userList = userDAO.listUsers();
             request.setAttribute("userList", userList);
        } catch (Exception e) {
             System.err.println("Error fetching users for admin: " + e.getMessage());
             request.setAttribute("errorMessage", "Could not load user data.");
             // Handle error appropriately, maybe forward to an error page or the dashboard
        }
        */


        // --- Forward to the JSP ---
        // Forward the request to the JSP page that will display the user management interface
        // This JSP would likely be within /WEB-INF/pages/admin/
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/manage_users.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests if the manage users page has forms (e.g., delete user, update role)
        // Remember to include the security check here too!
         HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("user") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
             response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required."); // Send forbidden error
             return;
         }

         String action = request.getParameter("action"); // Example: check if deleting/editing
         // ... handle delete, edit, etc. ...

         // Often redirect back to the GET handler after a POST action (Post-Redirect-Get pattern)
         response.sendRedirect(request.getContextPath() + "/admin/manage-users");
    }
}