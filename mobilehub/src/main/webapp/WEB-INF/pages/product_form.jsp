<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    if (session.getAttribute("user") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
       session.setAttribute("errorMessage", "Admin access required.");
       response.sendRedirect(request.getContextPath() + "/login");
       return;
    }
    // Retrieve form error message from session if set by POST handler
    String formErrorMessage = (String) session.getAttribute("formErrorMessage");
    if (formErrorMessage != null) {
        request.setAttribute("formErrorMessage", formErrorMessage); // Move to request scope for display
        session.removeAttribute("formErrorMessage"); // Clear from session
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${formTitle} - Admin</title> <%-- Dynamic title --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Styles for Product Form Page */
        body { padding-top: 70px; background-color: var(--admin-content-bg, #ecf0f1); }
        .page-container { max-width: 800px; margin: 30px auto; padding: 0 20px; }
        .page-header { margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid var(--admin-border-color, #dfe6e9); display: flex; justify-content: space-between; align-items: center;}
        .page-header h1 { font-size: 1.8rem; font-weight: 600; color: var(--text-primary, #2c3e50); }
        .back-link { display: inline-block; padding: 8px 15px; font-size: 0.9rem; background-color: var(--admin-sidebar-bg, #2c3e50); color: var(--admin-sidebar-text, #ecf0f1); text-decoration: none; border-radius: 5px; transition: background-color 0.2s; }
        .back-link:hover { background-color: #3e5771; }

        .form-card { background-color: #fff; border-radius: 10px; padding: 30px 35px; box-shadow: 0 4px 15px var(--admin-card-shadow, rgba(44, 62, 80, 0.1)); border: 1px solid var(--admin-border-color, #dfe6e9); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 6px; color: var(--text-secondary, #666); font-size: 0.9rem; }
        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea {
            width: 100%; padding: 10px 12px; border: 1px solid var(--admin-border-color, #dfe6e9);
            border-radius: 5px; font-size: 0.95rem; font-family: inherit;
        }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .form-actions { margin-top: 25px; text-align: right; }
        .submit-btn { padding: 10px 25px; background-color: var(--accent-green, #2ecc71); color: #fff; border: none; border-radius: 5px; font-size: 1rem; font-weight: 500; cursor: pointer; transition: background-color 0.2s; }
        .submit-btn:hover { background-color: #27ae60; }
        .cancel-link { margin-right: 15px; color: var(--text-secondary); text-decoration: none; font-size: 0.95rem; }
        .cancel-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="page-header">
            <h1><c:out value="${formTitle}"/></h1>
            <a href="${pageContext.request.contextPath}/admin/manage-products" class="back-link">Back to Product List</a>
        </header>

        <div class="form-card">
            <c:if test="${not empty formErrorMessage}"><p class="error-message">${formErrorMessage}</p></c:if>

            <form action="${pageContext.request.contextPath}/admin/manage-products" method="post">
                <input type="hidden" name="action" value="${formAction}"> <%-- "insert" or "update" --%>
                <c:if test="${formAction == 'update'}">
                    <input type="hidden" name="id" value="${product.id}">
                </c:if>

                <div class="form-group">
                    <label for="name">Product Name:</label>
                    <input type="text" id="name" name="name" value="<c:out value='${product.name}'/>" required>
                </div>
                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description" rows="4"><c:out value='${product.description}'/></textarea>
                </div>
                <div class="form-group">
                    <label for="price">Price ($):</label>
                    <input type="number" id="price" name="price" value="${product.price}" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                    <label for="category">Category:</label>
                    <input type="text" id="category" name="category" value="<c:out value='${product.category}'/>">
                </div>
                <div class="form-group">
                    <label for="stockQuantity">Stock Quantity:</label>
                    <input type="number" id="stockQuantity" name="stockQuantity" value="${product.stockQuantity}" min="0" required>
                </div>
                <div class="form-group">
                    <label for="imageUrl">Image URL:</label>
                    <input type="text" id="imageUrl" name="imageUrl" value="<c:out value='${product.imageUrl}'/>">
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/manage-products" class="cancel-link">Cancel</a>
                    <button type="submit" class="submit-btn"><c:out value="${formTitle}"/></button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>