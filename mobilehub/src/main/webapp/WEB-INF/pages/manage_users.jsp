<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Optional: Add the same security check here as a backup, although the servlet should handle it primarily.
    // A Filter is the best place for this check.
    Object userObj = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (userObj == null || !"admin".equalsIgnoreCase(role)) {
       session.setAttribute("errorMessage", "Admin access required.");
       response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login servlet
       return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users</title>
    <%-- Link to your main CSS or admin-specific CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Add specific styles for user table if needed */
        .user-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .user-table th, .user-table td { border: 1px solid #555; padding: 8px 12px; text-align: left; }
        .user-table th { background-color: rgba(255, 255, 255, 0.1); color: #fff; }
        .user-table td { color: #ccc; }
        .user-table tr:nth-child(even) { background-color: rgba(255, 255, 255, 0.05); }
        .action-buttons form { display: inline-block; margin-right: 5px;}
        .action-buttons button { padding: 3px 8px; font-size: 0.8em;}
        .delete-btn { background-color: #dc3545; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <%-- You should include your navbar here --%>
    <%-- <%@ include file="/WEB-INF/pages/includes/navbar.jsp" %> --%>

    <div class="dashboard-container"> <%-- Reuse dashboard container style or create a new one --%>
        <h2>Manage Users</h2>
        <p>View, edit, or remove user accounts.</p>

        <%-- Display any messages passed from the servlet --%>
        <c:if test="${not empty requestScope.successMessage}">
            <p style="color: lightgreen;">${requestScope.successMessage}</p>
        </c:if>
         <c:if test="${not empty requestScope.errorMessage}">
            <p style="color: #ff8080;">${requestScope.errorMessage}</p>
        </c:if>


        <%-- Placeholder for User Table - You will populate this using JSTL later --%>
        <table class="user-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%-- Use JSTL <c:forEach> here to loop through the user list fetched by the servlet --%>
                 <%-- Example row (replace with loop) --%>
                <c:forEach var="user" items="${userList}"> <%-- Assuming servlet sets 'userList' attribute --%>
                   <tr>
                       <td>${user.id}</td>
                       <td><c:out value="${user.username}"/></td>
                       <td><c:out value="${user.email}"/></td>
                       <td><c:out value="${user.phone != null ? user.phone : 'N/A'}"/></td>
                       <td><c:out value="${user.role}"/></td>
                       <td>${user.createdAt}</td> <%-- Format this date later --%>
                       <td class="action-buttons">
                           <%-- Add Edit link/button --%>
                           <a href="#">Edit</a> |
                           <%-- Add Delete form/button --%>
                           <form action="${pageContext.request.contextPath}/admin/manage-users" method="post" onsubmit="return confirm('Are you sure you want to delete user ${user.username}?');">
                               <input type="hidden" name="action" value="delete">
                               <input type="hidden" name="userId" value="${user.id}">
                               <button type="submit" class="delete-btn">Delete</button>
                           </form>
                       </td>
                   </tr>
                </c:forEach>
                 <c:if test="${empty userList}">
                    <tr>
                        <td colspan="7" style="text-align: center;">No users found.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>

         <p style="margin-top: 20px;"><a href="${pageContext.request.contextPath}/admin/dashboard">Back to Admin Dashboard</a></p>

    </div>

</body>
</html>