<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Security check (Ideally in a Filter)
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
    <%-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"> --%>

    <style>
        /* --- === Basic Setup & Theme Variables (User Dash Theme) === --- */
        :root {
            /* Using User Dashboard Colors */
            --sidebar-bg: #ffffff; /* White sidebar */
            --sidebar-width: 260px;
            --content-bg: #f4f0f9; /* Light lavender background */
            --card-bg: #ffffff; /* White Cards */
            --header-bg: #ede7f6; /* Very light lavender header for top bar if needed */
            --primary-purple: #7e57c2; /* Main purple accent */
            --primary-purple-dark: #673ab7;
            --text-primary: #333; /* Darker text for content */
            --text-secondary: #666; /* Grey text */
            --sidebar-text: #444; /* Darker text for white sidebar */
            --sidebar-text-hover: var(--primary-purple); /* Purple on hover */
            --sidebar-title-color: #777; /* Muted title in sidebar */
            --sidebar-hover-bg: #f0eef6; /* Light lavender hover bg */
            --sidebar-active-border: var(--primary-purple); /* Purple active indicator */
            --accent-red: #e74c3c; /* Logout button */
            --accent-red-dark: #c0392b;
            --stat-green: #2ecc71; /* Keep distinct stat colors */
            --stat-blue: #3498db;
            --stat-purple: #9b59b6;
            --stat-red-icon: #e74c3c; /* Renamed to avoid conflict */
            --shadow-color: rgba(126, 87, 194, 0.15); /* Shadow based on purple */
            --border-color: #e0e0e0; /* Light border for cards/sidebar */
            --sidebar-border: #e0e0e0; /* Light border within sidebar */
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { font-size: 16px; scroll-behavior: smooth; }
        body {
            font-family: 'Poppins', sans-serif; font-weight: 400; line-height: 1.6;
            color: var(--text-primary);
            background-color: var(--content-bg); /* Body uses light lavender */
            margin: 0;
            display: flex;
            min-height: 100vh;
        }

        /* --- === Layout Container (Sidebar + Main Content) === --- */
        .admin-layout-container { display: flex; width: 100%; }

        /* --- === Sidebar Navigation (White Background) === --- */
        .admin-sidebar {
            width: var(--sidebar-width); flex-shrink: 0; background-color: var(--sidebar-bg);
            color: var(--sidebar-text); padding: 25px 0; height: 100vh; position: sticky;
            top: 0; display: flex; flex-direction: column; overflow-y: auto;
            border-right: 1px solid var(--sidebar-border); /* Add right border */
        }
        .sidebar-logo {
            text-align: left; padding: 0 25px 25px 25px; margin-bottom: 20px;
            border-bottom: 1px solid var(--sidebar-border);
        }
        .sidebar-logo a {
            color: var(--primary-purple); /* Logo uses theme color */
            font-size: 1.6rem; font-weight: 600; text-decoration: none;
        }
        .admin-sidebar h2 { /* "ADMIN TOOLS" Title */
             padding: 0 25px; margin-bottom: 15px; font-size: 0.8rem;
             font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px;
             color: var(--sidebar-title-color);
        }
        .admin-actions-list { list-style: none; padding: 0; flex-grow: 1; }
        .admin-actions-list li a {
            color: var(--sidebar-text); text-decoration: none; font-weight: 500; /* Slightly bolder */
            font-size: 0.95rem; display: block; padding: 12px 25px; /* Adjusted padding */
            border-left: 4px solid transparent;
            transition: color 0.2s, background-color 0.2s, border-color 0.2s;
        }
         .admin-actions-list li a:hover {
             color: var(--sidebar-text-hover); background-color: var(--sidebar-hover-bg);
             /* border-left-color: var(--sidebar-active-border); */ /* Only on active? */
         }
         /* Active state styling */
         .admin-actions-list li.active a {
            color: var(--sidebar-text-hover); background-color: var(--sidebar-hover-bg);
            border-left-color: var(--sidebar-active-border); font-weight: 600;
         }
        .sidebar-logout {
             margin-top: auto; padding: 20px 25px;
             border-top: 1px solid var(--sidebar-border); /* Border top */
        }
        .logout-btn {
            display: block; width: 100%; padding: 10px 15px; font-size: 0.9rem;
            color: #fff; background-color: var(--accent-red); border: none;
            border-radius: 6px; text-decoration: none; cursor: pointer; text-align: center;
            transition: background-color 0.2s; font-weight: 500;
        }
        .logout-btn:hover { background-color: var(--accent-red-dark); }

        /* --- === Main Content Area (Light Lavender Background) === --- */
        .admin-main-content { flex-grow: 1; padding: 40px; overflow-y: auto; height: 100vh; }

        /* --- Dashboard Header --- */
        .dash-header { margin-bottom: 35px; }
        .dash-header h1 { font-size: 1.8rem; font-weight: 600; color: var(--text-primary); margin-bottom: 5px; }
        .dash-header p { font-size: 1rem; color: var(--text-secondary); font-weight: 300; }

        /* --- Stats Grid & Cards (Simple Style, White Background) --- */
        .stats-grid { display: grid; gap: 25px; margin-bottom: 35px; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); }
        .stat-card-alt {
            background-color: var(--card-bg); padding: 20px; border-radius: 10px;
            box-shadow: 0 4px 15px var(--shadow-color); border: 1px solid var(--border-color);
            display: flex; align-items: center; gap: 15px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .stat-card-alt:hover { transform: translateY(-3px); box-shadow: 0 6px 20px var(--shadow-color); }
        .stat-icon-alt { width: 45px; height: 45px; border-radius: 8px; flex-shrink: 0; }
        .stat-icon-alt.sales { background-color: var(--stat-green); }
        .stat-icon-alt.orders { background-color: var(--stat-blue); }
        .stat-icon-alt.customers { background-color: var(--stat-purple); }
        .stat-icon-alt.products { background-color: var(--stat-red-icon); }
        .stat-label-alt { font-size: 0.95rem; font-weight: 500; color: var(--text-primary); }

        /* --- Charts Grid & Cards (White Background) --- */
        .charts-grid { display: grid; gap: 25px; margin-bottom: 35px; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); }
        .chart-card-alt { background-color: var(--card-bg); padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px var(--shadow-color); border: 1px solid var(--border-color); }
        .chart-header { margin-bottom: 20px; }
        .chart-header .title { font-size: 1.2rem; font-weight: 600; color: var(--text-primary); }
        .chart-header .subtitle { font-size: 0.9rem; color: var(--text-secondary); font-weight: 300; }
        .chart-placeholder-alt { min-height: 280px; display: flex; align-items: center; justify-content: center; color: var(--text-secondary); background-color: #f9f9fb; border: 1px dashed #e0e0e0; border-radius: 8px; font-style: italic; }

        /* --- Responsiveness --- */
        @media (max-width: 992px) {
             .admin-sidebar { display: none; }
             .admin-main-content { width: 100%; }
        }
        @media (max-width: 768px) {
            .admin-main-content { padding: 25px; }
             .stats-grid { grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 20px; }
             .dash-header h1 { font-size: 1.6rem; }
             .chart-card-alt { padding: 20px; }
             .chart-header .title { font-size: 1.1rem; }
        }
         @media (max-width: 480px) {
            .admin-main-content { padding: 20px; }
            .stats-grid { grid-template-columns: 1fr; }
         }

    </style>
</head>
<body>
    <div class="admin-layout-container">

        <%-- Sidebar Navigation (Now White) --%>
        <aside class="admin-sidebar">
            <div class="sidebar-logo">
                 <%-- Logo text color changed --%>
                <a href="${pageContext.request.contextPath}/admin/dashboard">MobileHub</a>
            </div>

             <h2>ADMIN TOOLS</h2>
             <ul class="admin-actions-list">
                  <li><a href="${pageContext.request.contextPath}/admin/manage-users">Manage Users</a></li>
                  <li><a href="#">Manage Products</a></li>
                  <li><a href="#">View Reports</a></li>
                  <li><a href="#">Site Settings</a></li>
             </ul>

            <div class="sidebar-logout">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
            </div>
        </aside>

        <%-- Main Content Area (Light Lavender Background) --%>
        <main class="admin-main-content">
            <header class="dash-header">
                <h1>Admin Dashboard</h1>
                <p>Welcome back, <c:out value="${sessionScope.username}"/>! Here's an overview of your store performance.</p>
            </header>

            <%-- Messages --%>
            <c:if test="${not empty requestScope.dashboardErrorMessage}">
                <p style="color: red; margin-bottom: 15px; font-weight: 500; background-color:#ffebee; padding:10px; border:1px solid red; border-radius:4px;">${requestScope.dashboardErrorMessage}</p>
            </c:if>
             <c:if test="${not empty requestScope.successMessage}">
                <p style="color: green; margin-bottom: 15px; font-weight: 500; background-color:#e8f5e9; padding:10px; border:1px solid green; border-radius:4px;">${requestScope.successMessage}</p>
            </c:if>

            <%-- Stats Grid --%>
            <section class="stats-grid">
                <div class="stat-card-alt">
                    <div class="stat-icon-alt sales"></div> <span class="stat-label-alt">Total Sales</span>
                </div>
                 <div class="stat-card-alt">
                    <div class="stat-icon-alt orders"></div> <span class="stat-label-alt">Total Orders</span>
                </div>
                 <div class="stat-card-alt">
                    <div class="stat-icon-alt customers"></div> <span class="stat-label-alt">New Customers</span>
                </div>
                 <div class="stat-card-alt">
                    <div class="stat-icon-alt products"></div> <span class="stat-label-alt">Active Products</span>
                </div>
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