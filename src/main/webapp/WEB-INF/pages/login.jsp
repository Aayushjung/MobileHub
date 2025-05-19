<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %> <%-- Use JSTL core tag library --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MobileHub - Secure Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <%-- Removed external CSS link --%>
    <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> --%>
    <%-- Optional: Add Font Awesome for icons --%>
    <%-- <script src="https://kit.fontawesome.com/your-fontawesome-kit-id.js" crossorigin="anonymous"></script> --%>

    <style>
        /* --- === CSS Reset & Basic Setup === --- */
        *,
        *::before,
        *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            font-size: 16px; /* Base font size */
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Poppins', sans-serif;
            font-weight: 400; /* Default font weight */
            line-height: 1.6;
            color: #e0e0e0; /* Light text color for dark background */
            /* Vibrant Gradient Background */
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow-x: hidden; /* Prevent horizontal scroll */
            padding: 20px; /* Add padding for smaller screens */
        }

        /* --- === Gradient Background Animation === --- */
        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* --- === Login Wrapper & Container === --- */
        .login-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            min-height: 100vh; /* Ensure wrapper takes full height */
            perspective: 1000px; /* For 3D effects if needed */
        }

        .login-container {
            background-color: rgba(30, 30, 40, 0.88); /* Slightly transparent dark background */
            padding: 45px 40px;
            border-radius: 15px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.6), 0 8px 20px rgba(0, 0, 0, 0.4);
            width: 100%;
            max-width: 420px; /* Slightly narrower */
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.15); /* Slightly more visible border */
            position: relative; /* For absolute positioning inside */
            overflow: hidden; /* Hide overflow for effects */
            transform: scale(0.95) rotateY(5deg); /* Start slightly smaller & tilted */
            opacity: 0; /* Start hidden for fade-in */
            animation: fadeInEntry 0.8s 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards; /* Entrance animation */
            transition: transform 0.4s ease, box-shadow 0.4s ease; /* Smooth transitions */
        }

        .login-container:hover {
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.7), 0 10px 25px rgba(0, 0, 0, 0.5);
            transform: scale(1) rotateY(0deg); /* Slight scale up on hover */
        }

        /* --- === Entrance Animation === --- */
        @keyframes fadeInEntry {
            to {
                opacity: 1;
                transform: scale(1) rotateY(0deg);
            }
        }

        /* --- === Header & Logo === --- */
        .login-header {
            margin-bottom: 30px;
        }

        .logo {
            max-width: 80px; /* Adjust logo size */
            height: auto;
            margin-bottom: 15px;
            filter: drop-shadow(0 2px 5px rgba(0, 0, 0, 0.5));
            transition: transform 0.3s ease;
        }

        .logo:hover {
             transform: scale(1.1) rotate(-5deg);
        }

        .login-header h2 {
            color: #ffffff;
            margin-bottom: 8px;
            font-size: 2.2rem; /* Larger heading */
            font-weight: 700;
            letter-spacing: 1px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
        }

        .login-header p {
            color: #bdbdbd; /* Lighter grey */
            font-size: 1rem;
            font-weight: 300;
        }

        /* --- === Form Styling === --- */
        .login-form {
            display: flex;
            flex-direction: column;
            gap: 20px; /* Space between form elements */
            margin-bottom: 25px;
        }

        .form-group {
            position: relative;
            text-align: left; /* Align labels left */
        }

        /* Input Icons (Requires Font Awesome) */
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #888; /* Icon color */
            font-size: 1.1rem;
            transition: color 0.3s ease;
        }

        .form-group input:focus + .input-icon {
            color: #23a6d5; /* Change icon color on focus */
        }

        .form-group label {
            display: block; /* Make label take full width */
            margin-bottom: 8px;
            color: #cccccc;
            font-size: 0.9rem;
            font-weight: 600;
            transition: color 0.3s ease;
            position: absolute;
            top: 16px;
            left: 15px; /* Adjust if using icons */
            /* left: 45px; */
            pointer-events: none; /* Allows clicking through label to input */
            transform-origin: left top;
            transition: transform 0.3s ease, color 0.3s ease, top 0.3s ease, font-size 0.3s ease;
        }

        /* Label animation when input has value or is focused */
        .form-group input:focus ~ label,
        .form-group input:not(:placeholder-shown) ~ label {
            transform: translateY(-14px) scale(0.85);
            color: #23a6d5; /* Highlight color */
            font-size: 0.75rem;
            top: 5px; /* Adjust position */
            left: 15px; /* Adjust position */
            background-color: rgba(30, 30, 40, 0.9); /* Match container slightly */
            padding: 0 5px;
            border-radius: 3px;
        }

        .form-group input {
            width: 100%;
            padding: 15px 15px 15px 15px; /* Adjust padding if using icons */
            /* padding: 15px 15px 15px 45px; */
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background-color: rgba(10, 10, 15, 0.7); /* Darker input background */
            color: #f0f0f0;
            font-size: 1rem;
            font-family: inherit;
            transition: border-color 0.3s ease, background-color 0.3s ease, box-shadow 0.3s ease;
            appearance: none; /* Remove default styles */
            outline: none; /* Remove default focus outline */
        }

        /* Remove browser's autofill background color */
         input:-webkit-autofill,
         input:-webkit-autofill:hover,
         input:-webkit-autofill:focus,
         input:-webkit-autofill:active {
             -webkit-box-shadow: 0 0 0 30px rgba(10, 10, 15, 0.9) inset !important; /* Match background */
             -webkit-text-fill-color: #f0f0f0 !important; /* Set text color */
             transition: background-color 5000s ease-in-out 0s; /* Delay transition */
         }

        .form-group input::placeholder {
            color: #777;
            opacity: 1; /* Ensure placeholder is visible */
            transition: opacity 0.3s ease;
        }

        .form-group input:focus::placeholder {
            opacity: 0.5; /* Dim placeholder on focus */
        }

        .form-group input:focus {
            border-color: #23a6d5; /* Highlight border on focus */
            background-color: rgba(0, 0, 5, 0.7); /* Slightly darker on focus */
            box-shadow: 0 0 10px rgba(35, 166, 213, 0.3); /* Subtle glow */
        }

        /* Input focus underline/border effect */
        .input-focus-effect {
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, #e73c7e, #23a6d5);
            transition: width 0.4s ease, left 0.4s ease;
            border-radius: 1px;
        }

        .form-group input:focus ~ .input-focus-effect {
            width: 100%;
            left: 0;
        }

        /* --- === Form Options (Remember Me / Forgot Password) === --- */
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: -5px; /* Adjust spacing */
            margin-bottom: 10px;
            font-size: 0.85rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
            cursor: pointer;
            color: #ccc;
            transition: color 0.3s ease;
        }
        .remember-me:hover {
            color: #fff;
        }

        .remember-me input[type="checkbox"] {
            margin-right: 8px;
            appearance: none; /* Remove default */
            width: 16px;
            height: 16px;
            border: 1px solid #888;
            border-radius: 4px;
            cursor: pointer;
            position: relative;
            top: -1px;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .remember-me input[type="checkbox"]:checked {
            background-color: #23a6d5;
            border-color: #23a6d5;
        }

         /* Checkmark for checkbox */
        .remember-me input[type="checkbox"]:checked::after {
             content: '\2713'; /* Checkmark symbol */
             font-size: 12px;
             color: #fff;
             position: absolute;
             left: 50%;
             top: 50%;
             transform: translate(-50%, -50%);
             font-weight: bold;
         }

        .forgot-password {
            color: #aaa;
            text-decoration: none;
            transition: color 0.3s ease, text-decoration 0.3s ease;
        }

        .forgot-password:hover {
            color: #e73c7e;
            text-decoration: underline;
        }

        /* --- === Submit Button Styling === --- */
        .btn {
            display: inline-block;
            padding: 14px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: all 0.35s cubic-bezier(0.25, 0.8, 0.25, 1); /* Smooth transition */
            position: relative;
            overflow: hidden; /* For ripple/shine effects */
            outline: none;
            margin-top: 10px; /* Add some top margin */
        }

        .login-btn {
            background: linear-gradient(90deg, #e73c7e, #ee7752);
            color: #ffffff;
            box-shadow: 0 4px 15px rgba(231, 60, 126, 0.4);
            width: 100%; /* Make button full width */
        }

        /* Button hover effect */
        .login-btn:hover {
            background: linear-gradient(90deg, #ee7752, #e73c7e); /* Reverse gradient */
            box-shadow: 0 6px 20px rgba(231, 60, 126, 0.6);
            transform: translateY(-3px); /* Slight lift */
        }

        /* Button active (pressed) effect */
        .login-btn:active {
            transform: translateY(-1px);
            box-shadow: 0 2px 10px rgba(231, 60, 126, 0.5);
        }

        /* Optional: Button Shine Effect */
        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(120deg, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.3) 50%, rgba(255, 255, 255, 0) 100%);
            transform: skewX(-25deg);
            transition: left 0.6s ease;
        }

        .login-btn:hover::before {
            left: 100%;
        }


        /* --- === Link Styles (Sign Up) === --- */
        .link {
            margin-top: 25px;
            font-size: 0.95rem;
            color: #ccc;
        }

        .link span {
             margin-right: 5px;
        }

        .link a {
            color: #23d5ab; /* Use a color from the gradient */
            font-weight: 600;
            text-decoration: none;
            position: relative;
            transition: color 0.3s ease;
        }

        .link a::after { /* Underline effect */
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -3px;
            left: 0;
            background-color: #23d5ab;
            transition: width 0.3s ease;
        }

        .link a:hover {
            color: #ffffff;
        }

        .link a:hover::after {
            width: 100%;
        }

        /* --- === Footer Styling === --- */
        .login-footer {
            margin-top: 35px;
            padding-top: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.8rem;
            color: #999;
        }

        /* --- === Message Styling (Error/Success) === --- */
        .message {
            padding: 12px 18px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-size: 0.95rem;
            font-weight: 500;
            text-align: left;
            border-left-width: 5px;
            border-left-style: solid;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            opacity: 0; /* Start hidden for animation */
            transform: translateY(-10px); /* Start slightly up */
        }

        .error-message {
            background-color: rgba(255, 82, 82, 0.2); /* Light red background */
            border-color: #ff5252; /* Red border */
            color: #ffcdd2; /* Light red text */
            animation: fadeInSlideDown 0.5s ease forwards, shakeX 0.6s 0.5s ease; /* Chain animations */
        }

        .success-message {
            background-color: rgba(76, 175, 80, 0.2); /* Light green background */
            border-color: #4CAF50; /* Green border */
            color: #c8e6c9; /* Light green text */
            animation: fadeInSlideDown 0.5s ease forwards;
        }

        /* --- === Shared Message Animation === --- */
        @keyframes fadeInSlideDown {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* --- === Error Message Shake Animation === --- */
        @keyframes shakeX {
          10%, 90% { transform: translateX(-2px); }
          20%, 80% { transform: translateX(3px); }
          30%, 50%, 70% { transform: translateX(-5px); }
          40%, 60% { transform: translateX(5px); }
          100% { transform: translateX(0); }
        }

        /* --- === General Animations (if needed globally) === --- */
        /* Example: Simple Fade In */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .animated.fadeIn { animation: fadeIn 0.6s ease forwards; }
        .animated.fadeInDown { animation: fadeInSlideDown 0.6s ease forwards; }

        /* --- === Responsiveness === --- */
        @media (max-width: 768px) {
            body {
                 align-items: flex-start; /* Align top on smaller screens */
                 padding-top: 5vh;
                 padding-bottom: 5vh;
            }
            .login-container {
                padding: 35px 25px;
                margin: 0 15px; /* Add side margin */
            }
            .login-header h2 {
                font-size: 1.8rem;
            }
             .login-header p {
                font-size: 0.9rem;
            }
            .form-group input {
                 padding: 14px 15px; /* Adjust padding */
                 /* padding: 14px 15px 14px 40px; */ /* If using icons */
            }
             .form-group label {
                 /* top: 14px; */ /* Adjust label position */
             }
            .form-options {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .forgot-password {
                 margin-left: 0; /* Align left */
            }
            .btn {
                font-size: 1rem;
                padding: 12px 20px;
            }
            .link {
                font-size: 0.9rem;
            }
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 30px 20px;
                border-radius: 10px;
            }
            .login-header h2 {
                font-size: 1.6rem;
            }
             .login-header p {
                font-size: 0.85rem;
            }
            .form-group {
                gap: 15px;
            }
            .form-group input {
                 font-size: 0.95rem;
            }
             .login-btn {
                 font-size: 1rem;
             }
             .link {
                 font-size: 0.85rem;
                 text-align: center;
             }
             .link span {
                 display: block;
                 margin-bottom: 5px;
             }
             .login-footer {
                 font-size: 0.75rem;
                 margin-top: 25px;
                 padding-top: 10px;
             }
        }

    </style>
</head>
<body>
    <div class="login-wrapper">
        
        <div class="login-container">
            <div class="login-header">
                
                <h2>Welcome Back!</h2>
                <p>Login to access your MobileHub account.</p>
            </div>

            <%-- Display error message if present in request scope --%>
            <c:if test="${not empty errorMessage}">
                <%-- Error message gets animated by CSS error-message class --%>
                <p class="message error-message">${errorMessage}</p>
            </c:if>

             <%-- Display success message if present in request scope (e.g., after signup/logout) --%>
            <c:if test="${not empty successMessage}">
                 <%-- Success message gets animated by CSS success-message class --%>
                <p class="message success-message">${successMessage}</p>
            </c:if>

            <form class="login-form" action="${pageContext.request.contextPath}/login" method="post" novalidate>
                <div class="form-group">
                    <%-- Optional: Add Font Awesome icon <i class="fas fa-user input-icon"></i> --%>
                    <input type="text" id="username" name="username" placeholder=" " required value="${param.username}"> <%-- Placeholder is space for label animation --%>
                    <label for="username">Username</label>
                    <span class="input-focus-effect"></span>
                </div>
                <div class="form-group">
                     <%-- Optional: Add Font Awesome icon <i class="fas fa-lock input-icon"></i> --%>
                    <input type="password" id="password" name="password" placeholder=" " required> <%-- Placeholder is space for label animation --%>
                    <label for="password">Password</label>
                    <span class="input-focus-effect"></span>
                </div>
                <div class="form-options">
                     <label class="remember-me">
                         <input type="checkbox" name="rememberMe"> Remember Me
                     </label>
                     <%-- Add functionality later if needed --%>
                     <a href="#" class="forgot-password">Forgot Password?</a>
                 </div>
                <button type="submit" class="btn login-btn">Login Securely</button>
            </form>
            <div class="link signup-link">
                <span>Don't have an account?</span> <a href="${pageContext.request.contextPath}/signup">Create One Now</a>
            </div>
             <footer class="login-footer">
                <p>© 2023 MobileHub. All rights reserved.</p>
            </footer>
        </div>
    </div>

   
</body>
</html>