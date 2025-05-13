<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Security check
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (user == null || !"admin".equalsIgnoreCase(role)) {
       session.setAttribute("errorMessage", "Admin access required. Please login first.");
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

    <%-- Styles for Admin Dashboard Layout (can be in style.css) --%>
    <style>
        /* Ensure :root variables for admin theme are in your style.css */
        /* body already has padding-top for fixed navbar from style.css */

        .admin-layout-container {
            display: flex;
            width: 100%;
            /* Calculate height below fixed navbar, assuming navbar height is 70px */
            min-height: calc(100vh - 70px);
            position: relative; /* To position sidebar absolutely if needed for mobile */
        }

        .admin-sidebar {
            width: 260px; /* Use var(--admin-sidebar-width) if defined */
            flex-shrink: 0;
            background-color: var(--admin-sidebar-bg, #2c3e50); /* Dark sidebar */
            color: var(--admin-sidebar-text, #ecf0f1);
            padding: 25px 0;
            display: flex;
            flex-direction: column;
            /* If the top navbar is fixed, and this sidebar should also be fixed */
            /* position: fixed; top: 70px; left: 0; height: calc(100vh - 70px); */
            /* OR if it scrolls with page but is part of flex layout: */
            height: auto; /* Let flex container manage height */
        }

        .sidebar-logo { /* This is for the logo INSIDE the admin sidebar */
            text-align: left;
            padding: 0 25px 25px 25px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--admin-sidebar-border, #3a5064);
        }
        .sidebar-logo a { /* Logo text inside admin sidebar */
            color: #fff; /* White text for dark sidebar */
            font-size: 1.6rem;
            font-weight: 600;
            text-decoration: none;
        }

        .admin-sidebar h2 { /* "ADMIN TOOLS" Title */
             padding: 0 25px; margin-bottom: 15px; font-size: 0.8rem;
             font-weight: 500; text-transform: uppercase; letter-spacing: 0.8px;
             color: var(--admin-sidebar-title-color, #95a5a6);
        }
        .admin-actions-list { list-style: none; padding: 0; flex-grow: 1; }
        .admin-actions-list li a {
            color: var(--admin-sidebar-text, #ecf0f1); text-decoration: none; font-weight: 400;
            font-size: 0.95rem; display: block; padding: 11px 25px;
            border-left: 4px solid transparent;
            transition: color 0.2s, background-color 0.2s, border-color 0.2s;
        }
         .admin-actions-list li a:hover {
             color: var(--admin-sidebar-text-hover, #ffffff);
             background-color: var(--admin-sidebar-hover-bg, rgba(236, 240, 241, 0.08));
         }
         .admin-actions-list li.active a {
            color: var(--admin-sidebar-text-hover, #ffffff);
            background-color: var(--admin-sidebar-hover-bg, rgba(236, 240, 241, 0.08));
            border-left-color: var(--admin-sidebar-active-border, #e74c3c);
            font-weight: 500;
         }

        .sidebar-logout { margin-top: auto; padding: 20px 25px; }
        .logout-btn-sidebar {
            display: block; width: 100%; padding: 10px 15px; font-size: 0.9rem;
            color: #fff; background-color: var(--accent-red, #e74c3c); border: none;
            border-radius: 6px; text-decoration: none; cursor: pointer; text-align: center;
            transition: background-color 0.2s; font-weight: 500;
        }
        .logout-btn-sidebar:hover { background-color: var(--accent-red-dark, #c0392b); }

        .admin-main-content {
            flex-grow: 1; padding: 40px; overflow-y: auto;
            background-color: var(--admin-content-bg, #ecf0f1);
            color: var(--text-primary, #2c3e50);
            /* Ensure it can scroll if content is taller than sidebar area */
             min-height: calc(100vh - 70px); /* If top navbar is fixed */
        }
        /* ... other admin content styles (dash-header, stats-grid, etc.) remain the same ... */
        .admin-main-content .dash-header { margin-bottom: 35px; }
        .admin-main-content .dash-header h1 { font-size: 1.8rem; font-weight: 600; color: var(--text-primary); margin-bottom: 5px; }
        .admin-main-content .dash-header p { font-size: 1rem; color: var(--text-secondary); font-weight: 300; }
        .admin-main-content .stats-grid { display: grid; gap: 25px; margin-bottom: 35px; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); }
        .admin-main-content .stat-card-alt { background-color: var(--card-bg); padding: 20px; border-radius: 10px; box-shadow: 0 4px 15px var(--admin-card-shadow); border: 1px solid var(--admin-border-color); display: flex; align-items: center; gap: 15px; transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .admin-main-content .stat-card-alt:hover { transform: translateY(-3px); box-shadow: 0 6px 20px var(--admin-card-shadow); }
        .admin-main-content .stat-icon-alt { width: 45px; height: 45px; border-radius: 8px; flex-shrink: 0; }
        .admin-main-content .stat-icon-alt.sales { background-color: var(--stat-green); }
        .admin-main-content .stat-icon-alt.orders { background-color: var(--stat-blue); }
        .admin-main-content .stat-icon-alt.customers { background-color: var(--stat-purple); }
        .admin-main-content .stat-icon-alt.products { background-color: var(--stat-red); }
        .admin-main-content .stat-label-alt { font-size: 0.95rem; font-weight: 500; color: var(--text-primary); }
        .admin-main-content .charts-grid { display: grid; gap: 25px; margin-bottom: 35px; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); }
        .admin-main-content .chart-card-alt { background-color: var(--card-bg); padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px var(--admin-card-shadow); border: 1px solid var(--admin-border-color); }
        .admin-main-content .chart-header .title { color: var(--text-primary); font-size: 1.2rem; font-weight: 600; margin-bottom:5px; }
        .admin-main-content .chart-header .subtitle { color: var(--text-secondary); font-size: 0.9rem; font-weight: 300; }
        .admin-main-content .chart-placeholder-alt { background-color: #fdfdfd; border: 1px dashed #e0e0e0; color: var(--text-secondary); min-height: 280px; display: flex; align-items: center; justify-content: center; border-radius: 8px; font-style: italic; }

        /* Responsiveness for sidebar (basic hide on small screens) */
        @media (max-width: 992px) {
             .admin-sidebar {
                 display: none; /* Simplest: hide. For hamburger, need JS & different CSS */
             }
             .admin-main-content {
                 width: 100%; /* Take full width when sidebar is hidden */
             }
        }
    </style>
</head>
<body>

    <%-- This is your TOP GLOBAL NAVBAR (e.g., for Home, Shop, User Profile, Logout) --%>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <%-- This is the Admin Dashboard specific layout --%>
    <div class="admin-layout-container">

       

        <%-- Main Admin Content Area --%>
        <main class="admin-main-content">
            <header class="dash-header">
                <h1>Admin Dashboard</h1>
                <p>Welcome back, <c:out value="${sessionScope.username}"/>! Here's an overview of your store performance.</p>
            </header>

            <%-- Display Messages --%>
            <c:if test="${not empty requestScope.dashboardErrorMessage}"><p class="error-message">${requestScope.dashboardErrorMessage}</p></c:if>
            <c:if test="${not empty requestScope.successMessage}"><p class="success-message">${requestScope.successMessage}</p></c:if>

            <%-- Stats Grid --%>
            <section class="stats-grid">
                <div class="stat-card-alt"><div class="stat-icon-alt sales"></div><span class="stat-label-alt">Total Sales</span></div>
                <div class="stat-card-alt"><div class="stat-icon-alt orders"></div><span class="stat-label-alt">Total Orders</span></div>
                <div class="stat-card-alt"><div class="stat-icon-alt customers"></div><span class="stat-label-alt">New Customers</span></div>
                <div class="stat-card-alt"><div class="stat-icon-alt products"></div><span class="stat-label-alt">Active Products</span></div>
            </section>

            <%-- Charts Grid --%>
            <section class="charts-grid">
                <div class="chart-card-alt">
                    <div class="chart-header"><span class="title">Monthly Sales</span><span class="subtitle">Performance over the last 7 months</span></div>
                    <div class="chart-placeholder-alt">${monthlySalesData}</div>
                </div>
                <div class="chart-card-alt">
                     <div class="chart-header"><span class="title">Weekly Visitors</span><span class="subtitle">User traffic for the past week</span></div>
                     <div class="chart-placeholder-alt">${weeklyVisitorData}</div>
                </div>
            </section>

        </main>

    </div>

</body>
</html>