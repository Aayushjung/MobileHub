<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Basic login check
    if (session.getAttribute("user") == null) {
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
    <title>Products - MobileHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <%-- ****** ENSURE THIS PATH IS CORRECT AND THE FILE HAS NAVBAR STYLES ****** --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <%-- Removed the inline <style> block - Move these styles to style.css --%>

</head>
<body>

    <%-- Include the Standard Navbar --%>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <%-- Page Content Container --%>
    <div class="page-container"> <%-- Ensure .page-container styles are in style.css --%>
        <h1 class="page-title">Our Products</h1> <%-- Ensure .page-title styles are in style.css --%>

        <c:if test="${not empty requestScope.pageErrorMessage}">
             <%-- Ensure .error-message styles are in style.css --%>
            <p class="error-message">${requestScope.pageErrorMessage}</p>
        </c:if>

        <%-- Product Grid - Ensure .product-grid and .product-card styles are in style.css --%>
        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty productList}">
                    <c:forEach var="product" items="${productList}">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="${not empty product.imageUrl ? product.imageUrl : 'https://via.placeholder.com/200x150/e0e0e0/999999?text=No+Image'}"
                                     alt="<c:out value="${product.name}"/>">
                            </div>
                            <div class="product-info">
                                <h3><c:out value="${product.name}"/></h3>
                                <p class="description"><c:out value="${product.description}"/></p>
                                <div class="product-actions">
                                    <span class="price">
                                         <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                                    </span>
                                    <a href="#" class="buy-btn">View Details</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <%-- Ensure .info-message styles are in style.css --%>
                    <p class="info-message">No products currently available. Please check back later!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>