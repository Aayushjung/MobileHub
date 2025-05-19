<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    // Security check
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
    <title>Manage All Sales - Admin</title>
    <!-- Added Google Fonts for Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
      
        .page-container { max-width: 1400px; margin: 30px auto; padding: 0 20px; }
        .page-header { margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid var(--admin-border-color, #dfe6e9); display: flex; justify-content: space-between; align-items: center;}
        
        .page-header h1 { 
            font-size: 2em; 
            font-weight: bold;
            color: var(--text-primary, #2c3e50); 
            margin-bottom: 5px; 
        }
        .page-header .subtitle { color: var(--text-secondary, #666); font-size: 1rem; margin-top: 4px; }
        .back-link { display: inline-block; padding: 8px 15px; font-size: 0.9rem; background-color: var(--admin-sidebar-bg, #2c3e50); color: var(--admin-sidebar-text, #ecf0f1); text-decoration: none; border-radius: 5px; transition: background-color 0.2s; }
        .back-link:hover { background-color: #3e5771; }

        .content-card { background-color: var(--card-bg, #fff); border-radius: 10px; padding: 25px 30px; box-shadow: 0 4px 15px var(--admin-card-shadow, rgba(44, 62, 80, 0.1)); border: 1px solid var(--admin-border-color, #dfe6e9); }
        .card-header-sales { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid var(--admin-border-color, #dfe6e9); }
        .card-header-sales h2 { font-size: 1.3rem; font-weight: 600; color: var(--text-primary); display: flex; align-items: center; gap: 10px;}
        .search-sales input[type="search"] { padding: 8px 15px 8px 35px; border-radius: 20px; border: 1px solid var(--border-color); min-width: 250px; font-size: 0.9rem; }
        .search-sales .search-icon { position: absolute; left:12px; top:50%; transform: translateY(-50%); color: #aaa;}

        .table-wrapper { overflow-x: auto; margin-top: 20px; }
        .orders-table { width: 100%; border-collapse: collapse; }
        .orders-table th, .orders-table td { padding: 12px 15px; text-align: left; border-bottom: 1px solid var(--admin-border-color); font-size: 0.9rem; vertical-align: middle; color: var(--text-light); }
        .orders-table th { background-color: #e9ecef; color: var(--text-primary); font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; }
        .orders-table tbody tr:hover { background-color: #f1f3f5; }
        .status-badge { display: inline-block; padding: 4px 10px; border-radius: 15px; font-size: 0.8rem; font-weight: 500; text-transform: capitalize; }
        .status-delivered { background-color: #c8e6c9; color: #2e7d32; }
        .status-shipped { background-color: #bbdefb; color: #1565c0; }
        .status-processing { background-color: #fff9c4; color: #f9a825; }
        .status-completed { background-color: #a5d6a7; color: #1b5e20; }
        .status-cancelled { background-color: #ffcdd2; color: #c62828; }
        .action-btn { padding: 6px 12px; font-size: 0.85rem; border-radius: 5px; text-decoration: none; color: white; border: none; cursor: pointer; margin-right: 5px; display: inline-block; }
        .view-details-btn { background-color: var(--accent-blue, #3498db); }
        .update-status-btn { background-color: var(--accent-orange, #fd7e14); } /* Define --accent-orange or use another */
        .info-message-table td { text-align: center; padding: 20px; color: var(--text-secondary); font-style: italic; }
        /* Messages */
        .success-message { color: green; background-color:#e8f5e9; padding:10px 15px; border:1px solid green; border-radius:4px; margin-bottom: 15px; font-weight: 500;}
        .error-message { color: red; background-color:#ffebee; padding:10px 15px; border:1px solid red; border-radius:4px; margin-bottom: 15px; font-weight: 500;}
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="page-header">
            <div>
                <h1>Manage All Sales</h1>
                <p class="subtitle">View and manage all customer orders</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">Back to Dashboard</a>
        </header>

        <div class="content-card">
            <c:if test="${not empty successMessage}"><p class="success-message">${successMessage}</p></c:if>
            <c:if test="${not empty errorMessage}"><p class="error-message">${errorMessage}</p></c:if>

            <div class="card-header-sales">
                <h2><i class="fas fa-receipt"></i> All Customer Orders</h2>
                <div class="search-sales">
                     <%-- <i class="fas fa-search search-icon"></i> --%>
                     <input type="search" id="salesSearchInput" placeholder="Search orders...">
                 </div>
            </div>

            <div class="table-wrapper">
                <table class="orders-table" id="salesTable">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>User ID</th>
                            <th>Date</th>
                            <th>Product(s)</th>
                            <th>Total Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty salesList}">
                                <c:forEach var="sale" items="${salesList}">
                                    <tr>
                                        <td data-label="Order ID:"><c:out value="${sale.orderId}"/></td>
                                        <td data-label="Customer:"><c:out value="${sale.customerUsername}"/></td>
                                        <td data-label="User ID:">${sale.userId}</td>
                                        <td data-label="Date:"><fmt:formatDate value="${sale.orderDateAsUtilDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td data-label="Product(s):"><c:out value="${sale.productName}"/></td>
                                        <td data-label="Total Price:"><fmt:formatNumber value="${sale.totalPrice}" type="currency" currencySymbol="$"/></td>
                                        <td data-label="Status:">
                                            <span class="status-badge status-${fn:toLowerCase(sale.status)}">
                                                <c:out value="${sale.status}"/>
                                            </span>
                                        </td>
                                        <td data-label="Actions:">
                                            <a href="#" class="action-btn view-details-btn">View</a>
                                            <%-- Form to Update Status --%>
                                            <form action="${pageContext.request.contextPath}/admin/manage-sales" method="post" style="display:inline-block; margin-top: 5px;">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderId" value="${sale.orderId}">
                                                <select name="newStatus" style="padding: 4px; font-size:0.8rem; margin-right:5px;">
                                                    <option value="Processing" ${sale.status == 'Processing' ? 'selected' : ''}>Processing</option>
                                                    <option value="Shipped" ${sale.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                                    <option value="Delivered" ${sale.status == 'Delivered' ? 'selected' : ''}>Delivered</option>
                                                    <option value="Completed" ${sale.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                    <option value="Cancelled" ${sale.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                </select>
                                                <button type="submit" class="action-btn update-status-btn" style="font-size:0.8rem; padding: 4px 8px;">Set</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr class="info-message-table"><td colspan="8">No sales records found.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>