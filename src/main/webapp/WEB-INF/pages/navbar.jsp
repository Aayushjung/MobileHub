<%-- /WEB-INF/pages/includes/navbar.jsp --%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<nav class="navbar">
    <div class="navbar-container">

        <%-- Brand/Logo Link --%>
        <div class="navbar-brand-container">
            <c:choose>
                <c:when test="${not empty sessionScope.user and sessionScope.role == 'admin'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">MobileHub (Admin)</a>
                </c:when>
                <c:when test="${not empty sessionScope.user and sessionScope.role == 'customer'}">
                    <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">MobileHub</a>
                </c:when>
                <c:otherwise>
                     <a href="${pageContext.request.contextPath}/login" class="navbar-brand">MobileHub</a>
                </c:otherwise>
            </c:choose>
        </div>

        <ul class="navbar-links">

            <%-- Links for LOGGED OUT users --%>
            <c:if test="${empty sessionScope.user}">
                <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/signup">Sign Up</a></li>
            </c:if>

            <%-- Links for LOGGED IN users --%>
            <c:if test="${not empty sessionScope.user}">

                 <%-- Links for CUSTOMER role --%>
                 <c:if test="${sessionScope.role == 'customer'}">
                    <li><a href="${pageContext.request.contextPath}/dashboard">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/products">Shop</a></li>
                     <li><a href="${pageContext.request.contextPath}/about">About</a></li>
                     <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders">My Orders</a></li> 
                    <li><a href="${pageContext.request.contextPath}/profile">My Profile</a></li>
                 </c:if>

                 <%-- Links for ADMIN role --%>
                 <c:if test="${sessionScope.role == 'admin'}">
                     <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                     <li><a href="${pageContext.request.contextPath}/admin/manage-users">Manage Users</a></li>
                     <li><a href="${pageContext.request.contextPath}/admin/manage-products">Manage Products</a></li>

                     <%-- ****** ADDED LINK FOR MANAGE SALES ****** --%>
                     <li><a href="${pageContext.request.contextPath}/admin/manage-sales">Manage Sales</a></li>
                     <%-- ***************************************** --%>

                 </c:if>

                <%-- Common for all logged-in users --%>
                <li class="navbar-user-greeting">
                    Welcome, <c:out value="${sessionScope.username}" />!
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
                </li>

            </c:if>

        </ul>
    </div>
</nav>