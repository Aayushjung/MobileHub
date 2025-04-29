<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Basic login check - backup
    if (session.getAttribute("user") == null || !"customer".equalsIgnoreCase((String) session.getAttribute("role"))) {
       session.setAttribute("errorMessage", "Please login first.");
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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%-- Link to your main CSS file containing navbar and these styles --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <%-- Optional: Font Awesome for icons --%>
    <%-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"> --%>

    <style>
        /* Styles for Orders Page - Add to style.css ideally */
        /* Re-use variables from :root in style.css */
        body {
            padding-top: 70px; /* Adjust if needed for fixed navbar */
            background-color: var(--dash-bg, #f4f0f9);
            font-family: 'Poppins', sans-serif;
        }
        .page-container {
            max-width: 1200px; /* Adjust as needed */
            margin: 30px auto; /* Add top/bottom margin */
            padding: 0 20px; /* Side padding */
        }
        .orders-header { margin-bottom: 25px; }
        .orders-header h1 {
            font-size: 2rem; font-weight: 600; color: var(--text-primary, #333);
            margin-bottom: 4px;
        }
        .orders-header p { color: var(--text-secondary, #666); font-size: 1rem; }

        .order-history-card {
            background-color: var(--card-bg, #fff);
            border-radius: 12px;
            padding: 25px 30px;
            box-shadow: 0 5px 20px var(--card-shadow, rgba(126, 87, 194, 0.1));
            border: 1px solid var(--border-color, #e0e0e0);
            overflow: hidden; /* Needed if table overflows */
        }
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--border-color, #e0e0e0);
        }
        .card-header h2 {
            font-size: 1.3rem; font-weight: 600; color: var(--text-primary, #333);
            display: flex; align-items: center; gap: 10px;
        }
        .card-header h2 .icon { /* Placeholder for icon styling */ color: var(--primary-purple, #7e57c2); }
        .search-orders { position: relative; }
        .search-orders input {
            padding: 8px 15px 8px 35px; /* Space for icon */
            border-radius: 20px; border: 1px solid var(--border-color, #e0e0e0);
            min-width: 250px; font-size: 0.9rem;
        }
        .search-orders .search-icon { /* Placeholder */ position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #aaa; }

        .orders-table-wrapper { overflow-x: auto; /* Allow horizontal scroll on small screens */ }
        .orders-table {
            width: 100%;
            border-collapse: collapse;
        }
        .orders-table th, .orders-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color, #e0e0e0);
            white-space: nowrap; /* Prevent wrapping initially */
        }
        .orders-table th {
            background-color: var(--primary-purple-dark, #673ab7);
            color: var(--table-header-text, #fff);
            font-size: 0.9rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;
        }
        /* First and last header cells */
        .orders-table th:first-child { border-radius: 8px 0 0 0; }
        .orders-table th:last-child { border-radius: 0 8px 0 0; text-align: right; }
         /* Last data cell */
        .orders-table td:last-child { text-align: right; }
        /* Alternating row colors (optional) */
        .orders-table tbody tr:nth-child(even) { background-color: #fdfaff; } /* Very light lavender */

        .status-badge {
            display: inline-block; padding: 4px 10px; border-radius: 15px;
            font-size: 0.8rem; font-weight: 500; text-transform: capitalize;
        }
        /* Status Badge Colors */
        .status-delivered { background-color: #c8e6c9; color: #2e7d32; } /* Green */
        .status-shipped { background-color: #bbdefb; color: #1565c0; } /* Blue */
        .status-processing { background-color: #fff9c4; color: #f9a825; } /* Yellow */
        .status-pending { background-color: #ffe0b2; color: #ef6c00; } /* Orange */
        .status-cancelled { background-color: #ffcdd2; color: #c62828; } /* Red */

        .details-btn {
            padding: 6px 14px; background-color: var(--button-bg, #7e57c2); color: var(--button-text, #fff);
            border: none; border-radius: 5px; text-decoration: none; font-size: 0.85rem;
            font-weight: 500; cursor: pointer; transition: background-color 0.2s;
            white-space: nowrap;
        }
        .details-btn:hover { background-color: var(--button-hover-bg, #673ab7); }
         .info-message { color: var(--text-secondary); font-style: italic; padding: 20px 0; text-align: center;}

        /* --- Responsive --- */
        @media (max-width: 768px) {
             .page-container { padding: 0 15px; margin-top: 20px; }
             .orders-header h1 { font-size: 1.6rem; }
             .order-history-card { padding: 20px; }
             .card-header { flex-direction: column; align-items: flex-start; gap: 15px; }
             .search-orders { width: 100%; }
             .search-orders input { width: 100%; }
             .orders-table th, .orders-table td { padding: 10px 8px; font-size: 0.9rem;}
        }
        @media (max-width: 480px) {
             .orders-table th, .orders-table td { font-size: 0.85rem; }
             .status-badge { padding: 3px 8px; font-size: 0.75rem; }
             .details-btn { padding: 5px 10px; font-size: 0.8rem; }
        }

    </style>
</head>
<body>

    <%-- Include Standard Navbar --%>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="orders-header">
            <h1>My Orders</h1>
            <p>Track and manage your orders</p>
        </header>

        <div class="order-history-card">
             <div class="card-header">
                <h2><span class="icon"></span> Order History</h2> <%-- Basic icon --%>
                 <div class="search-orders">
                     <span class="search-icon"></span> <%-- Basic icon --%>
                     <input type="search" placeholder="Search orders...">
                     <%-- Search functionality requires JS/backend logic --%>
                 </div>
             </div>

             <c:if test="${not empty requestScope.pageErrorMessage}">
                <p class="error-message">${requestScope.pageErrorMessage}</p>
             </c:if>

             <div class="orders-table-wrapper">
                 <table class="orders-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Date</th>
                            <th>Product</th> <%-- Simplified view --%>
                            <th>Price</th>
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
                                        <td>
                                            <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd"/>
                                             <%-- If using java.util.Date: <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd"/> --%>
                                        </td>
                                        <td><c:out value="${order.productName}"/></td>
                                        <td><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="$"/></td>
                                        <td>
                                            <span class="status-badge status-${order.status.toLowerCase()}">
                                                <c:out value="${order.status}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <%-- Link to a future Order Detail page/servlet --%>
                                            <a href="#" class="details-btn">View Details</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                             </c:when>
                             <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 20px;">You haven't placed any orders yet.</td>
                                </tr>
                             </c:otherwise>
                        </c:choose>
                    </tbody>
                 </table>
            </div> <%-- End orders-table-wrapper --%>

        </div> <%-- End order-history-card --%>

    </div> <%-- End Page Container --%>

</body>
</html>