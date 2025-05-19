<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Security check: Ensure only admin can access
    if (session.getAttribute("user") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
       session.setAttribute("errorMessage", "Admin access required.");
       response.sendRedirect(request.getContextPath() + "/login");
       return;
    }

    // Retrieve form error message from session if set by POST handler on validation fail
    // This is useful if the servlet redirects back to the form on POST error
    String formErrorMessage = (String) session.getAttribute("formErrorMessage");
    if (formErrorMessage != null) {
        request.setAttribute("formErrorMessageLocal", formErrorMessage); // Move to request scope for one-time display
        session.removeAttribute("formErrorMessage"); // Clear from session
    }

    // Determine if it's an edit or new form based on product.id
    // The servlet sets 'product' attribute (either new Product() or existing from DB)
    // and 'formAction' ("insert" or "update")
    // and 'formTitle' ("Add New Product" or "Edit Product")
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Dynamic Title based on action --%>
    <title>${not empty formTitle ? formTitle : (formAction == 'insert' ? 'Add New Product' : 'Edit Product')} - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <%-- Ensure your style.css contains styles for .page-container, .page-header, .form-card etc.
         and :root variables for colors if used in the inline style block. --%>
    <style>
        /*
           Inline styles for Product Form Page.
           Ideally, move these to your main style.css using specific classes.
           Assumes global body styles (font, bg, padding-top for navbar) and :root variables
           are in the linked style.css.
        */
        /* body padding-top should be from style.css if navbar is fixed */

        .page-container {
            max-width: 800px; /* Suitable for a form */
            margin: 30px auto;
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
        .back-link {
            display: inline-block; padding: 8px 15px; font-size: 0.9rem;
            background-color: var(--admin-sidebar-bg, #2c3e50); /* Example from admin theme */
            color: var(--admin-sidebar-text, #ecf0f1);
            text-decoration: none; border-radius: 5px; transition: background-color 0.2s;
        }
        .back-link:hover { background-color: #3e5771; /* Darken */ }

        .form-card {
            background-color: var(--card-bg, #fff);
            border-radius: 10px;
            padding: 30px 35px;
            box-shadow: 0 4px 15px var(--admin-card-shadow, rgba(44, 62, 80, 0.1));
            border: 1px solid var(--admin-border-color, #dfe6e9);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 6px;
            color: var(--text-secondary, #666);
            font-size: 0.9rem;
        }
        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group input[type="url"], /* For image URL */
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--admin-border-color, #dfe6e9);
            border-radius: 5px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif; /* Ensure consistent font */
            line-height: 1.5;
        }
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        .form-group input:focus, .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-purple, #7e57c2); /* Highlight on focus */
            box-shadow: 0 0 0 2px rgba(126, 87, 194, 0.2);
        }
        .form-actions {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid var(--admin-border-color, #dfe6e9);
            text-align: right;
        }
        .submit-btn {
            padding: 10px 25px;
            background-color: var(--accent-green, #2ecc71); /* Green for save/add */
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .submit-btn:hover { background-color: #27ae60; } /* Darker green */
        .cancel-link {
            margin-right: 15px;
            color: var(--text-secondary, #666);
            text-decoration: none;
            font-size: 0.95rem;
            padding: 10px 0; /* Make it easier to click */
        }
        .cancel-link:hover { text-decoration: underline; }

       
        .error-message {
            color: var(--accent-red, #e74c3c);
            background-color: #ffebee;
            padding: 10px 15px;
            border: 1px solid var(--accent-red, #e74c3c);
            border-radius: 4px;
            margin-bottom: 20px;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="page-header">
            <h1><c:out value="${not empty formTitle ? formTitle : (formAction == 'insert' ? 'Add New Product' : 'Edit Product')}"/></h1>
            <a href="${pageContext.request.contextPath}/admin/manage-products" class="back-link">Back to Product List</a>
        </header>

        <div class="form-card">
            <%-- Display form-specific error messages passed from servlet --%>
            <c:if test="${not empty formErrorMessageLocal}">
                <p class="error-message">${formErrorMessageLocal}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/manage-products" method="post">
                <%-- Hidden field for the action (insert or update) --%>
                <input type="hidden" name="action" value="${not empty formAction ? formAction : 'insert'}">

                <%-- Hidden field for product ID if it's an update action --%>
                <c:if test="${not empty product && not empty product.id && product.id > 0}">
                    <input type="hidden" name="id" value="${product.id}">
                </c:if>

                <div class="form-group">
                    <label for="name">Product Name:</label>
                    <input type="text" id="name" name="name" value="<c:out value='${product.name}'/>" required>
                </div>

                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description" rows="4" placeholder="Enter detailed product description..."><c:out value='${product.description}'/></textarea>
                </div>

                <div class="form-group">
                    <label for="price">Price ($):</label>
                    <input type="number" id="price" name="price" value="${empty product.price ? '0.00' : product.price}" step="0.01" min="0.01" required placeholder="e.g., 999.99">
                </div>

                <div class="form-group">
                    <label for="category">Category:</label>
                    <input type="text" id="category" name="category" value="<c:out value='${product.category}'/>" placeholder="e.g., Smartphone, Premium, Standard, Accessory">
                </div>

                <div class="form-group">
                    <label for="stockQuantity">Stock Quantity:</label>
                    <input type="number" id="stockQuantity" name="stockQuantity" value="${empty product.stockQuantity ? '0' : product.stockQuantity}" min="0" required placeholder="e.g., 100">
                </div>

                <div class="form-group">
                    <label for="imageUrl">Image Data URL (or Path):</label>
                    <textarea id="imageUrl" name="imageUrl" rows="3" placeholder="Paste full data:image/... URL or a relative path like /images/product.jpg"><c:out value='${product.imageUrl}'/></textarea>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/manage-products" class="cancel-link">Cancel</a>
                    <button type="submit" class="submit-btn">
                        <c:out value="${not empty formTitle ? (formAction == 'insert' ? 'Add Product' : 'Update Product') : 'Save Product'}"/>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>