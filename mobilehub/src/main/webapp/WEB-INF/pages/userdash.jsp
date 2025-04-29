<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Security check (Backup to Servlet/Filter)
    if (session.getAttribute("user") == null || !"customer".equalsIgnoreCase((String) session.getAttribute("role"))) {
       session.setAttribute("errorMessage", "Access denied. Please login as a customer.");
       response.sendRedirect(request.getContextPath() + "/login");
       return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - MobileHub</title> <%-- Changed Title slightly --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%-- Make sure this links to the CSS containing navbar AND the styles below --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Keep relevant styles from previous userdash/products */
        /* Add styles for banner and section titles */
        /* Ensure :root variables and body padding are set in the main style.css */

        /* --- Banner Style --- */
        .hero-banner {
            background-image: linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)), url('https://via.placeholder.com/1200x300/673ab7/ffffff?text=SUPER+SALE+BANNER'); /* Placeholder */
            background-size: cover;
            background-position: center;
            padding: 60px 40px;
            text-align: center;
            color: #fff;
            border-radius: 10px;
            margin-bottom: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 250px; /* Give it some height */
        }
        .hero-banner h2 {
            font-size: 2.5rem; font-weight: 700; margin-bottom: 10px; text-shadow: 1px 1px 3px rgba(0,0,0,0.6);
        }
        .hero-banner p {
             font-size: 1.1rem; margin-bottom: 20px; font-weight: 300; opacity: 0.9;
        }
        .hero-banner .shop-now-btn {
             padding: 12px 30px; background-color: #ffc107; /* Yellow button like reference */
             color: #333; border: none; border-radius: 25px; /* Pill shape */
             font-size: 1rem; font-weight: 600; text-decoration: none;
             cursor: pointer; transition: background-color 0.2s, transform 0.2s;
             box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
         .hero-banner .shop-now-btn:hover {
             background-color: #ffca2c; transform: translateY(-2px);
         }


        /* --- Section Title --- */
        .section-title {
            font-size: 1.6rem; font-weight: 600; color: var(--text-primary);
            margin-top: 40px; /* Space above section */
            margin-bottom: 25px; padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
        }

        /* --- Content Wrapper (Adjusted from userdash) --- */
         .content-wrapper {
             padding: 30px 40px;
             /* background-color: var(--content-bg); Optional if body bg is desired */
             max-width: 1400px; /* Match page container */
             margin: 0 auto; /* Center content */
         }

         /* --- Reusing Product Grid/Card Styles --- */
        .product-grid { display: grid; gap: 25px; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); /* Slightly smaller min */ }
        .product-card { background-color: #fff; border-radius: 10px; border: 1px solid var(--border-color); box-shadow: 0 3px 10px var(--card-shadow); overflow: hidden; display: flex; flex-direction: column; transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 6px 15px var(--card-shadow); }
        .product-image { text-align: center; padding: 15px; background-color: #f9f9f9; min-height: 180px; display:flex; align-items: center; justify-content: center;}
        .product-image img { max-width: 100%; max-height: 150px; height: auto; object-fit: contain; }
        .product-info { padding: 20px; flex-grow: 1; display: flex; flex-direction: column;}
        .product-info h3 { font-size: 1.1rem; font-weight: 600; margin-bottom: 8px; color: var(--text-primary); min-height: 2.4em; }
        .product-info .description { font-size: 0.9rem; color: var(--text-light); margin-bottom: 15px; flex-grow: 1; min-height: 3.2em; }
        .product-actions { display: flex; justify-content: space-between; align-items: center; margin-top: auto; padding-top: 10px; border-top: 1px solid #eee;}
        .product-actions .price { font-size: 1.1rem; font-weight: 600; color: var(--primary-purple); }
        .product-actions .view-details-btn { /* Renamed class slightly */
            padding: 7px 16px; background-color: var(--button-bg); color: var(--button-text);
            border: none; border-radius: 5px; text-decoration: none; font-size: 0.9rem;
            font-weight: 500; cursor: pointer; transition: background-color 0.2s;
         }
         .product-actions .view-details-btn:hover { background-color: var(--button-hover-bg); }

        /* Info Message */
        .info-message { color: var(--text-secondary); font-style: italic; padding: 20px 0; }

        /* --- Responsive --- */
        @media (max-width: 768px) {
             .content-wrapper { padding: 20px; }
             .hero-banner { padding: 40px 20px; min-height: 200px; }
             .hero-banner h2 { font-size: 2rem; }
             .section-title { font-size: 1.4rem; }
             .product-grid { grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); }
        }
        @media (max-width: 480px) {
            body { padding-top: 60px; /* Adjust if needed */ }
            .content-wrapper { padding: 15px; }
            .hero-banner { padding: 30px 15px; min-height: 180px; }
            .hero-banner h2 { font-size: 1.8rem; }
            .product-grid { grid-template-columns: 1fr; }
        }

    </style>
</head>
<body>

    <%-- Include Standard Navbar --%>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <%-- Remove main-content-wrapper if not needed, use content-wrapper directly --%>
    <div class="content-wrapper"> <%-- Changed from main-content-wrapper --%>

        <%-- Display Messages --%>
        <c:if test="${not empty requestScope.dashboardErrorMessage}"><p class="error-message">${requestScope.dashboardErrorMessage}</p></c:if>
        <c:if test="${not empty requestScope.successMessage}"><p class="success-message">${requestScope.successMessage}</p></c:if>

        <%-- Hero Banner Section --%>
        <section class="hero-banner">
            <h2>SUPER SALE</h2>
            <p>Get the best deals on the latest mobiles!</p>
            <a href="${pageContext.request.contextPath}/products" class="shop-now-btn">Shop Now</a>
        </section>

        <%-- Sale Items Section --%>
        <section class="sale-items">
            <h2 class="section-title">On Sale Now</h2>
            <div class="product-grid">
                <c:choose>
                    <c:when test="${not empty saleItems}">
                        <c:forEach var="product" items="${saleItems}">
                            <div class="product-card">
                                <div class="product-image"><img src="${not empty product.imageUrl ? product.imageUrl : '...'}" alt="<c:out value="${product.name}"/>"></div>
                                <div class="product-info">
                                    <h3><c:out value="${product.name}"/></h3>
                                    <p class="description"><c:out value="${product.description}"/></p>
                                    <div class="product-actions">
                                        <span class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" /></span>
                                        <a href="#" class="view-details-btn">View Details</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="info-message">No special sale items currently.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <%-- Featured Items Section --%>
        <section class="featured-items">
            <h2 class="section-title">Featured Mobiles</h2>
            <div class="product-grid">
                 <c:choose>
                    <c:when test="${not empty featuredItems}">
                        <c:forEach var="product" items="${featuredItems}">
                            <div class="product-card">
                                <div class="product-image"><img src="${not empty product.imageUrl ? product.imageUrl : '...'}" alt="<c:out value="${product.name}"/>"></div>
                                <div class="product-info">
                                    <h3><c:out value="${product.name}"/></h3>
                                    <p class="description"><c:out value="${product.description}"/></p>
                                    <div class="product-actions">
                                        <span class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" /></span>
                                        <a href="#" class="view-details-btn">View Details</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                         <p class="info-message">Check out our full range in the Shop!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <%-- Remove Tabs and other content --%>

    </div> <%-- End Content Wrapper --%>

    <%-- Remove Tab JavaScript --%>

</body>
</html>