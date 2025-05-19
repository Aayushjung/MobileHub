<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    // Security check
    Object userObjSession = session.getAttribute("user");
    String roleSession = (String) session.getAttribute("role");
    if (userObjSession == null || !"admin".equalsIgnoreCase(roleSession)) {
       session.setAttribute("errorMessage", "Admin access required. Please login with admin credentials.");
       response.sendRedirect(request.getContextPath() + "/login");
       return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MobileHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style type="text/css">
      
        .admin-main-content {
            padding: 20px;
            max-width: 1400px;
            margin: 20px auto; /* Space below navbar (if body padding-top is set) & centers */
        }

        .dash-header { margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        .dash-header h1 { font-size: 2em; margin-bottom: 5px; color: var(--text-primary, #333); }
        .dash-header p { font-size: 1em; color: var(--text-secondary, #666); }

        .error-message, .success-message { 
            padding: 10px 15px; margin-bottom: 20px; border-radius: 5px; font-size: 0.95em;
        }
        .error-message { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .success-message { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }

        /* Stats Grid - Simpler style from image */
        .stats-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px; margin-bottom: 40px;
        }
        .stat-card-alt {
            background-color: var(--card-bg, #fff); border-radius: 8px; padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.08); display: flex;
            align-items: center; gap: 15px;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .stat-card-alt:hover { transform: translateY(-4px); box-shadow: 0 4px 10px rgba(0,0,0,0.12); }
        
        /* Updated .stat-icon-alt styles */
        .stat-icon-alt {
            flex-shrink: 0;
            width: 40px;
            height: 40px;
            border-radius: 6px;
            display: flex; /* For centering the icon */
            align-items: center; /* For centering the icon */
            justify-content: center; /* For centering the icon */
        }
        .stat-icon-alt i { /* Style for Font Awesome icon */
            font-size: 1.5em; /* Adjust size as needed, e.g., 20px or 1.5em */
            color: #fff; /* White icon to contrast with background colors */
        }
        
        .stat-icon-alt.sales { background-color: var(--stat-green, #2ecc71); }
        .stat-icon-alt.orders { background-color: var(--stat-blue, #3498db); }
        .stat-icon-alt.customers { background-color: var(--stat-purple, #9b59b6); }
        .stat-icon-alt.products { background-color: var(--stat-red-icon, #e74c3c); }
        
        .stat-label-alt { font-size: 0.95em; font-weight: 500; color: var(--text-light, #555); }
        .stat-info-alt { display: flex; flex-direction: column; }
        .stat-value-alt { font-size: 1.6rem; font-weight: 600; color: var(--text-primary); line-height: 1.2; }


        /* Chart Placeholders */
        .charts-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .chart-card-alt { background-color: var(--card-bg, #fff); border-radius: 8px; padding: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.08); }
        .chart-header { margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #eee; }
        .chart-header .title { font-size: 1.2em; font-weight: 600; color: var(--text-primary); display: block; }
        .chart-header .subtitle { font-size: 0.8em; color: var(--text-secondary); display: block; margin-top: 3px; }
        .chart-placeholder-alt { min-height: 250px; display: flex; justify-content: center; align-items: center; color: #aaa; font-style: italic; background-color: #f8f9fa; border: 1px dashed #ddd; border-radius: 4px; }

        /* Recent Sales Card & Table Styles */
        .recent-sales-card {
            background-color: var(--card-bg, #fff); border-radius: 8px;
            padding: 20px 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-top: 30px;
        }
        .recent-sales-card h2 {
            font-size: 1.3rem; font-weight: 600; color: var(--text-primary);
            margin-bottom: 20px; padding-bottom: 10px;
            border-bottom: 1px solid var(--admin-border-color, #eee); /* Use admin border */
            display: flex; align-items: center; gap: 10px;
        }
        .recent-sales-card h2 .icon { font-size: 1.1em; color: var(--primary-purple, #7e57c2); }

        .sales-table-wrapper { overflow-x: auto; }
        .sales-table { width: 100%; border-collapse: collapse; }
        .sales-table th, .sales-table td {
            padding: 10px 12px; text-align: left;
            border-bottom: 1px solid var(--admin-border-color, #eee);
            font-size: 0.9rem; color: var(--text-light, #555);
        }
        .sales-table th {
            background-color: #f8f9fa; /* Lighter header */
            color: var(--text-primary, #333); font-weight: 600;
            text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px;
        }
        .sales-table tbody tr:hover { background-color: #f1f3f5; }
        /* Status Badges (should be globally defined in style.css) */
        .status-badge { display: inline-block; padding: 4px 10px; border-radius: 15px; font-size: 0.75rem; font-weight: 600; text-transform: capitalize; }
        .status-completed { background-color: #a5d6a7; color: #1b5e20;}
        .status-processing { background-color: #fff9c4; color: #f57f17;}
        .status-shipped { background-color: #bbdefb; color: #1565c0;}
        .status-delivered { background-color: #c8e6c9; color: #2e7d32;}
        .status-cancelled { background-color: #ffcdd2; color: #c62828;}
        .info-message-table td { text-align: center; padding: 20px; color: var(--text-secondary); font-style: italic; }

        @media (max-width: 768px) { /* Basic responsive adjustments */
            .admin-main-content { padding: 15px; margin: 15px auto; }
            .dash-header h1 { font-size: 1.8em; }
            .stats-grid { grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; }
            .charts-grid { grid-template-columns: 1fr; } /* Stack charts */
            .recent-sales-card { padding: 15px; }
            .recent-sales-card h2 { font-size: 1.2rem; }
            .sales-table th, .sales-table td { font-size: 0.85rem; padding: 8px; }
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    
    <main class="admin-main-content">
        <header class="dash-header">
            <h1>Admin Dashboard</h1>
            <p>Welcome back, <c:out value="${sessionScope.username}"/>! Here's an overview of your store performance.</p>
        </header>

        <c:if test="${not empty requestScope.dashboardErrorMessage}"><p class="error-message">${requestScope.dashboardErrorMessage}</p></c:if>

        <section class="stats-grid">
            <div class="stat-card-alt">
                <div class="stat-icon-alt sales">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="stat-info-alt">
                    <span class="stat-value-alt"><fmt:formatNumber value="${totalSales}" type="currency" currencySymbol="$" minFractionDigits="2" maxFractionDigits="2"/></span>
                    <span class="stat-label-alt">Total Sales</span>
                </div>
            </div>
            <div class="stat-card-alt">
                <div class="stat-icon-alt orders">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-info-alt">
                    <span class="stat-value-alt"><fmt:formatNumber value="${totalOrders}" type="number" groupingUsed="true"/></span>
                    <span class="stat-label-alt">Total Orders</span>
                </div>
            </div>
            <div class="stat-card-alt">
                <div class="stat-icon-alt customers">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-info-alt">
                    <span class="stat-value-alt"><fmt:formatNumber value="${totalCustomers}" type="number" groupingUsed="true"/></span>
                    <span class="stat-label-alt">Total Customers</span>
                </div>
            </div>
            <div class="stat-card-alt">
                <div class="stat-icon-alt products">
                     <i class="fas fa-boxes-stacked"></i>
                </div>
                <div class="stat-info-alt">
                    <span class="stat-value-alt"><fmt:formatNumber value="${totalProducts}" type="number" groupingUsed="true"/></span>
                    <span class="stat-label-alt">Total Products</span>
                </div>
            </div>
        </section>

       

        <%-- Recent Sales Section --%>
        <section class="recent-sales-card">
            <h2><i class="fas fa-history icon"></i> Recent Sales</h2>
            <div class="sales-table-wrapper">
                <table class="sales-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th style="text-align:right;">Total</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty recentSalesList}">
                                <c:forEach var="sale" items="${recentSalesList}">
                                    <tr>
                                        <td><c:out value="${sale.orderId}"/></td>
                                        <td><c:out value="${sale.customerUsername}"/></td>
                                        <td><fmt:formatDate value="${sale.orderDateAsUtilDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${sale.totalPrice}" type="currency" currencySymbol="$"/></td>
                                        <td>
                                            <span class="status-badge status-${fn:toLowerCase(sale.status)}">
                                                <c:out value="${sale.status}"/>
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="5" class="info-message-table">No recent sales activity found.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

    </main>
</body>
</html>