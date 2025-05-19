<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - MobileHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%-- ****** CRUCIAL: Ensure this links to your main style.css ****** --%>
    <%-- This file MUST style the navbar, body, page-container etc. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
       
         .about-content-card {
             background-color: var(--content-bg, #ffffff);
             border-radius: 12px;
             padding: 30px 35px;
             box-shadow: 0 5px 15px var(--card-shadow, rgba(0,0,0,0.1));
             border: 1px solid var(--border-color, #e0e0e0);
             max-width: 800px; /* Adjust width as needed */
             margin: 20px auto; /* Center the card below header */
         }

        .about-content-card h2 {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--text-primary, #333);
        }

        .about-content-card p {
            font-size: 1rem;
            line-height: 1.6;
            color: var(--text-secondary, #666);
            margin-bottom: 15px; /* Space between paragraphs */
        }

         /* Ensure the page-container and page-header styles from style.css are appropriate */
         .page-container {
              padding-top: 70px; /* Adjust based on fixed navbar height */
              /* Remove max-width/margin here if about-content-card is handling centering/width */
              /* max-width: 1200px; margin: 30px auto; padding: 0 20px; */
         }
         .page-header {
             margin-bottom: 25px;
             text-align: center; /* Center header */
         }
         .page-header h1 {
             font-size: 2rem;
             font-weight: 600;
             margin-bottom: 4px;
         }

         @media (max-width: 768px) {
              .page-container { padding: 0 15px; margin-top: 20px;}
              .page-header h1 { font-size: 1.6rem; }
              .about-content-card { padding: 20px; } /* Adjust padding on small screens */
         }


    </style>
</head>
<body>

    <%-- Include your standard, globally styled navbar --%>
    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container"> 
        <header class="page-header"> 
            <h1>About MobileHub</h1>
            
        </header>

        <section class="about-content-card"> <%-- Reusing card styling --%>
            <h2>Our Story</h2>
            <p>
                Welcome to MobileHub, your ultimate destination for discovering the latest mobile phones and accessories.
                We are passionate about bringing you a wide selection of quality products from leading brands at competitive prices.
            </p>
            <p>
                Our goal is to provide a seamless and enjoyable shopping experience, backed by reliable customer service.
                Whether you're looking for the newest smartphone, a durable case, or cutting-edge headphones, you'll find it here.
            </p>
        </section>
         

    </div> <%-- End Page Container --%>

</body>
</html>