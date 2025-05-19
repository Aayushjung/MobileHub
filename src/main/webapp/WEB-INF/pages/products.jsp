<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Basic login check
    if (session.getAttribute("user") == null) {
       session.setAttribute("errorMessage", "Please login first to view our products.");
       response.sendRedirect(request.getContextPath() + "/login");
       return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Products - MobileHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
   
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container"> <%-- General wrapper, styled in style.css --%>
        <h1 class="page-title">Our Products</h1> <%-- Styled in style.css --%>

        <c:if test="${not empty requestScope.pageErrorMessage}">
            <p class="error-message">${requestScope.pageErrorMessage}</p>
        </c:if>
        <c:if test="${not empty requestScope.pageInfoMessage}">
            <p class="info-message">${requestScope.pageInfoMessage}</p>
        </c:if>

        <div class="product-grid"> <%-- Styled in style.css --%>
            <c:choose>
                <c:when test="${not empty productList}">
                    <c:forEach var="product" items="${productList}">
                        <div class="product-card"> <%-- Styled in style.css --%>
                            <div class="product-image">
                                <img src="${product.imageUrl}"
                                     alt="<c:out value="${product.name}"/>"
                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/200x150/e0e0e0/999999?text=Image+Error';">
                            </div>
                            <div class="product-info">
                                <h3><c:out value="${product.name}"/></h3>
                                <p class="description"><c:out value="${product.description}"/></p>
                                <div class="product-actions">
                                    <span class="price">
                                         <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                                    </span>
                                    <%-- "Buy Now" Form --%>
                                    <form id="buyForm_shop_${product.id}" <%-- Unique ID for shop page forms --%>
                                          action="${pageContext.request.contextPath}/createOrder"
                                          method="post" style="display:inline;">
                                        
                                        <input type="hidden" name="productId" value="${product.id}">
                                        <%-- CRUCIAL: Hidden fields for product name and price --%>
                                        <input type="hidden" name="productName" value="<c:out value='${product.name}'/>">
                                        <input type="hidden" name="productPrice" value="${product.price}">

                                        <button type="button" class="buy-btn" onclick="confirmBuy('shop_${product.id}', '<c:out value="${product.name}"/>')">Buy Now</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="info-message">No products currently available. Please check back later!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // JavaScript for "Buy Now" confirmation
        function confirmBuy(formIdSuffix, productName) {
            if (confirm("Are you sure you want to buy '" + productName + "'?")) {
                document.getElementById('buyForm_' + formIdSuffix).submit();
            }
        }
    </script>

</body>
</html>