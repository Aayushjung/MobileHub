<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Security check
    Object userObj = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (userObj == null || !"admin".equalsIgnoreCase(role)) {
       session.setAttribute("errorMessage", "Admin access required.");
       response.sendRedirect(request.getContextPath() + "/login");
       return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%-- Link to global style.css (for navbar, body defaults, :root variables) --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /*
           Inline styles for manage_users.jsp page content.
           Assumes :root variables like --admin-content-bg, --card-bg, --admin-border-color,
           --text-primary, --accent-green, --accent-blue, --accent-red
           are defined in the linked style.css.
           Body padding-top for fixed navbar should also be in style.css.
        */
        body {
            /* background-color from style.css's :root --admin-content-bg or --page-bg */
            /* padding-top from style.css if navbar is fixed */
        }
        .page-container { /* Consistent wrapper */
            max-width: 1200px;
            margin: 30px auto; /* Space from navbar */
            padding: 0 20px;
        }
        .page-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--admin-border-color, #dfe6e9);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-header h1 {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--text-primary, #2c3e50);
        }
        .back-link { /* For "Back to Dashboard" */
            display: inline-block; padding: 8px 15px; font-size: 0.9rem;
            background-color: var(--admin-sidebar-bg, #2c3e50); /* Or a generic button color */
            color: var(--admin-sidebar-text, #ecf0f1); /* Or button text color */
            text-decoration: none; border-radius: 5px; transition: background-color 0.2s;
        }
        .back-link:hover { background-color: #3e5771; /* Darken */ }

        .user-management-card {
            background-color: var(--card-bg, #fff);
            border-radius: 10px;
            padding: 25px 30px;
            box-shadow: 0 4px 15px var(--admin-card-shadow, rgba(44, 62, 80, 0.1));
            border: 1px solid var(--admin-border-color, #dfe6e9);
        }
        .table-actions {
            margin-bottom: 20px;
            text-align: right;
        }

        .users-table-wrapper { overflow-x: auto; }
        .users-table { width: 100%; border-collapse: collapse; }
        .users-table th, .users-table td {
            padding: 10px 12px; text-align: left;
            border-bottom: 1px solid var(--admin-border-color, #dfe6e9);
            font-size: 0.95rem;
            color: var(--text-light, #555);
        }
        .users-table th {
            background-color: #f8f9fa; /* Light grey for table header */
            color: var(--text-primary, #2c3e50); font-weight: 600;
            text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;
        }
        .users-table tbody tr:hover { background-color: #f1f3f5; }
        .action-buttons form, .action-buttons a { display: inline-block; margin-left: 8px; }
        .action-buttons .btn-small {
            padding: 5px 10px; font-size: 0.8rem; border-radius: 4px;
            text-decoration: none; color: white; border: none; cursor: pointer;
            transition: opacity 0.2s;
        }
        .action-buttons .btn-small:hover { opacity: 0.85; }
        .delete-btn { background-color: var(--accent-red, #e74c3c); }
        .info-message-table td { text-align: center; padding: 20px; color: var(--text-secondary); font-style: italic; }
        /* Global message styles should be in style.css */
        .success-message { color: green; background-color:#e8f5e9; padding:10px 15px; border:1px solid green; border-radius:4px; margin-bottom: 15px; font-weight: 500;}
        .error-message { color: red; background-color:#ffebee; padding:10px 15px; border:1px solid red; border-radius:4px; margin-bottom: 15px; font-weight: 500;}

        @media (max-width: 768px) {
             .page-container { padding: 0 15px; margin-top: 20px; }
             .page-header { flex-direction: column; align-items: flex-start; gap: 10px; }
             .page-header h1 { font-size: 1.6rem; }
             .user-management-card { padding: 20px; }
             .users-table th, .users-table td { padding: 8px; font-size: 0.9rem; }
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="page-header">
            <h1>Manage Users</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">Back to Dashboard</a>
        </header>

        <div class="user-management-card">
            <c:if test="${not empty successMessage}"><p class="success-message">${successMessage}</p></c:if>
            <c:if test="${not empty errorMessage}"><p class="error-message">${errorMessage}</p></c:if>

            

            <div class="users-table-wrapper">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>ID</th><th>Username</th><th>Email</th><th>Phone</th>
                            <th>Role</th><th>Joined On</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty userList}">
                                <c:forEach var="userItem" items="${userList}">
                                    <tr>
                                        <td>${userItem.id}</td>
                                        <td><c:out value="${userItem.username}"/></td>
                                        <td><c:out value="${userItem.email}"/></td>
                                        <td><c:out value="${not empty userItem.phone ? userItem.phone : 'N/A'}"/></td>
                                        <td><c:out value="${userItem.role}"/></td>
                                        <td><fmt:formatDate value="${userItem.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td class="action-buttons">
                                            
                                            <form action="${pageContext.request.contextPath}/admin/manage-users" method="post" style="display:inline;"
                                                  onsubmit="return confirm('Delete user \'${userItem.username}\'?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="userId" value="${userItem.id}">
                                                <button type="submit" class="btn-small delete-btn">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr class="info-message-table"><td colspan="7">No other users found.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>