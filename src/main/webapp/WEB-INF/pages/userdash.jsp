<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Security check
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
    <title>Welcome to MobileHub!</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <%-- Link to global style.css (for navbar, body defaults, :root variables) --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <%-- ****** INLINE STYLES FOR THIS USER DASHBOARD/HOME PAGE CONTENT ****** --%>
    <style>
      
        }

        /* --- Hero Banner Style --- */
        .hero-banner {
            background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)), url('https://via.placeholder.com/1200x280/7e57c2/ffffff?text=MobileHub+Deals'); /* Placeholder image */
            background-size: cover;
            background-position: center;
            padding: 50px 40px;
            text-align: center;
            color: #fff;
            border-radius: 10px;
            margin-bottom: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 220px; /* Adjust as needed */
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .hero-banner h2 {
            font-size: 2.3rem;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
        }
        .hero-banner p {
             font-size: 1.1rem;
             margin-bottom: 20px;
             font-weight: 300;
             opacity: 0.95;
        }
        .hero-banner .shop-now-btn {
             padding: 12px 30px;
             background-color: #ffc107; /* Yellow accent for button */
             color: #333; /* Dark text on yellow */
             border: none;
             border-radius: 25px; /* Pill shape */
             font-size: 1rem;
             font-weight: 600;
             text-decoration: none;
             cursor: pointer;
             transition: background-color 0.2s, transform 0.2s;
             box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
         .hero-banner .shop-now-btn:hover {
             background-color: #ffca2c; /* Lighter yellow on hover */
             transform: translateY(-2px);
         }

        /* --- Section Title --- */
        .section-title {
            font-size: 1.6rem;
            font-weight: 600;
            color: var(--text-primary, #333); /* Use theme variable */
            margin-top: 40px; /* Space above section */
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color, #e0e0e0); /* Use theme variable */
        }

        .product-grid { display: grid; gap: 25px; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); }
        .product-card { background-color: var(--card-bg, #fff); border-radius: 10px; border: 1px solid var(--border-color, #e0e0e0); box-shadow: 0 3px 10px var(--card-shadow, rgba(126, 87, 194, 0.1)); overflow: hidden; display: flex; flex-direction: column; transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 6px 15px var(--card-shadow, rgba(126, 87, 194, 0.15)); }
        .product-image { text-align: center; padding: 15px; background-color: #f9f9f9; min-height: 180px; display:flex; align-items: center; justify-content: center;}
        .product-image img { max-width: 100%; max-height: 150px; height: auto; object-fit: contain; }
        .product-info { padding: 20px; flex-grow: 1; display: flex; flex-direction: column;}
        .product-info h3 { font-size: 1.1rem; font-weight: 600; margin-bottom: 8px; color: var(--text-primary); min-height: 2.4em; }
        .product-info .description { font-size: 0.9rem; color: var(--text-light, #555); margin-bottom: 15px; flex-grow: 1; min-height: 3.2em; }
        .product-actions { display: flex; justify-content: space-between; align-items: center; margin-top: auto; padding-top: 10px; border-top: 1px solid #eee;}
        .product-actions .price { font-size: 1.1rem; font-weight: 600; color: var(--primary-purple, #7e57c2); }
        .product-actions .buy-btn { /* Reusing .buy-btn from products.jsp if styled globally */
            padding: 7px 16px; background-color: var(--button-bg, #7e57c2); color: var(--button-text, #fff);
            border: none; border-radius: 5px; text-decoration: none; font-size: 0.9rem;
            font-weight: 500; cursor: pointer; transition: background-color 0.2s;
        }
        .product-actions .buy-btn:hover { background-color: var(--button-hover-bg, #673ab7); }

        
        .info-message { color: var(--text-secondary, #666); font-style: italic; padding: 20px 0; text-align: center;}
        .error-message { color: red; background-color:#ffebee; padding:10px 15px; border:1px solid red; border-radius:4px; margin-bottom: 15px; font-weight: 500;}
        .success-message { color: green; background-color:#e8f5e9; padding:10px 15px; border:1px solid green; border-radius:4px; margin-bottom: 15px; font-weight: 500;}

        /* --- About Section --- */
        .home-info-section { margin-top: 40px; }
        .home-info-section .info-text { 
            font-size: 1rem;
            line-height: 1.7;
            color: var(--text-light, #555);
            text-align: left;
        }

        /* --- Responsive Adjustments --- */
        @media (max-width: 768px) {
             .content-wrapper-home { padding: 20px; }
             .hero-banner { padding: 40px 20px; min-height: 200px; }
             .hero-banner h2 { font-size: 2rem; }
             .section-title { font-size: 1.4rem; }
             .product-grid { grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); }
        }
        @media (max-width: 480px) {
            .content-wrapper-home { padding: 15px; }
            .hero-banner { padding: 30px 15px; min-height: 180px; }
            .hero-banner h2 { font-size: 1.8rem; }
            .product-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="content-wrapper-home">

        <c:if test="${not empty requestScope.dashboardErrorMessage}"><p class="error-message">${requestScope.dashboardErrorMessage}</p></c:if>
        <c:if test="${not empty requestScope.successMessage}"><p class="success-message">${requestScope.successMessage}</p></c:if>

        <section class="hero-banner">
            <h2>SUPER SALE</h2>
            <p>Explore amazing deals on the latest smartphones!</p>
            <a href="${pageContext.request.contextPath}/products" class="shop-now-btn">Shop All Products</a>
        </section>

        <section class="premium-mobiles-section">
            <h2 class="section-title">💎 Premium Mobiles</h2>
            <div class="product-grid">
                <c:choose>
                    <c:when test="${not empty premiumMobiles}">
                        <c:forEach var="product" items="${premiumMobiles}">
                            <div class="product-card">
                                <div class="product-image"><img src="${product.imageUrl}" alt="<c:out value="${product.name}"/>" onerror="this.onerror=null; this.src='https://via.placeholder.com/200x150/e0e0e0/999999?text=Image+Error';"></div>
                                <div class="product-info">
                                    <h3><c:out value="${product.name}"/></h3>
                                    <p class="description"><c:out value="${product.description}"/></p>
                                    <div class="product-actions">
                                        <span class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/></span>
                                        <form id="buyForm_dash_premium_${product.id}" action="${pageContext.request.contextPath}/createOrder" method="post" style="display:inline;">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <input type="hidden" name="productName" value="<c:out value='${product.name}'/>">
                                            <input type="hidden" name="productPrice" value="${product.price}">
                                            <button type="button" class="buy-btn" onclick="confirmBuy('dash_premium_${product.id}', '<c:out value="${product.name}"/>')">Buy Now</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="info-message">No premium mobiles featured at this time. Check our <a href="${pageContext.request.contextPath}/products">Shop</a> for all products!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <section class="standard-mobiles-section">
            <h2 class="section-title">📱 Standard Mobiles</h2>
            <div class="product-grid">
                 <c:choose>
                    <c:when test="${not empty standardMobiles}">
                        <c:forEach var="product" items="${standardMobiles}">
                           <div class="product-card">
                                <div class="product-image"><img src="${product.imageUrl}" alt="<c:out value="${product.name}"/>" onerror="this.onerror=null; this.src='https://via.placeholder.com/200x150/e0e0e0/999999?text=Image+Error';"></div>
                                <div class="product-info">
                                    <h3><c:out value="${product.name}"/></h3>
                                    <p class="description"><c:out value="${product.description}"/></p>
                                    <div class="product-actions">
                                        <span class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/></span>
                                        <form id="buyForm_dash_standard_${product.id}" action="${pageContext.request.contextPath}/createOrder" method="post" style="display:inline;">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <input type="hidden" name="productName" value="<c:out value='${product.name}'/>">
                                            <input type="hidden" name="productPrice" value="${product.price}">
                                            <button type="button" class="buy-btn" onclick="confirmBuy('dash_standard_${product.id}', '<c:out value="${product.name}"/>')">Buy Now</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                         <p class="info-message">No standard mobiles featured at this time. Explore our full <a href="${pageContext.request.contextPath}/products">Shop</a>!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

       

    </div> <%-- End content-wrapper-home --%>

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