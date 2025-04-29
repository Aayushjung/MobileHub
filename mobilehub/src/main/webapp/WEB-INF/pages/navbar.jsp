<%-- /src/main/webapp/WEB-INF/pages/includes/navbar.jsp --%>
<%--
    This navbar component displays different links based on user login status and role.
    It relies on the following session attributes being set by LoginServlet:
    - sessionScope.user: The User object (or at least check for its existence)
    - sessionScope.username: The logged-in user's username (String)
    - sessionScope.role: The logged-in user's role ('admin' or 'customer') (String)
--%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %> <%-- Import JSTL Core library --%>

<nav class="navbar">
    <div class="navbar-container">

        <%-- Brand/Logo Link - Destination depends on login status/role --%>
        <c:choose>
            <%-- Case 1: User is logged in --%>
            <c:when test="${not empty sessionScope.user}">
                <c:choose>
                     <%-- SubCase 1.1: User is Admin -> Link to Admin Dashboard --%>
                    <c:when test="${sessionScope.role == 'admin'}">
                        <%-- Best practice: Link to a servlet like /admin/dashboard that forwards --%>
                        <%-- For simplicity now, linking to the servlet that likely handles GET for the admin dash view --%>
                        <%-- Or, if no dedicated servlet exists, link directly (less ideal) - Assuming LoginServlet handles forwarding --%>
                         <a href="${pageContext.request.contextPath}/login" class="navbar-brand">MobileHub (Admin)</a> <%-- Adjust if you have a dedicated /admindash servlet --%>
                    </c:when>
                     <%-- SubCase 1.2: User is Customer -> Link to Customer Dashboard --%>
                    <c:otherwise>
                        <%-- Best practice: Link to a servlet like /dashboard that forwards --%>
                        <%-- For simplicity now, linking to the servlet that likely handles GET for the user dash view --%>
                         <a href="${pageContext.request.contextPath}/login" class="navbar-brand">MobileHub</a> <%-- Adjust if you have a dedicated /userdash servlet --%>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <%-- Case 2: User is logged out -> Link to Login Page --%>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="navbar-brand">MobileHub</a>
            </c:otherwise>
        </c:choose>

        <%-- Navigation Links - Right Aligned --%>
        <ul class="navbar-links">

            <%-- === Links visible ONLY when Logged OUT === --%>
            <c:if test="${empty sessionScope.user}">
                <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/signup">Sign Up</a></li>
            </c:if>

            <%-- === Links/Info visible ONLY when Logged IN === --%>
            <c:if test="${not empty sessionScope.user}">

                <%-- Role-specific links --%>
                <c:if test="${sessionScope.role == 'admin'}">
                    <%-- Admin Links - Update hrefs to point to actual servlets --%>
                    <li><a href="${pageContext.request.contextPath}/admin/manage-users">Manage Users</a></li>
                    <li><a href="#">Reports</a></li> <%-- Placeholder Link --%>
                    <li><a href="#">Settings</a></li> <%-- Placeholder Link --%>
                </c:if>

                <c:if test="${sessionScope.role == 'customer'}">
                     <%-- Customer Links - Update hrefs to point to actual servlets --%>
                      <li><a href="${pageContext.request.contextPath}/dashboard">Home</a></li>
                        <%-- Placeholder Link - e.g., /orders --%>
                    <li><a href="${pageContext.request.contextPath}/products">Shop</a></li>  <%-- Placeholder Link - e.g., /orders --%>
                    <li><a href="${pageContext.request.contextPath}/orders">My Orders</a></li>      <%-- Placeholder Link - e.g., /products --%>
                    <li><a href="${pageContext.request.contextPath}/profile">My Profile</a></li> <%-- Placeholder Link - e.g., /profile --%>
                </c:if>

                <%-- User Info Greeting --%>
                <li class="navbar-user-greeting">
                    Welcome, <c:out value="${sessionScope.username}" />! <%-- Use c:out for safety --%>
                </li>

                <%-- Logout Link --%>
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
                </li>

            </c:if> <%-- End of logged-in user section --%>

        </ul> <%-- End of navbar-links --%>
    </div> <%-- End of navbar-container --%>
</nav> <%-- End of navbar --%>

<%-- Add a placeholder div to push content below the fixed navbar --%>
<%-- Adjust height based on your actual navbar height --%>
<%-- <div style="height: 70px;"></div> --%>
<%-- Alternatively, add padding-top to the body in CSS (Recommended - see previous CSS answer) --%>