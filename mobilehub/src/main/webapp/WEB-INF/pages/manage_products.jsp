<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    if (session.getAttribute("user") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
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
    <title>Manage Products - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Add styles similar to manage_users.jsp or refine */
        body { padding-top: 70px; background-color: var(--admin-content-bg, #ecf0f1); }
        .page-container { max-width: 1400px; margin: 30px auto; padding: 0 20px; }
        .page-header { margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid var(--admin-border-color, #dfe6e9); display: flex; justify-content: space-between; align-items: center;}
        .page-header h1 { font-size: 1.8rem; font-weight: 600; color: var(--text-primary, #2c3e50); }
        .back-link { display: inline-block; padding: 8px 15px; font-size: 0.9rem; background-color: var(--admin-sidebar-bg, #2c3e50); color: var(--admin-sidebar-text, #ecf0f1); text-decoration: none; border-radius: 5px; transition: background-color 0.2s; }
        .back-link:hover { background-color: #3e5771; }

        .product-management-card { background-color: #fff; border-radius: 10px; padding: 25px 30px; box-shadow: 0 4px 15px var(--admin-card-shadow, rgba(44, 62, 80, 0.1)); border: 1px solid var(--admin-border-color, #dfe6e9); }
        .table-actions { margin-bottom: 20px; text-align: right; }
        .add-product-btn { padding: 8px 18px; background-color: var(--accent-green, #2ecc71); color: #fff; border: none; border-radius: 5px; text-decoration: none; font-size: 0.9rem; font-weight: 500; cursor: pointer; transition: background-color 0.2s; }
        .add-product-btn:hover { background-color: #27ae60; }

        .products-table-wrapper { overflow-x: auto; }
        .products-table { width: 100%; border-collapse: collapse; }
        .products-table th, .products-table td { padding: 10px 12px; text-align: left; border-bottom: 1px solid var(--admin-border-color, #dfe6e9); font-size: 0.9rem; vertical-align: middle;}
        .products-table th { background-color: #f8f9fa; color: var(--text-primary, #2c3e50); font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; }
        .products-table tbody tr:hover { background-color: #f1f3f5; }
        .products-table .product-image-thumb { max-width: 60px; max-height: 60px; object-fit: cover; border-radius: 4px; }
        .action-buttons form, .action-buttons a { display: inline-block; margin-left: 8px; }
        .action-buttons .btn-small { padding: 5px 10px; font-size: 0.8rem; border-radius: 4px; text-decoration: none; color: white; border: none; cursor: pointer; transition: opacity 0.2s; }
        .action-buttons .btn-small:hover { opacity: 0.85; }
        .edit-btn { background-color: var(--accent-blue, #3498db); }
        .delete-btn { background-color: var(--accent-red, #e74c3c); }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="page-header">
            <h1>Manage Products</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">Back to Dashboard</a>
        </header>

        <div class="product-management-card">
            <c:if test="${not empty successMessage}"><p class="success-message">${successMessage}</p></c:if>
            <c:if test="${not empty errorMessage}"><p class="error-message">${errorMessage}</p></c:if>

            <div class="table-actions">
                <a href="${pageContext.request.contextPath}/admin/manage-products?action=new" class="add-product-btn">Add New Product</a>
            </div>

            <div class="products-table-wrapper">
                <table class="products-table">
                    <thead>
                        <tr>
                            <th>Image</th><th>ID</th><th>Name</th><th>Category</th>
                            <th>Price</th><th>Stock</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty productList}">
                                <c:forEach var="product" items="${productList}">
                                    <tr>
                                        <td>
                                            <img src="${not empty product.imageUrl ? product.imageUrl : 'https://via.placeholder.com/60x60/e0e0e0/999?text=N/A'}"
                                                 alt="<c:out value='${product.name}'/>" class="product-image-thumb">
                                        </td>
                                        <td>${product.id}</td>
                                        <td><c:out value="${product.name}"/></td>
                                        <td><c:out value="${product.category}"/></td>
                                        <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/></td>
                                        <td>${product.stockQuantity}</td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/manage-products?action=edit&id=${product.id}" class="btn-small edit-btn">Edit</a>
                                            <form action="${pageContext.request.contextPath}/admin/manage-products" method="post" style="display:inline;"
                                                  onsubmit="return confirm('Delete product \'${product.name}\'?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${product.id}"> <%-- Changed from userId --%>
                                                <button type="submit" class="btn-small delete-btn">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr class="info-message-table"><td colspan="7">No products found.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>