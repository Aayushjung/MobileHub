<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> <%-- For formatting price and date --%>
<%
    // Security check: Ensure only admin users can access this page
    Object userObj = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (userObj == null || !"admin".equalsIgnoreCase(role)) {
       session.setAttribute("errorMessage", "Admin access required. Please login with admin credentials.");
       response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login servlet
       return; // Stop further processing of this JSP
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <%-- Link to your main style.css (for navbar, global styles, :root variables) --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <%-- Inline CSS for this specific Manage Products page content --%>
    <style>
        /*
           Assumes global body styles (font, bg, padding-top for navbar) and
           :root CSS variables (colors, etc.) are defined in the linked style.css.
        */

        .page-container { /* Common wrapper for page content below navbar */
            max-width: 1400px; /* Or your preferred width for wider tables */
            margin: 30px auto; /* Space from navbar and for centering */
            padding: 0 20px;
        }

        .page-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--admin-border-color, #dfe6e9); /* Use admin theme variable */
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-header h1 {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--text-primary, #2c3e50); /* Use admin theme variable */
        }
        .back-link { /* For "Back to Dashboard" button */
            display: inline-block;
            padding: 8px 15px;
            font-size: 0.9rem;
            background-color: var(--admin-sidebar-bg, #2c3e50); /* Using admin theme color */
            color: var(--admin-sidebar-text, #ecf0f1);
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.2s;
        }
        .back-link:hover {
            background-color: #3e5771; /* Darken the sidebar color */
        }

        .product-management-card { /* The main card holding the table */
            background-color: var(--card-bg, #fff); /* White card */
            border-radius: 10px;
            padding: 25px 30px;
            box-shadow: 0 4px 15px var(--admin-card-shadow, rgba(44, 62, 80, 0.1));
            border: 1px solid var(--admin-border-color, #dfe6e9);
        }

        .table-actions { /* Container for "Add New Product" button */
            margin-bottom: 20px;
            text-align: right;
        }
        .add-product-btn {
            padding: 9px 20px; /* Slightly larger button */
            background-color: var(--accent-green, #2ecc71); /* Green for add */
            color: #fff;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-size: 0.95rem; /* Slightly larger font */
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .add-product-btn:hover {
            background-color: #27ae60; /* Darker green */
        }

        .products-table-wrapper {
            overflow-x: auto; /* Allows table to be scrolled horizontally on small screens */
        }
        .products-table {
            width: 100%;
            border-collapse: collapse; /* Clean look */
        }
        .products-table th, .products-table td {
            padding: 12px 15px; /* Increased padding */
            text-align: left;
            border-bottom: 1px solid var(--admin-border-color, #dfe6e9);
            font-size: 0.9rem; /* Consistent font size */
            vertical-align: middle; /* Better alignment with images */
            color: var(--text-light, #555);
        }
        .products-table th {
            background-color: #f8f9fa; /* Very light grey for header */
            color: var(--text-primary, #2c3e50); /* Darker text for header */
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem; /* Smaller for header text */
            letter-spacing: 0.5px;
        }
        .products-table tbody tr:hover {
            background-color: #f1f3f5; /* Subtle hover for rows */
        }
        .products-table .product-image-thumb {
            max-width: 60px;
            max-height: 60px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #eee; /* Light border around thumb */
            vertical-align: middle;
        }
        .action-buttons form, .action-buttons a { /* For Edit/Delete buttons */
            display: inline-block;
            margin-left: 8px;
        }
        .action-buttons .btn-small {
            padding: 6px 12px; /* Slightly larger small buttons */
            font-size: 0.8rem;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            border: none;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .action-buttons .btn-small:hover { opacity: 0.85; }
        .edit-btn { background-color: var(--accent-blue, #3498db); }
        .delete-btn { background-color: var(--accent-red, #e74c3c); }

        /* Message styles (should be consistent with other pages, ideally from style.css) */
        .success-message { color: green; background-color:#e8f5e9; padding:10px 15px; border:1px solid green; border-radius:4px; margin-bottom: 15px; font-weight: 500;}
        .error-message { color: red; background-color:#ffebee; padding:10px 15px; border:1px solid red; border-radius:4px; margin-bottom: 15px; font-weight: 500;}
        .info-message-table td { text-align: center; padding: 20px; color: var(--text-secondary); font-style: italic; }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            .page-container { padding: 0 15px; margin-top: 20px; }
        }
        @media (max-width: 768px) {
             .page-header { flex-direction: column; align-items: flex-start; gap: 10px; }
             .page-header h1 { font-size: 1.6rem; }
             .product-management-card { padding: 20px; }
             .products-table th, .products-table td { padding: 8px; font-size: 0.85rem; }
             .products-table .product-image-thumb { max-width: 40px; max-height: 40px;}
        }
    </style>
</head>
<body>

    <%-- Include the Standard Global Navbar --%>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="page-header">
            <h1>Manage Products</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">Back to Dashboard</a>
        </header>

        <div class="product-management-card">
            <%-- Display Success/Error Messages passed from Servlet POST actions --%>
            <c:if test="${not empty successMessage}">
                <p class="success-message">${successMessage}</p>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <p class="error-message">${errorMessage}</p>
            </c:if>

            <div class="table-actions">
                <a href="${pageContext.request.contextPath}/admin/manage-products?action=new" class="add-product-btn">Add New Product</a>
            </div>

            <div class="products-table-wrapper">
                <table class="products-table">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Created On</th> 
                            <th>Actions</th>
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
                                        <td>
                                            <c:if test="${not empty product.createdAt}">
                                                <fmt:formatDate value="${product.createdAt}" pattern="yyyy-MM-dd"/>
                                            </c:if>
                                            <c:if test="${empty product.createdAt}">N/A</c:if>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/manage-products?action=edit&id=${product.id}" class="btn-small edit-btn">Edit</a>
                                            <form action="${pageContext.request.contextPath}/admin/manage-products" method="post" style="display:inline;"
                                                  onsubmit="return confirm('Are you sure you want to delete product \'${product.name}\'? This action cannot be undone.');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${product.id}"> <%-- Ensure 'id' is used here --%>
                                                <button type="submit" class="btn-small delete-btn">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr class="info-message-table">
                                    <td colspan="8">No products found. Click "Add New Product" to start.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div> <%-- End product-management-card --%>
    </div> <%-- End Page Container --%>

</body>
</html>