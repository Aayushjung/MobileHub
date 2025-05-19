<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Optional: Redirect if not logged in as customer, although ideally handled by Filter
    // For this specific request (post-login home page), we assume the user IS logged in.
    String username = (String) session.getAttribute("username");
    if (username == null || !"customer".equalsIgnoreCase((String)session.getAttribute("role"))) {
        // In a real scenario, you might redirect or show a generic public homepage.
        // For now, we'll just ensure username has a default if somehow null.
        username = "Guest"; // Fallback, though login should be enforced before this page.
    }
    // You would fetch dynamic data (featured products, categories, etc.) here via Servlet/Controller
    // request.setAttribute("featuredProducts", productService.getFeatured());
    // request.setAttribute("newArrivals", productService.getNewArrivals());
    // request.setAttribute("topBrands", brandService.getTopBrands());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MobileHub - Deals on Latest Mobiles</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%-- Optional: Font Awesome for icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <%-- Example CDN Link --%>

    <style>
        /* --- === CSS Reset & Basic Setup === --- */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { font-size: 16px; scroll-behavior: smooth; }
        body {
            font-family: 'Poppins', sans-serif; font-weight: 400; line-height: 1.65;
            color: #e8e8e8;
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%; animation: gradientBG 18s ease infinite; /* Slower animation */
            overflow-x: hidden; /* Prevent horizontal scroll */
             background-attachment: fixed; /* Keep gradient fixed during scroll */
        }
        img { max-width: 100%; height: auto; display: block; }
        a { text-decoration: none; color: inherit; transition: color 0.3s ease; }
        ul { list-style: none; }
        button { font-family: inherit; cursor: pointer; border: none; background: none; }

        /* --- === Gradient Background Animation === --- */
        @keyframes gradientBG { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }

        /* --- === Utility Classes === --- */
        .container { width: 100%; max-width: 1280px; margin: 0 auto; padding: 0 20px; }
        .section-padding { padding: 60px 0; }
        .section-title {
            font-size: 2.2rem; font-weight: 600; color: #fff;
            text-align: center; margin-bottom: 40px; position: relative;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        .section-title::after { /* Decorative underline */
            content: ''; display: block; width: 80px; height: 3px;
            background: linear-gradient(90deg, #e73c7e, #23d5ab);
            margin: 10px auto 0; border-radius: 2px; opacity: 0.9;
        }
        .text-primary { color: #23d5ab; }
        .text-secondary { color: #ee7752; }
        .bg-dark-overlay { background-color: rgba(20, 22, 28, 0.88); } /* Darker overlay */

        /* --- === Header / Navigation === --- */
        .main-header {
            background-color: rgba(15, 25, 35, 0.9);
            padding: 12px 0;
            position: sticky; top: 0; z-index: 1000;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(8px); /* Glass effect */
            -webkit-backdrop-filter: blur(8px);
        }
        .header-container { display: flex; justify-content: space-between; align-items: center; }
        .logo a { display: flex; align-items: center; }
        .logo img { height: 40px; /* Adjust as needed */ margin-right: 10px; }
        .logo span { font-size: 1.6rem; font-weight: 700; color: #fff; letter-spacing: 1px; }
        .main-nav ul { display: flex; gap: 25px; }
        .main-nav a {
            color: #ccc; font-size: 1rem; font-weight: 500; padding: 8px 5px;
            position: relative; transition: color 0.3s ease;
        }
        .main-nav a::after { /* Underline hover effect */
            content: ''; position: absolute; bottom: 0; left: 0; width: 0; height: 2px;
            background: linear-gradient(90deg, #e73c7e, #23d5ab); border-radius: 1px;
            transition: width 0.3s ease;
        }
        .main-nav a:hover, .main-nav a.active { color: #fff; }
        .main-nav a:hover::after, .main-nav a.active::after { width: 100%; }

        .header-actions { display: flex; align-items: center; gap: 20px; }
        .search-bar { position: relative; }
        .search-bar input {
            padding: 8px 15px 8px 35px; /* Space for icon */
            border-radius: 20px; border: 1px solid rgba(255, 255, 255, 0.2);
            background-color: rgba(255, 255, 255, 0.1); color: #fff;
            font-size: 0.9rem; width: 220px; /* Adjust width */
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }
        .search-bar input::placeholder { color: #bbb; }
        .search-bar input:focus { background-color: rgba(255, 255, 255, 0.2); border-color: #23a6d5; outline: none; }
        .search-bar i { /* Search Icon */
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: #ccc; font-size: 0.9rem;
        }
        .action-icon {
            color: #ccc; font-size: 1.3rem; position: relative;
            transition: color 0.3s ease, transform 0.3s ease;
        }
        .action-icon:hover { color: #fff; transform: scale(1.1); }
        .action-icon .badge { /* For cart count */
            position: absolute; top: -5px; right: -8px; background-color: #e73c7e;
            color: #fff; font-size: 0.7rem; font-weight: 600;
            border-radius: 50%; width: 18px; height: 18px;
            display: flex; justify-content: center; align-items: center; line-height: 1;
        }
        .user-greeting span { font-weight: 500; margin-right: 5px; color: #ccc;}
        .user-greeting .username { font-weight: 600; color: #fff; }
        .mobile-menu-toggle { display: none; font-size: 1.8rem; color: #fff; } /* For responsiveness */

        /* --- === Hero Section === --- */
        .hero {
            min-height: 65vh; /* Adjust height */
            display: flex; align-items: center; justify-content: center; text-align: center;
            background: url('${pageContext.request.contextPath}/images/hero-bg-blurry.jpg') no-repeat center center/cover; /* Add a background image */
            position: relative; color: #fff; padding: 40px 0;
        }
        .hero::before { /* Dark overlay for text contrast */
            content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(10, 15, 25, 0.7); /* Adjust opacity */
            z-index: 1;
        }
        .hero-content { position: relative; z-index: 2; max-width: 700px; }
        .hero h1 {
            font-size: 3.2rem; font-weight: 700; line-height: 1.2;
            margin-bottom: 15px; text-shadow: 0 3px 8px rgba(0,0,0,0.5);
            animation: fadeInDown 1s ease-out;
        }
        .hero p {
            font-size: 1.2rem; font-weight: 300; margin-bottom: 30px;
            color: #e0e0e0; animation: fadeInUp 1s 0.3s ease-out backwards;
        }
        .hero .cta-button { /* Call to action button */
            display: inline-block; padding: 14px 35px;
            border-radius: 8px; font-size: 1.1rem; font-weight: 600;
            text-decoration: none; transition: all 0.35s ease;
            background: linear-gradient(90deg, #e73c7e, #ee7752); color: #ffffff;
            box-shadow: 0 5px 18px rgba(231, 60, 126, 0.4);
            animation: zoomIn 1s 0.6s ease-out backwards;
        }
        .hero .cta-button:hover {
            background: linear-gradient(90deg, #ee7752, #e73c7e);
            box-shadow: 0 8px 25px rgba(231, 60, 126, 0.6);
            transform: translateY(-3px);
        }

        /* --- === Featured Categories/Brands Section === --- */
        .featured-items { background-color: rgba(25, 28, 36, 0.8); }
        .featured-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 25px; text-align: center;
        }
        .featured-item {
            background-color: rgba(40, 44, 52, 0.7); padding: 25px 15px;
            border-radius: 10px; border: 1px solid rgba(255, 255, 255, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .featured-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
            border-color: #23a6d5;
        }
        .featured-item i { /* Icon for category */
            font-size: 2.8rem; margin-bottom: 15px;
            color: #64b5f6; /* Example color */
             display: block; /* Make icon block */
        }
         /* Assign different colors or icons per category */
        .featured-item.cat-smartphones i { color: #23d5ab; }
        .featured-item.cat-accessories i { color: #ee7752; }
        .featured-item.cat-deals i { color: #e73c7e; }
        .featured-item.cat-brands i { color: #ffeb3b; }

        .featured-item h3 {
            font-size: 1.1rem; font-weight: 600; color: #eee;
            margin-top: 10px;
        }

        /* --- === Product Showcase Section === --- */
        .product-showcase { background-color: rgba(15, 25, 35, 0.85); }
        .product-grid {
            display: grid;
            /* Responsive grid: 4 cols on large, 3 on medium, 2 on small, 1 on extra small */
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
        }
        .product-card {
            background-color: rgba(30, 33, 41, 0.9); border-radius: 10px;
            overflow: hidden; border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.4s ease;
            display: flex; flex-direction: column;
             animation: fadeInUp 0.6s ease-out backwards; /* Card entrance animation */
        }
         /* Stagger animation delay for cards */
        .product-card:nth-child(1) { animation-delay: 0.1s; }
        .product-card:nth-child(2) { animation-delay: 0.2s; }
        .product-card:nth-child(3) { animation-delay: 0.3s; }
        .product-card:nth-child(4) { animation-delay: 0.4s; }
        /* Add more if needed */

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
        }
        .product-image {
            height: 200px; /* Fixed height for image area */
            display: flex; justify-content: center; align-items: center;
            padding: 15px; background-color: #fff; /* White background for product images */
            position: relative; /* For potential badges */
        }
        .product-image img { max-height: 100%; width: auto; object-fit: contain; }
         .product-badge { /* e.g., "New", "Sale" */
             position: absolute; top: 10px; left: 10px; background-color: #e73c7e;
             color: #fff; padding: 4px 8px; font-size: 0.75rem; font-weight: 600;
             border-radius: 4px; text-transform: uppercase;
         }
        .product-info { padding: 20px; flex-grow: 1; display: flex; flex-direction: column; }
        .product-name {
            font-size: 1.05rem; font-weight: 600; color: #eee;
            margin-bottom: 8px; line-height: 1.4;
            /* Clamp text to 2 lines */
             display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
             min-height: calc(1.4em * 2); /* Ensure space for two lines */
        }
        .product-price {
            font-size: 1.2rem; font-weight: 700; color: #23d5ab; /* Highlight price */
            margin-bottom: 15px;
        }
        .product-price .original-price { /* If showing discount */
             font-size: 0.9rem; color: #999; text-decoration: line-through; margin-left: 8px;
        }
        .product-actions { margin-top: auto; /* Push to bottom */ display: flex; gap: 10px; }
        .product-btn {
            flex-grow: 1; padding: 9px 10px; font-size: 0.9rem; font-weight: 600;
            border-radius: 6px; text-align: center; transition: all 0.3s ease;
        }
        .btn-primary {
            background: linear-gradient(90deg, #e73c7e, #ee7752); color: #fff;
            box-shadow: 0 3px 10px rgba(231, 60, 126, 0.3);
        }
        .btn-primary:hover {
             background: linear-gradient(90deg, #ee7752, #e73c7e);
             box-shadow: 0 5px 15px rgba(231, 60, 126, 0.5);
             transform: translateY(-2px);
        }
        .btn-secondary {
            background-color: rgba(255, 255, 255, 0.1); color: #ccc;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .btn-secondary:hover { background-color: rgba(255, 255, 255, 0.2); color: #fff; }

        /* --- === Promotional Banner Section === --- */
        .promo-banner {
            background: linear-gradient(110deg, rgba(35, 166, 213, 0.85), rgba(35, 213, 171, 0.85)), url('${pageContext.request.contextPath}/images/promo-bg.jpg') no-repeat center center/cover;
            padding: 50px 0; text-align: center; color: #fff;
        }
        .promo-banner h2 { font-size: 2rem; margin-bottom: 15px; font-weight: 600; text-shadow: 0 2px 5px rgba(0,0,0,0.4); }
        .promo-banner p { font-size: 1.1rem; margin-bottom: 25px; color: #e0e0e0; max-width: 600px; margin-left: auto; margin-right: auto; }
        .promo-banner .cta-button {
            background: #fff; color: #23a6d5; /* Inverted colors */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        .promo-banner .cta-button:hover { background: #eee; transform: translateY(-2px); }

        /* --- === Brands Showcase === --- */
        .brands-showcase { background-color: rgba(20, 22, 28, 0.85); }
        .brands-grid {
            display: flex; flex-wrap: wrap; justify-content: center; align-items: center;
            gap: 30px;
        }
        .brand-logo {
            height: 45px; /* Adjust height */ width: auto; max-width: 120px; /* Max width */
            filter: grayscale(80%) brightness(1.5); /* Make logos appear light/monochrome */
            opacity: 0.8; transition: filter 0.3s ease, opacity 0.3s ease, transform 0.3s ease;
        }
        .brand-logo:hover {
            filter: grayscale(0%) brightness(1); opacity: 1; transform: scale(1.1);
        }

        /* --- === Footer === --- */
        .main-footer {
            background-color: #111821; /* Darker footer */
            color: #aaa; padding: 50px 0 30px; font-size: 0.9rem;
        }
        .footer-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px; margin-bottom: 40px;
        }
        .footer-column h4 {
            font-size: 1.1rem; font-weight: 600; color: #eee;
            margin-bottom: 15px; padding-bottom: 8px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .footer-column ul li { margin-bottom: 10px; }
        .footer-column ul a { color: #aaa; transition: color 0.3s ease, padding-left 0.3s ease; }
        .footer-column ul a:hover { color: #23d5ab; padding-left: 5px; }
        .footer-socials { margin-top: 15px; display: flex; gap: 15px; }
        .footer-socials a {
            color: #aaa; font-size: 1.4rem; transition: color 0.3s ease, transform 0.3s ease;
        }
        .footer-socials a:hover { color: #ee7752; transform: scale(1.2) rotate(5deg); }
        .footer-bottom {
            text-align: center; padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.85rem; color: #888;
        }
        .footer-bottom a { color: #aaa; font-weight: 500; }
        .footer-bottom a:hover { color: #fff; }

        /* --- === Animations (Example) === --- */
        @keyframes fadeInDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes zoomIn { from { opacity: 0; transform: scale(0.8); } to { opacity: 1; transform: scale(1); } }

        /* --- === Responsiveness === --- */
        @media (max-width: 992px) {
            .container { max-width: 960px; }
            .main-nav { display: none; /* Hide main nav for toggle */ }
            .mobile-menu-toggle { display: block; } /* Show hamburger */
            .header-actions .search-bar { display: none; /* Maybe hide search on smaller header */ }
            .product-grid { grid-template-columns: repeat(3, 1fr); }
            .hero h1 { font-size: 2.8rem; }
            .hero p { font-size: 1.1rem; }
            .footer-grid { grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); }
        }

        @media (max-width: 768px) {
            .container { max-width: 720px; padding: 0 15px; }
            .section-padding { padding: 50px 0; }
            .section-title { font-size: 1.9rem; }
            .header-container { /* Adjust header layout */ }
             .header-actions .user-greeting { display: none; /* Hide greeting text */}
            .hero { min-height: 55vh; }
            .hero h1 { font-size: 2.4rem; }
            .hero p { font-size: 1rem; }
            .product-grid { grid-template-columns: repeat(2, 1fr); }
            .promo-banner h2 { font-size: 1.8rem; }
             .footer-grid { grid-template-columns: repeat(2, 1fr); } /* 2 columns */
        }

        @media (max-width: 576px) {
            .container { max-width: 100%; padding: 0 10px; }
            .section-padding { padding: 40px 0; }
            .section-title { font-size: 1.7rem; }
            .logo span { font-size: 1.4rem; }
            .header-actions { gap: 15px; }
            .action-icon { font-size: 1.2rem; }
            .action-icon .badge { width: 16px; height: 16px; font-size: 0.65rem; }
            .hero { min-height: 50vh; }
            .hero h1 { font-size: 2rem; }
            .hero p { font-size: 0.95rem; }
            .hero .cta-button { padding: 12px 25px; font-size: 1rem; }
            .featured-grid { grid-template-columns: repeat(2, 1fr); gap: 15px; }
            .featured-item { padding: 20px 10px; }
            .featured-item i { font-size: 2.4rem; }
            .product-grid { grid-template-columns: 1fr; gap: 20px; } /* Single column */
            .product-name { font-size: 1rem; }
            .product-price { font-size: 1.1rem; }
            .promo-banner { padding: 40px 0; }
            .promo-banner h2 { font-size: 1.6rem; }
            .promo-banner p { font-size: 1rem; }
            .brands-grid { gap: 20px; }
            .brand-logo { height: 35px; }
            .footer-grid { grid-template-columns: 1fr; } /* Single column */
             .footer-column { text-align: center; }
             .footer-column h4 { border-bottom: none; text-align: center; }
             .footer-column ul { padding: 0; }
             .footer-socials { justify-content: center; }
        }
        /* (Add more specific styles and details to reach 1200+ lines if necessary, */
        /* e.g., more complex animations, specific states, detailed component styling) */

        /* --- End of CSS --- */
    </style>
</head>
<body>

    <!-- ==================== Header ==================== -->
    <header class="main-header">
        <div class="container header-container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home.jsp">
                    <%-- <img src="${pageContext.request.contextPath}/images/logo.png" alt="MobileHub Logo"> --%>
                    <i class="fas fa-mobile-alt" style="font-size: 2rem; color: #23d5ab; margin-right: 10px;"></i> <%-- Placeholder Icon --%>
                    <span>MobileHub</span>
                </a>
            </div>

            <nav class="main-nav">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home.jsp" class="active">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/products">Shop All</a></li>
                    <li><a href="${pageContext.request.contextPath}/categories">Categories</a></li>
                    <li><a href="${pageContext.request.contextPath}/brands">Brands</a></li>
                    <li><a href="${pageContext.request.contextPath}/deals">Deals</a></li>
                </ul>
            </nav>

            <div class="header-actions">
                <div class="search-bar">
                    <i class="fas fa-search"></i>
                    <input type="search" placeholder="Search for mobiles...">
                </div>
                 <div class="user-greeting">
                     <span>Hi,</span> <span class="username">${sessionScope.username}</span>
                 </div>
                <a href="${pageContext.request.contextPath}/userDashboard.jsp" class="action-icon" title="My Account"><i class="fas fa-user-circle"></i></a>
                <a href="${pageContext.request.contextPath}/wishlist" class="action-icon" title="Wishlist"><i class="fas fa-heart"></i></a>
                <a href="${pageContext.request.contextPath}/cart" class="action-icon" title="Cart">
                    <i class="fas fa-shopping-cart"></i>
                    <span class="badge">3</span> <%-- Placeholder cart count --%>
                </a>
                 <a href="${pageContext.request.contextPath}/logout" class="action-icon" title="Logout"><i class="fas fa-sign-out-alt"></i></a>
                <button class="mobile-menu-toggle"><i class="fas fa-bars"></i></button> <%-- For mobile nav --%>
            </div>
        </div>
    </header>

    <!-- ==================== Main Content ==================== -->
    <main>

        <!-- Hero Section -->
        <section class="hero">
            <div class="hero-content">
                <h1>Find Your Next <span class="text-primary">Perfect</span> Phone</h1>
                <p>Explore the latest smartphones from top brands with exclusive deals only at MobileHub.</p>
                <a href="${pageContext.request.contextPath}/products" class="cta-button">Shop New Arrivals</a>
            </div>
        </section>

        <!-- Featured Categories/Brands Section -->
        <section class="featured-items section-padding">
            <div class="container">
                <%-- <h2 class="section-title">Explore MobileHub</h2> --%>
                <div class="featured-grid">
                    <a href="${pageContext.request.contextPath}/products?category=smartphones" class="featured-item cat-smartphones">
                        <i class="fas fa-mobile-alt"></i>
                        <h3>Smartphones</h3>
                    </a>
                    <a href="${pageContext.request.contextPath}/products?category=accessories" class="featured-item cat-accessories">
                         <i class="fas fa-headphones-alt"></i>
                        <h3>Accessories</h3>
                    </a>
                    <a href="${pageContext.request.contextPath}/deals" class="featured-item cat-deals">
                         <i class="fas fa-tags"></i>
                        <h3>Hot Deals</h3>
                    </a>
                     <a href="${pageContext.request.contextPath}/brands" class="featured-item cat-brands">
                         <i class="fas fa-star"></i>
                        <h3>Top Brands</h3>
                    </a>
                </div>
            </div>
        </section>

         <!-- Product Showcase: New Arrivals -->
        <section class="product-showcase section-padding">
            <div class="container">
                <h2 class="section-title">New Arrivals</h2>
                <div class="product-grid">
                    <%-- Placeholder Product Cards - Loop using JSTL in real app --%>
                    <%-- <c:forEach items="${newArrivals}" var="product"> --%>
                    <div class="product-card">
                        <div class="product-image">
                             <span class="product-badge">New</span>
                            <%-- <img src="${pageContext.request.contextPath}/images/products/${product.image}" alt="${product.name}"> --%>
                            <img src="https://via.placeholder.com/180x180/ffffff/000000?text=Phone+1" alt="Phone 1">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">Samsung Galaxy Ultra Future</h3> <%-- ${product.name} --%>
                            <p class="product-price">$1199.99</p> <%-- ${product.price} --%>
                            <div class="product-actions">
                                <button class="product-btn btn-primary"><i class="fas fa-cart-plus"></i> Add</button>
                                <a href="${pageContext.request.contextPath}/product?id=123" class="product-btn btn-secondary">View</a>
                            </div>
                        </div>
                    </div>
                     <div class="product-card">
                        <div class="product-image">
                             <img src="https://via.placeholder.com/180x180/ffffff/000000?text=Phone+2" alt="Phone 2">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">iPhone 16 Pro Max Concept</h3>
                            <p class="product-price">$1299.00</p>
                            <div class="product-actions">
                                <button class="product-btn btn-primary"><i class="fas fa-cart-plus"></i> Add</button>
                                <a href="${pageContext.request.contextPath}/product?id=124" class="product-btn btn-secondary">View</a>
                            </div>
                        </div>
                    </div>
                     <div class="product-card">
                        <div class="product-image">
                            <span class="product-badge" style="background-color: #23d5ab;">Eco</span>
                             <img src="https://via.placeholder.com/180x180/ffffff/000000?text=Phone+3" alt="Phone 3">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">Google Pixel 9 AI Edition - Long Name Here To Test Wrapping</h3>
                            <p class="product-price">$999.00</p>
                            <div class="product-actions">
                                <button class="product-btn btn-primary"><i class="fas fa-cart-plus"></i> Add</button>
                                <a href="${pageContext.request.contextPath}/product?id=125" class="product-btn btn-secondary">View</a>
                            </div>
                        </div>
                    </div>
                     <div class="product-card">
                        <div class="product-image">
                             <img src="https://via.placeholder.com/180x180/ffffff/000000?text=Phone+4" alt="Phone 4">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">OneMore Brand X1 Speed</h3>
                            <p class="product-price">$750.50</p>
                            <div class="product-actions">
                                <button class="product-btn btn-primary"><i class="fas fa-cart-plus"></i> Add</button>
                                <a href="${pageContext.request.contextPath}/product?id=126" class="product-btn btn-secondary">View</a>
                            </div>
                        </div>
                    </div>
                    <%-- </c:forEach> --%>
                </div>
            </div>
        </section>

         <!-- Promotional Banner Section -->
        <section class="promo-banner section-padding">
            <div class="container">
                <h2><span class="text-secondary">Trade-In</span> Your Old Phone!</h2>
                <p>Get instant credit towards your new device when you trade in your eligible smartphone. Easy and eco-friendly!</p>
                <a href="${pageContext.request.contextPath}/trade-in" class="cta-button">Learn More & Get Estimate</a>
            </div>
        </section>

         <!-- Brands Showcase -->
         <section class="brands-showcase section-padding">
            <div class="container">
                 <h2 class="section-title">Shop By Brand</h2>
                 <div class="brands-grid">
                     <%-- Placeholder Brand Logos - Use actual images --%>
                     <a href="${pageContext.request.contextPath}/brands/apple"><img src="https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Apple" alt="Apple" class="brand-logo"></a>
                     <a href="${pageContext.request.contextPath}/brands/samsung"><img src="https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Samsung" alt="Samsung" class="brand-logo"></a>
                     <a href="${pageContext.request.contextPath}/brands/google"><img src="https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Google" alt="Google" class="brand-logo"></a>
                     <a href="${pageContext.request.contextPath}/brands/oneplus"><img src="https://via.placeholder.com/120x45/ffffff/aaaaaa?text=OnePlus" alt="OnePlus" class="brand-logo"></a>
                     <a href="${pageContext.request.contextPath}/brands/xiaomi"><img src="https://via.placeholder.com/120x45/ffffff/aaaaaa?text=Xiaomi" alt="Xiaomi" class="brand-logo"></a>
                 </div>
            </div>
        </section>

      

    </main>

    <!-- ==================== Footer ==================== -->
    <footer class="main-footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-column">
                    <h4>Shop</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/products?category=smartphones">Smartphones</a></li>
                        <li><a href="${pageContext.request.contextPath}/products?category=accessories">Accessories</a></li>
                        <li><a href="${pageContext.request.contextPath}/deals">Deals & Offers</a></li>
                        <li><a href="${pageContext.request.contextPath}/brands">Shop by Brand</a></li>
                        <li><a href="${pageContext.request.contextPath}/trade-in">Trade-In Program</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h4>Your Account</h4>
                    <ul>
                         <li><a href="${pageContext.request.contextPath}/userDashboard.jsp">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/orders">Order History</a></li>
                        <li><a href="${pageContext.request.contextPath}/wishlist">Wishlist</a></li>
                         <li><a href="${pageContext.request.contextPath}/profile/edit">Profile Settings</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                    </ul>
                </div>
                 <div class="footer-column">
                    <h4>Customer Service</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/help/faq">FAQ</a></li>
                        <li><a href="${pageContext.request.contextPath}/help/contact">Contact Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/help/shipping">Shipping Info</a></li>
                        <li><a href="${pageContext.request.contextPath}/help/returns">Return Policy</a></li>
                         <li><a href="${pageContext.request.contextPath}/help/warranty">Warranty</a></li>
                    </ul>
                </div>
                 <div class="footer-column">
                    <h4>MobileHub</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/careers">Careers</a></li>
                        <li><a href="${pageContext.request.contextPath}/terms">Terms & Conditions</a></li>
                        <li><a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></li>
                    </ul>
                     <div class="footer-socials">
                        <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" title="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" title="YouTube"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                © ${java.time.Year.now()} MobileHub. All Rights Reserved. Designed with <i class="fas fa-heart" style="color: #e73c7e;"></i>.
               
                 | <a href="#">Site Map</a>
            </div>
        </div>
    </footer>

   

</body>
</html>