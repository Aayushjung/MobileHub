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
    // Retrieve profile data set by servlet
    // Note: JSTL EL (${userProfile}) is preferred over scriptlets here
    // com.mobilehub.model.User userProfile = (com.mobilehub.model.User) request.getAttribute("userProfile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - MobileHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <%-- Font Awesome for Icons (Optional but recommended for reference look) --%>
    <%-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"> --%>

    <style>
        /* Styles for Profile Page - Add to style.css ideally */
        /* --- Theme Variables (Ensure these are defined in style.css) --- */
        :root {
            --dash-bg: #f4f0f9; --content-bg: #ffffff;
            --header-bg: #ede7f6; --primary-purple: #7e57c2; --primary-purple-dark: #673ab7;
            --text-primary: #333; --text-secondary: #666; --text-light: #555;
            --card-shadow: rgba(126, 87, 194, 0.1); --border-color: #e0e0e0;
             --button-bg: var(--primary-purple); --button-text: #fff;
             --button-hover-bg: var(--primary-purple-dark);
             --profile-sidebar-bg: #fff; /* White sidebar card */
             --profile-info-bg: #fff;   /* White info card */
             --profile-info-field-bg: #f8f6fc; /* Very light bg for fields */
        }
        body {
            padding-top: 70px; /* Adjust if needed for fixed navbar */
            background-color: var(--dash-bg);
            font-family: 'Poppins', sans-serif; color: var(--text-primary);
        }
        .page-container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .profile-header { margin-bottom: 25px; }
        .profile-header h1 { font-size: 2rem; font-weight: 600; margin-bottom: 4px; }
        .profile-header p { color: var(--text-secondary); font-size: 1rem; }

        .profile-layout {
            display: grid;
            grid-template-columns: 300px 1fr; /* Sidebar fixed width, content takes rest */
            gap: 30px;
            align-items: flex-start; /* Align cards top */
        }

        /* --- Profile Sidebar Card --- */
        .profile-sidebar-card {
            background-color: var(--profile-sidebar-bg);
            border-radius: 12px; padding: 30px;
            box-shadow: 0 5px 15px var(--card-shadow); border: 1px solid var(--border-color);
            text-align: center; position: sticky; top: 90px; /* Sticky below navbar */
        }
        .profile-avatar img {
            width: 120px; height: 120px; border-radius: 50%; object-fit: cover;
            margin-bottom: 15px; border: 3px solid var(--header-bg);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .profile-sidebar-card h2 { /* User Name */
             font-size: 1.3rem; font-weight: 600; margin-bottom: 5px; color: var(--text-primary);
        }
        .profile-sidebar-card .member-since {
            font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 25px;
        }
        .profile-sidebar-nav ul { list-style: none; padding: 0; margin: 0; }
        .profile-sidebar-nav li { margin-bottom: 5px; }
        .profile-sidebar-nav a {
            display: flex; align-items: center; gap: 10px; padding: 12px 15px;
            text-decoration: none; color: var(--text-light); font-weight: 500;
            font-size: 0.95rem; border-radius: 6px;
            transition: background-color 0.2s, color 0.2s;
        }
        .profile-sidebar-nav a:hover {
            background-color: var(--dash-bg); color: var(--primary-purple);
        }
        .profile-sidebar-nav a .icon { /* Placeholder */ font-size: 1.1rem; width: 20px; text-align: center; opacity: 0.7;}

        /* --- Personal Info Card --- */
        .personal-info-card {
             background-color: var(--profile-info-bg);
             border-radius: 12px; padding: 30px 35px;
             box-shadow: 0 5px 15px var(--card-shadow); border: 1px solid var(--border-color);
        }
         .personal-info-card h2 { /* Section Title */
             font-size: 1.4rem; font-weight: 600; margin-bottom: 5px; color: var(--text-primary);
        }
         .personal-info-card .subtitle {
             font-size: 0.9rem; color: var(--text-secondary); margin-bottom: 30px;
        }
        .info-grid {
             display: grid;
             grid-template-columns: repeat(2, 1fr); /* Two columns */
             gap: 25px; /* Gap between grid items */
             margin-bottom: 30px;
        }
        .info-field label {
             display: block; font-size: 0.85rem; font-weight: 500;
             color: var(--text-secondary); margin-bottom: 6px;
        }
        .info-field .value {
             background-color: var(--profile-info-field-bg);
             padding: 12px 15px; border-radius: 8px;
             font-size: 1rem; color: var(--text-primary); font-weight: 500;
             display: flex; align-items: center; gap: 10px;
             border: 1px solid var(--border-color);
        }
         .info-field .value .icon { /* Placeholder */ color: var(--text-secondary); opacity: 0.8;}
         .info-field .value .not-provided { color: var(--text-secondary); font-style: italic; }
         /* Address field spans two columns */
         .info-field.address { grid-column: span 2; }

         .info-actions { text-align: left; } /* Align button left */
         .info-actions .edit-btn {
             padding: 10px 25px; background-color: var(--button-bg); color: var(--button-text);
             border: none; border-radius: 6px; text-decoration: none; font-size: 0.95rem;
             font-weight: 500; cursor: pointer; transition: background-color 0.2s;
             display: inline-flex; align-items: center; gap: 8px;
         }
         .info-actions .edit-btn:hover { background-color: var(--button-hover-bg); }

        /* --- Responsive --- */
        @media (max-width: 992px) {
             .profile-layout { grid-template-columns: 1fr; /* Stack columns */ }
             .profile-sidebar-card { position: static; margin-bottom: 30px;} /* Remove sticky */
        }
        @media (max-width: 768px) {
             .page-container { padding: 0 15px; margin-top: 20px;}
             .profile-header h1 { font-size: 1.6rem; }
             .info-grid { grid-template-columns: 1fr; } /* Stack info fields */
             .info-field.address { grid-column: span 1; }
             .personal-info-card { padding: 25px; }
        }

    </style>
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="profile-header">
            <h1>My Profile</h1>
            <p>View and manage your account details</p>
        </header>

         <%-- Display Messages --%>
         <c:if test="${not empty requestScope.errorMessage}"><p class="error-message">${requestScope.errorMessage}</p></c:if>
         <c:if test="${not empty requestScope.successMessage}"><p class="success-message">${requestScope.successMessage}</p></c:if>

        <div class="profile-layout">

            <%-- Left Sidebar Card --%>
            <aside class="profile-sidebar-card">
                <div class="profile-avatar">
                    <%-- Placeholder Image - Replace with dynamic image URL if available --%>
                    <img src="https://via.placeholder.com/120x120/7e57c2/ffffff?text=$" alt="Profile Picture">
                </div>
                <h2><c:out value="${userProfile.username}"/></h2> <%-- Assuming username is the closest to Full Name --%>
                <p class="member-since">
                    Member since:
                    <c:if test="${not empty userProfile.createdAt}">
                        <fmt:formatDate value="${userProfile.createdAt}" pattern="MMMM dd, yyyy"/>
                    </c:if>
                    <c:if test="${empty userProfile.createdAt}"> N/A </c:if>
                </p>
                <nav class="profile-sidebar-nav">
                    <ul>
                        <%-- Links to future pages or JS functions --%>
                        <li><a href="#"><span class="icon">✎</span> Edit Profile</a></li>
                        <li><a href="#"><span class="icon"></span> Account History</a></li>
                         <li><a href="${pageContext.request.contextPath}/orders"><span class="icon"></span> My Orders</a></li>
                    </ul>
                </nav>
            </aside>

            <%-- Right Info Card --%>
            <section class="personal-info-card">
                <h2>Personal Information</h2>
                <p class="subtitle">Your account details</p>

                <div class="info-grid">
                    <div class="info-field">
                        <label for="fullName">Full Name</label> <%-- Label text from reference --%>
                        <div class="value"><span class="icon"></span> <c:out value="${userProfile.username}"/></div>
                    </div>
                    <div class="info-field">
                        <label for="email">Email Address</label>
                        <div class="value"><span class="icon">✉</span> <c:out value="${userProfile.email}"/></div>
                    </div>
                     <div class="info-field">
                        <label for="phone">Phone Number</label>
                         <div class="value">
                            <span class="icon"></span>
                            <c:choose>
                                <c:when test="${not empty userProfile.phone}"><c:out value="${userProfile.phone}"/></c:when>
                                <c:otherwise><span class="not-provided">Not Provided</span></c:otherwise>
                            </c:choose>
                         </div>
                    </div>
                     <div class="info-field">
                        <label for="joined">Joined On</label>
                        <div class="value">
                            <span class="icon"></span>
                             <c:if test="${not empty userProfile.createdAt}">
                                <fmt:formatDate value="${userProfile.createdAt}" pattern="MMMM dd, yyyy"/>
                             </c:if>
                             <c:if test="${empty userProfile.createdAt}"> N/A </c:if>
                        </div>
                    </div>
                    <div class="info-field address">
                         <label for="address">Address</label>
                         <div class="value">
                             <span class="icon"></span>
                             <span class="not-provided">Address not available</span> <%-- Placeholder --%>
                             <%-- Replace with ${userProfile.address} if you add it --%>
                         </div>
                    </div>
                </div>

                <div class="info-actions">
                     <%-- Link to future edit profile page/servlet --%>
                     <a href="#" class="edit-btn">Edit Information</a>
                </div>

            </section>

        </div> <%-- End profile-layout --%>
    </div> <%-- End Page Container --%>

</body>
</html>