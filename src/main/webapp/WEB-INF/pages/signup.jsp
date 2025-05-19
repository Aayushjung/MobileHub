<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MobileHub - Create Your Account</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <%-- Optional: Font Awesome for icons --%>
    <%-- <script src="https://kit.fontawesome.com/your-fontawesome-kit-id.js" crossorigin="anonymous"></script> --%>

    <style>
        /* --- CSS Reset & Basic Setup (Approx. 15 lines) --- */
        *,
        *::before,
        *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            font-size: 16px;
            scroll-behavior: smooth;
            height: 100%;
        }

        body {
            font-family: 'Poppins', sans-serif;
            font-weight: 400;
            line-height: 1.6;
            color: #e0e0e0;
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            height: 100%;
            overflow-x: hidden;
            padding: 20px;
        }

        /* --- Gradient Background Animation (Approx. 10 lines) --- */
        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* --- Main Wrapper & Container Styling (Approx. 45 lines) --- */
        .form-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            min-height: 100%;
            padding: 30px 0;
            perspective: 1200px;
        }

        .form-container {
            background-color: rgba(30, 30, 40, 0.9);
            /* Increase padding slightly to accommodate grid spacing visually */
            padding: 45px 45px;
            border-radius: 18px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.65), 0 10px 25px rgba(0, 0, 0, 0.45);
            width: 100%;
            /* Make container slightly wider to better fit the grid */
            max-width: 580px; /* Adjusted */
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.18);
            position: relative;
            overflow: hidden;
            transform: scale(0.95) rotateY(5deg) translateZ(-20px);
            opacity: 0;
            animation: formEntryAnimation 0.9s 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
            transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.5s ease;
        }

        .form-container:hover {
            box-shadow: 0 30px 70px rgba(0, 0, 0, 0.75), 0 12px 30px rgba(0, 0, 0, 0.55);
            transform: scale(1.02) rotateY(0deg) translateZ(0px);
        }

        /* --- Container Entrance Animation (Approx. 8 lines) --- */
        @keyframes formEntryAnimation {
            to {
                opacity: 1;
                transform: scale(1) rotateY(0deg) translateZ(0px);
            }
        }

        /* --- Header & Logo Styling (Approx. 30 lines) --- */
        .form-header {
            margin-bottom: 30px; /* Increased margin */
            position: relative;
        }
        .form-header::after {
            content: ''; display: block; width: 60px; height: 3px;
            background: linear-gradient(90deg, #e73c7e, #23a6d5);
            margin: 15px auto 0; border-radius: 2px; opacity: 0.8;
        }
        .logo {
            max-width: 75px; height: auto; margin-bottom: 12px;
            filter: drop-shadow(0 3px 6px rgba(0, 0, 0, 0.6));
            transition: transform 0.4s ease-out, filter 0.4s ease;
        }
        .logo:hover { transform: scale(1.15) rotate(-8deg); filter: drop-shadow(0 5px 10px rgba(0, 0, 0, 0.8)); }
        .form-header h2 {
            color: #ffffff; margin-bottom: 10px; font-size: 2.1rem;
            font-weight: 700; letter-spacing: 0.8px;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
        }
        .form-header p { color: #c5c5c5; font-size: 1rem; font-weight: 300; }

        /* --- Form Styling & Structure (Approx. 15 lines) --- */
        .signup-form {
            display: flex;
            flex-direction: column;
            /* Gap between grid container, phone field, button etc. */
            gap: 25px; /* Adjusted */
            margin-bottom: 25px;
        }

        /* --- Grid Container Styling (NEW SECTION - Approx. 10 lines) --- */
        .input-grid {
            display: grid;
            /* Create two equal-width columns */
            grid-template-columns: repeat(2, 1fr);
            /* Define gap between grid items (rows and columns) */
            gap: 22px 18px; /* row-gap column-gap */
        }

        /* --- Form Group Styling (Adjustments maybe needed) --- */
        .form-group {
            position: relative;
            text-align: left;
            transition: margin-bottom 0.3s ease;
            /* No need for margin-bottom here if using grid gap */
            margin-bottom: 0 !important; /* Override potential invalid margin */
        }
        .form-group.invalid {
            /* Maybe add specific styles other than margin */
             border-left: 3px solid #ff5252; /* Example invalid style */
             padding-left: 5px; /* Adjust padding if using border */
        }
         .validation-icon { /* Keep as is */
             position: absolute; right: 15px; top: 55%;
             transform: translateY(-50%); font-size: 1.2rem;
             opacity: 0; transition: opacity 0.3s ease, color 0.3s ease;
        }
         .form-group.valid .validation-icon.valid-icon { opacity: 1; color: #4CAF50; }
         .form-group.invalid .validation-icon.invalid-icon { opacity: 1; color: #ff5252; }

        /* --- Input Fields & Floating Labels (Approx. 100 lines - largely unchanged) --- */
        .input-icon { /* Keep as is */
            position: absolute; left: 15px; top: calc(50% + 8px);
            transform: translateY(-50%); color: #888; font-size: 1.1rem;
            z-index: 2; transition: color 0.3s ease; pointer-events: none;
        }
        .form-group input:focus + .input-icon,
        .form-group input:focus ~ .input-icon { color: #23a6d5; }
        .form-group label { /* Keep as is */
            display: block; margin-bottom: 0; color: #cccccc; font-size: 1rem;
            font-weight: 400; position: absolute; top: 16px; left: 15px;
            pointer-events: none; transform-origin: left top;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                        color 0.3s ease, top 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                        left 0.3s cubic-bezier(0.4, 0, 0.2, 1), font-size 0.3s ease,
                        background-color 0.3s ease, padding 0.3s ease;
            z-index: 1; background-color: transparent; padding: 0 3px;
        }
        .form-group input:focus ~ label,
        .form-group input:not(:placeholder-shown) ~ label { /* Keep as is */
            transform: translateY(-17px) scale(0.80); color: #64b5f6;
            font-size: 0.78rem; font-weight: 600; top: 5px; left: 12px;
            background-color: #2a2a3a; border-radius: 3px; padding: 1px 6px;
            z-index: 3;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group input[type="password"] { /* Keep as is */
            width: 100%; /* Takes width of grid column */
            padding: 18px 15px 10px 15px;
            border: 1px solid rgba(255, 255, 255, 0.25); border-radius: 8px;
            background-color: rgba(10, 10, 15, 0.8); color: #f0f0f0;
            font-size: 1rem; font-family: inherit;
            transition: border-color 0.3s ease, background-color 0.3s ease, box-shadow 0.3s ease;
            appearance: none; outline: none; position: relative; z-index: 0;
        }
         input:-webkit-autofill,
         input:-webkit-autofill:hover,
         input:-webkit-autofill:focus,
         input:-webkit-autofill:active { /* Keep as is */
             -webkit-box-shadow: 0 0 0 40px rgba(15, 15, 20, 0.95) inset !important;
             -webkit-text-fill-color: #f1f1f1 !important;
             caret-color: #f1f1f1;
             transition: background-color 6000s ease-in-out 0s;
             font-family: 'Poppins', sans-serif; font-size: 1rem;
         }
        .form-group input::placeholder { color: #777; opacity: 1; transition: opacity 0.3s ease; }
        .form-group input:placeholder-shown::placeholder { color: transparent; }
        .form-group input:focus::placeholder { opacity: 0.5; }
        .form-group input:focus { /* Keep as is */
            border-color: #23a6d5;
            background-color: rgba(0, 0, 5, 0.85);
            box-shadow: 0 0 12px rgba(35, 166, 213, 0.4), 0 0 1px rgba(35, 166, 213, 0.8) inset;
        }

        /* --- Input Focus Underline Effect (Approx. 15 lines - unchanged) --- */
        .input-focus-effect { /* Keep as is */
            position: absolute; bottom: 0; left: 0; width: 0; height: 2px;
            background: linear-gradient(90deg, #e73c7e, #23a6d5, #23d5ab);
            background-size: 200% 100%;
            transition: width 0.45s cubic-bezier(0.23, 1, 0.32, 1);
            border-radius: 1px; z-index: 2;
            animation: focusGradientFlow 2s linear infinite paused;
        }
        .form-group input:focus ~ .input-focus-effect { width: 100%; animation-play-state: running; }
        @keyframes focusGradientFlow { /* Keep as is */
            0% { background-position: 200% 0; } 100% { background-position: 0% 0; }
        }

        /* --- Password Strength Indicator (Conceptual - Requires JS) (Approx. 20 lines - unchanged) --- */
        .password-strength { /* Keep as is */
             height: 5px; margin-top: 5px; border-radius: 3px;
             background-color: #333; overflow: hidden;
             transition: background-color 0.3s ease;
        }
        .strength-meter { /* Keep as is */
             height: 100%; width: 0;
             background: linear-gradient(90deg, #ff5252, #ffeb3b, #4caf50);
             background-size: 300% 100%;
             transition: width 0.4s ease, background-position 0.4s ease;
             border-radius: 3px;
        }
        .strength-meter.weak { width: 33%; background-position: 0% 0; }
        .strength-meter.medium { width: 66%; background-position: 50% 0; }
        .strength-meter.strong { width: 100%; background-position: 100% 0; }

        /* --- Submit Button Styling (Approx. 50 lines - unchanged) --- */
        .btn { /* Keep as is */
            display: inline-block; padding: 15px 30px; border: none;
            border-radius: 10px; font-size: 1.15rem; font-weight: 600;
            letter-spacing: 0.8px; cursor: pointer; text-align: center;
            text-decoration: none; transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
            position: relative; overflow: hidden; outline: none;
            margin-top: 0; /* Margin handled by form gap */
            z-index: 1; transform: translateZ(0);
            -webkit-backface-visibility: hidden; backface-visibility: hidden;
        }
        .signup-btn { /* Keep as is */
            background: linear-gradient(90deg, #e73c7e, #ee7752);
            color: #ffffff; box-shadow: 0 5px 18px rgba(231, 60, 126, 0.45);
            width: 100%;
        }
        .signup-btn:hover { /* Keep as is */
            background: linear-gradient(90deg, #ee7752, #e73c7e);
            box-shadow: 0 8px 25px rgba(231, 60, 126, 0.65);
            transform: translateY(-4px) scale(1.02);
        }
        .signup-btn:active { /* Keep as is */
            transform: translateY(-2px) scale(1);
            box-shadow: 0 3px 12px rgba(231, 60, 126, 0.5);
        }
        .signup-btn::before { /* Keep as is */
            content: ''; position: absolute; top: -10%; left: -120%; width: 80%;
            height: 120%;
            background: linear-gradient(110deg, rgba(255, 255, 255, 0) 20%, rgba(255, 255, 255, 0.35) 50%, rgba(255, 255, 255, 0) 80%);
            transform: skewX(-25deg);
            transition: left 0.75s cubic-bezier(0.23, 1, 0.32, 1); z-index: 2;
        }
        .signup-btn:hover::before { left: 120%; }

        /* --- Link Styles (Login Link) (Approx. 30 lines - unchanged) --- */
        .link { margin-top: 0; /* Margin handled by form gap */ font-size: 0.95rem; color: #bdbdbd; }
        .link span { margin-right: 6px; }
        .link a { color: #23d5ab; font-weight: 600; text-decoration: none;
            position: relative; transition: color 0.3s ease, text-shadow 0.3s ease;
            padding-bottom: 2px; }
        .link a:hover { color: #ffffff; text-shadow: 0 0 8px rgba(35, 213, 171, 0.7); }
        .link a::after { content: ''; position: absolute; width: 0; height: 2px;
            bottom: -4px; left: 50%; transform: translateX(-50%);
            background-color: #23d5ab;
            transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1); border-radius: 1px; }
        .link a:hover::after { width: 100%; }

        /* --- Footer Styling (Approx. 10 lines - unchanged) --- */
        .form-footer { margin-top: 0; /* Margin handled by form gap */ padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.15); font-size: 0.8rem;
            color: #a0a0a0; opacity: 0.8; }

        /* --- Message Styling (Error/Success) (Approx. 40 lines - unchanged) --- */
        .message { /* Keep as is */
            padding: 14px 20px; margin-bottom: 0; /* Handled by form gap if message is direct child */
            border-radius: 8px; font-size: 0.98rem; font-weight: 500;
            text-align: left; border-left-width: 6px; border-left-style: solid;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.25); position: relative;
            opacity: 0; transform: translateY(-15px) scale(0.98);
            animation: messageFadeInSlide 0.55s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
        }
        .error-message { /* Keep as is */
            background-color: rgba(255, 82, 82, 0.25); border-color: #ff5252;
            color: #ffcdd2;
            animation: messageFadeInSlide 0.55s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards,
                       shakeX 0.7s 0.55s cubic-bezier(.36,.07,.19,.97) both;
        }
        .success-message { /* Keep as is */
            background-color: rgba(76, 175, 80, 0.25); border-color: #4CAF50; color: #c8e6c9;
        }
        @keyframes messageFadeInSlide { to { opacity: 1; transform: translateY(0) scale(1); } }
        @keyframes shakeX { /* Keep as is */
            10%, 90% { transform: translateX(-1px) scale(1); }
            20%, 80% { transform: translateX(2px) scale(1); }
            30%, 50%, 70% { transform: translateX(-3px) scale(1); }
            40%, 60% { transform: translateX(3px) scale(1); }
            100% { transform: translateX(0) scale(1); }
        }

        /* --- General Utility & Accessibility (Approx. 15 lines - unchanged) --- */
        .sr-only { /* Keep as is */
            position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px;
            overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border-width: 0;
        }
        a:focus, button:focus, input[type="checkbox"]:focus { outline: 2px solid #64b5f6; outline-offset: 2px; }
        input[type="text"]:focus, input[type="email"]:focus,
        input[type="tel"]:focus, input[type="password"]:focus { outline: none; }


        /* --- Responsiveness (UPDATED) (Approx. 70 lines) --- */
        @media (max-width: 768px) {
            body {
                 align-items: flex-start; padding-top: 5vh; padding-bottom: 5vh;
                 min-height: calc(100vh - 10vh);
            }
            .form-wrapper { padding: 15px 0; perspective: none; }
            .form-container {
                padding: 35px 25px; margin: 0 15px;
                max-width: 500px; /* Adjust max-width for tablet */
                transform: scale(0.98) rotateY(0deg) translateZ(0px);
                animation: formEntryAnimationMobile 0.7s 0.1s ease-out forwards;
            }
             @keyframes formEntryAnimationMobile { to { opacity: 1; transform: scale(1); } }

             /* --- Grid responsiveness: Stack columns on medium screens --- */
             .input-grid {
                 grid-template-columns: 1fr; /* Single column */
                 gap: 18px 0; /* Adjust gap for single column */
             }
             /* --- --- */

            .form-header h2 { font-size: 1.8rem; }
            .form-header p { font-size: 0.9rem; }
            .signup-form { gap: 20px; } /* Adjust form gap */
            .form-group input[type="text"], .form-group input[type="email"],
            .form-group input[type="tel"], .form-group input[type="password"] {
                 padding: 16px 15px 8px 15px; font-size: 0.95rem;
            }
             .form-group label { /* Keep as is */ }
             .form-group input:focus ~ label,
             .form-group input:not(:placeholder-shown) ~ label {
                 transform: translateY(-14px) scale(0.80); top: 4px;
             }
            .btn { font-size: 1rem; padding: 14px 25px; }
            .link { font-size: 0.9rem; }
            .form-footer { padding-top: 15px; }
        }

        @media (max-width: 480px) {
            body { padding: 10px; min-height: 100vh; align-items: center; }
            .form-wrapper { padding: 10px 0; }
            .form-container {
                padding: 30px 18px; border-radius: 12px; margin: 0 10px;
                max-width: none; width: calc(100% - 20px);
            }
            .form-header h2 { font-size: 1.65rem; }
            .form-header p { font-size: 0.88rem; }
            .form-header::after { width: 45px; margin-top: 12px; }
             /* Grid remains single column */
             .input-grid { gap: 16px 0; }
            .signup-form { gap: 18px; } /* Adjust form gap */
             .form-group input { font-size: 0.9rem; }
             .signup-btn { font-size: 1rem; padding: 12px 20px; }
             .link { font-size: 0.85rem; text-align: center; }
             .link span { display: block; margin-bottom: 5px; }
             .form-footer { font-size: 0.75rem; padding-top: 12px; }
        }

        /* --- End of CSS --- */
    </style>
</head>
<body>
    <div class="form-wrapper">
        <div class="form-container">
            <div class="form-header">
                <%-- Optional Logo --%>
                <%-- <img src="${pageContext.request.contextPath}/images/logo.png" alt="MobileHub Logo" class="logo"> --%>
                <h2>Create Account</h2>
                <p>Join MobileHub today! It's free and only takes a minute.</p>
            </div>

            <%-- Display error message if present --%>
            <c:if test="${not empty errorMessage}">
                <p class="message error-message">${errorMessage}</p>
            </c:if>

            <%-- Display success message if present --%>
            <c:if test="${not empty successMessage}">
                <p class="message success-message">${successMessage}</p>
            </c:if>

            <%-- Signup Form --%>
            <form class="signup-form" action="${pageContext.request.contextPath}/signup" method="post" novalidate>

                <%-- NEW: Grid container for the 2x2 inputs --%>
                <div class="input-grid">
                    <%-- Username (Grid Item 1) --%>
                    <div class="form-group">
                        <input type="text" id="username" name="username" placeholder=" " required
                               value="${not empty param.username ? param.username : (not empty usernameValue ? usernameValue : '')}">
                        <label for="username">Username</label>
                        <span class="input-focus-effect"></span>
                    </div>

                    <%-- Email (Grid Item 2) --%>
                     <div class="form-group">
                        <input type="email" id="email" name="email" placeholder=" " required
                               value="${not empty param.email ? param.email : (not empty emailValue ? emailValue : '')}">
                        <label for="email">Email Address</label>
                        <span class="input-focus-effect"></span>
                    </div>

                    <%-- Password (Grid Item 3) --%>
                    <div class="form-group">
                        <input type="password" id="password" name="password" placeholder=" " required>
                        <label for="password">Create Password</label>
                        <span class="input-focus-effect"></span>
                    </div>

                    <%-- Confirm Password (Grid Item 4) --%>
                     <div class="form-group">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder=" " required>
                        <label for="confirmPassword">Confirm Password</label>
                        <span class="input-focus-effect"></span>
                    </div>
                </div> <%-- End of input-grid --%>

                <%-- Phone (Optional - Full Width Below Grid) --%>
                 <div class="form-group">
                    <input type="tel" id="phone" name="phone" placeholder=" "
                           value="${not empty param.phone ? param.phone : (not empty phoneValue ? phoneValue : '')}">
                    <label for="phone">Phone Number (Optional)</label>
                    <span class="input-focus-effect"></span>
                </div>

                <%-- Submit Button --%>
                <button type="submit" class="btn signup-btn">Create Account</button>

                 <%-- Link to Login Page --%>
                 <div class="link">
                    <span>Already have an account?</span> <a href="${pageContext.request.contextPath}/login">Login Here</a>
                </div>

                 <%-- Footer --%>
                 <footer class="form-footer">
                    <p>© ${java.time.Year.now()} MobileHub. All rights reserved.</p>
                </footer>

            </form> <%-- End of signup-form --%>

        </div> <%-- End of form-container --%>
    </div> <%-- End of form-wrapper --%>

   
</body>
</html>