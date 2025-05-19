<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    // Security check
    Object userSessionObj = session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");
    if (userSessionObj == null || !"customer".equalsIgnoreCase(userRole)) {
       session.setAttribute("errorMessage", "Please login as a customer to view your orders.");
       response.sendRedirect(request.getContextPath() + "/login");
       return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - MobileHub</title>
    <!-- Added Google Fonts for Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
       

        .page-container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .orders-header { margin-bottom: 25px; }
        
       
        .orders-header h1 { 
            font-size: 2em; 
            font-weight: bold;
            color: var(--text-primary, #333); 
            margin-bottom: 5px; 
        }
        .orders-header p { color: var(--text-secondary, #666); font-size: 1rem; }

        .order-history-card { background-color: var(--card-bg, #fff); border-radius: 12px; padding: 25px 30px; box-shadow: 0 5px 20px var(--card-shadow, rgba(126, 87, 194, 0.1)); border: 1px solid var(--border-color, #e0e0e0); overflow: hidden; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid var(--border-color, #e0e0e0); }
        .card-header h2 { font-size: 1.3rem; font-weight: 600; color: var(--text-primary, #333); display: flex; align-items: center; gap: 10px; }
        .card-header h2 .icon { /* Simple box from reference */ display: inline-block; width: 0.8em; height: 0.8em; border: 2px solid var(--primary-purple, #7e57c2); margin-right: 8px; }
        .search-orders { position: relative; }
        .search-orders input[type="search"] { padding: 8px 15px 8px 35px; border-radius: 20px; border: 1px solid var(--border-color, #e0e0e0); min-width: 250px; font-size: 0.9rem; font-family: 'Poppins', sans-serif; }
        .search-orders .search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #aaa; }

        .orders-table-wrapper { overflow-x: auto; }
        .orders-table { width: 100%; border-collapse: collapse; }
        .orders-table th, .orders-table td { padding: 12px 15px; text-align: left; border-bottom: 1px solid var(--border-color, #e0e0e0); white-space: nowrap; font-size: 0.95rem; color: var(--text-light, #555); }
        .orders-table th { background-color: var(--primary-purple-dark, #673ab7); color: #fff; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .orders-table th:first-child { border-top-left-radius: 8px; }
        .orders-table th:last-child { border-top-right-radius: 8px; text-align: center; }
        .orders-table td:last-child { text-align: center; }
        /* .orders-table tbody tr:nth-child(even) { background-color: #fdfaff; } */

        .status-badge { display: inline-block; padding: 5px 12px; border-radius: 15px; font-size: 0.75rem; font-weight: 600; text-transform: capitalize; border: 1px solid transparent; }
        .status-delivered { background-color: #c8e6c9; color: #2e7d32; border-color: #a5d6a7;}
        .status-shipped { background-color: #bbdefb; color: #1565c0; border-color: #90caf9;}
        .status-processing { background-color: #fffde7; color: #f57f17; border-color: #fff59d;}
        .status-completed { background-color: #a5d6a7; color: #1b5e20; border-color: #81c784; }
        .status-cancelled { background-color: #ffebee; color: #d32f2f; border-color: #ef9a9a; }

        .details-btn { padding: 7px 18px; background-color: var(--primary-purple, #7e57c2); color: #ffffff; border: none; border-radius: 6px; text-decoration: none; font-size: 0.85rem; font-weight: 500; cursor: pointer; transition: background-color 0.2s; }
        .details-btn:hover { background-color: var(--primary-purple-dark, #673ab7); }
        /* Global message styles should be in style.css */
        .success-message { color: green; background-color:#e8f5e9; padding:10px 15px; border:1px solid green; border-radius:4px; margin-bottom: 15px; font-weight: 500;}
        .error-message { color: red; background-color:#ffebee; padding:10px 15px; border:1px solid red; border-radius:4px; margin-bottom: 15px; font-weight: 500;}
        .info-message-table td { text-align: center; padding: 20px; color: var(--text-secondary); font-style: italic; }

        /* For no results message during search */
        .no-results-row td {
            text-align: center;
            padding: 20px;
            color: var(--text-secondary);
            font-style: italic;
            display: none; /* Hidden by default */
        }

        @media (max-width: 768px) {  }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="orders-header">
            <h1>My Orders</h1>
            <p>Track and manage your orders</p>
        </header>

        <c:if test="${not empty requestScope.pageSuccessMessage}"><p class="success-message">${requestScope.pageSuccessMessage}</p></c:if>
        <c:if test="${not empty requestScope.pageErrorMessage}"><p class="error-message">${requestScope.pageErrorMessage}</p></c:if>

        <div class="order-history-card">
             <div class="card-header">
                <h2><span class="icon"></span> Order History</h2>
                 <div class="search-orders">
                     <%-- Using Font Awesome search icon --%>
                     <i class="fas fa-search search-icon"></i>
                     <input type="search" id="orderSearchInput" placeholder="Search orders by ID, Product...">
                 </div>
             </div>

             <div class="orders-table-wrapper">
                 <table class="orders-table" id="ordersTable">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Date</th>
                            <th>Product(s)</th>
                            <th>Total Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                             <c:when test="${not empty orderList}">
                                <c:forEach var="order" items="${orderList}">
                                    <tr>
                                        <td><c:out value="${order.orderId}"/></td>
                                        <td><fmt:formatDate value="${order.orderDateAsUtilDate}" pattern="MMM dd, yyyy"/></td>
                                        <td><c:out value="${order.productName}"/></td>
                                        <td><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="$"/></td>
                                        <td>
                                            <span class="status-badge status-${fn:toLowerCase(order.status)}">
                                                <c:out value="${order.status}"/>
                                            </span>
                                        </td>
                                        <td><a href="#" class="details-btn">View Details</a></td>
                                    </tr>
                                </c:forEach>
                             </c:when>
                             <c:otherwise>
                                <tr class="info-message-table"><td colspan="6">You haven't placed any orders yet. <a href="${pageContext.request.contextPath}/products">Start Shopping!</a></td></tr>
                             </c:otherwise>
                        </c:choose>
                        <%-- Row to display when no search results are found --%>
                        <tr class="no-results-row" style="display: none;">
                            <td colspan="6">No orders match your search criteria.</td>
                        </tr>
                    </tbody>
                 </table>
            </div>
        </div>
    </div>

    <%-- ****** JAVASCRIPT FOR SEARCH FUNCTIONALITY ****** --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('orderSearchInput');
            const ordersTable = document.getElementById('ordersTable');
            const tableBody = ordersTable ? ordersTable.getElementsByTagName('tbody')[0] : null;
            const noResultsRow = ordersTable ? ordersTable.querySelector('.no-results-row') : null;
            const infoMessageRow = ordersTable ? ordersTable.querySelector('.info-message-table') : null; // Row for "You haven't placed any orders yet"

            if (searchInput && tableBody && noResultsRow) {
                searchInput.addEventListener('keyup', function() {
                    const filterText = searchInput.value.toLowerCase().trim();
                    const rows = tableBody.getElementsByTagName('tr');
                    let visibleRowCount = 0;

                    for (let i = 0; i < rows.length; i++) {
                        // Skip the special message rows during filtering logic
                        if (rows[i].classList.contains('no-results-row') || rows[i].classList.contains('info-message-table')) {
                            continue;
                        }

                        let rowTextContent = '';
                        // Consider which columns to search (e.g., Order ID, Product Name, Status)
                        // For simplicity, searching all visible text content in the row
                        const cells = rows[i].getElementsByTagName('td');
                        for (let j = 0; j < cells.length -1; j++) { // Exclude "Actions" cell from search text
                            rowTextContent += cells[j].textContent.toLowerCase() + ' ';
                        }

                        if (rowTextContent.includes(filterText)) {
                            rows[i].style.display = ""; // Show row
                            visibleRowCount++;
                        } else {
                            rows[i].style.display = "none"; // Hide row
                        }
                    }

                    // Show/hide the "no results" message
                    if (visibleRowCount === 0 && filterText !== "") { // Only show if actively searching and no results
                        noResultsRow.style.display = "table-row";
                        if(infoMessageRow) infoMessageRow.style.display = "none"; // Hide initial "no orders" message
                    } else {
                        noResultsRow.style.display = "none";
                        // If search is cleared and there were no orders initially, show that message
                        if (filterText === "" && infoMessageRow && tableBody.querySelectorAll('tr:not(.no-results-row):not(.info-message-table)').length === 0) {
                           if(infoMessageRow) infoMessageRow.style.display = "table-row";
                        }
                    }
                     // If search is cleared and there ARE orders, hide "no initial orders" message
                     if (filterText === "" && infoMessageRow && tableBody.querySelectorAll('tr:not(.no-results-row):not(.info-message-table)[style*="display: table-row"], tr:not(.no-results-row):not(.info-message-table):not([style])').length > 0) {
                        if(infoMessageRow) infoMessageRow.style.display = "none";
                    }

                });
            } else {
                if (!searchInput) console.error("Search input not found");
                if (!tableBody) console.error("Table body not found");
                if (!noResultsRow) console.error("No results row not found");
            }
        });
    </script>
    <%-- **************************************************** --%>

</body>
</html>