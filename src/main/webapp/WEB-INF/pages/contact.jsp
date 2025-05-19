<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - MobileHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%-- ****** CRUCIAL: Ensure this links to your main style.css ****** --%>
    <%-- This file MUST style the navbar, body, page-container etc. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <%-- Font Awesome for Icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Optional: Add specific styles if needed, or rely on global style.css */
         /* Reusing personal-info-card style for the content block */
         .contact-form-card {
             background-color: var(--content-bg, #ffffff);
             border-radius: 12px;
             padding: 30px 35px;
             box-shadow: 0 5px 15px var(--card-shadow, rgba(0,0,0,0.1));
             border: 1px solid var(--border-color, #e0e0e0);
             max-width: 700px; /* Adjust width as needed */
             margin: 20px auto; /* Center the card below header */
         }

        .contact-form-card h2 {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--text-primary, #333);
        }
         .contact-form-card .subtitle {
             font-size: 0.9rem; color: var(--text-secondary, #666);
             margin-bottom: 20px;
        }

        .contact-form-fields .info-field { /* Use info-field class structure */
             margin-bottom: 20px; /* Space between form fields */
        }

        .contact-form-fields label {
            display: block; font-size: 0.85rem; font-weight: 500;
            color: var(--text-secondary, #666);
            margin-bottom: 6px;
        }

         /* Container for icon and input/textarea */
         .contact-form-fields .icon-input-container {
             display: flex;
             align-items: center; /* Align icon vertically */
             width: 100%;
             padding: 0;
             border: 1px solid var(--input-border, #e0e0e0);
             border-radius: 8px;
             background-color: var(--profile-info-field-bg, #f8f6fc);
             box-sizing: border-box;
             overflow: hidden;
         }
         .contact-form-fields .icon-input-container .icon {
             color: var(--text-secondary, #666); opacity: 0.8; margin: 0 10px;
             /* Ensure icon doesn't shrink */
             flex-shrink: 0;
         }

        /* Style for input and textarea fields */
        .contact-form-fields input[type="text"],
        .contact-form-fields input[type="email"],
        .contact-form-fields textarea {
            flex-grow: 1; /* Input takes remaining space */
            padding: 12px 0; /* Vertical padding, no horizontal inside container */
            border: none; /* Remove border from input/textarea */
            background-color: transparent; /* Transparent background */
            font-size: 1rem;
            color: var(--text-primary, #333);
            outline: none; /* Remove default outline */
            resize: vertical; /* Allow vertical resize for textarea */
             min-height: 45px; /* Match input height for visual consistency */
             font-family: inherit; /* Inherit font from body */
        }
         /* Add a focus style on the *container* */
         .contact-form-fields .icon-input-container:focus-within {
             border-color: var(--primary-purple, #7e57c2);
             box-shadow: 0 0 0 2px rgba(126, 87, 194, 0.2);
         }


        /* Validation Error Message Styling */
        .validation-error-message {
            display: none; /* Hidden by default */
            color: #e53935; /* Red color */
            font-size: 0.8rem;
            margin-top: 5px; /* Space above the message */
        }

        /* Style for inputs with validation errors */
        .contact-form-fields input.error,
        .contact-form-fields textarea.error {
            border-color: #e53935; /* Red border */
        }

         /* Submit Button Styling */
         .contact-form-card .info-actions {
             text-align: center;
             margin-top: 30px; /* Space above the button */
         }
         .contact-form-card .submit-btn {
             padding: 12px 30px;
             background-color: var(--button-bg, #7e57c2); color: var(--button-text, #fff);
             border: none; border-radius: 6px; /* Standard button radius */
             font-size: 1rem; font-weight: 500;
             cursor: pointer; transition: background-color 0.2s, opacity 0.2s;
         }
         .contact-form-card .submit-btn:hover { background-color: var(--button-hover-bg, #673ab7); }
         .contact-form-card .submit-btn:disabled {
             opacity: 0.6; cursor: not-allowed;
         }

         /* Success Message Styling */
         #contact-message-area {
             text-align: center;
             margin-bottom: 20px;
         }
         #contact-message-area .success-message {
             color: #2e7d32; /* Green color */
             background-color: #e8f5e9; /* Light green background */
             border: 1px solid #a5d6a7; /* Green border */
             padding: 15px;
             border-radius: 8px;
             font-size: 1rem;
             display: inline-block; /* Allows padding/border */
             width: 100%; /* Take full width of container */
             box-sizing: border-box;
         }


         /* Ensure the page-container and page-header styles from style.css are appropriate */
         .page-container {
              padding-top: 70px; /* Adjust based on fixed navbar height */
              /* Remove max-width/margin here if contact-form-card is handling centering/width */
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
              .contact-form-card { padding: 20px; } /* Adjust padding on small screens */
         }

    </style>
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container"> 
        <header class="page-header"> 
            <h1>Contact Us</h1>
        </header>

        <section class="contact-form-card"> 
            <div id="contact-message-area"></div>

            <%-- The Contact Form --%>
            <form id="contactForm" method="POST" action=""> 
                <div class="contact-form-fields">
                    <div class="info-field">
                        <label for="name">Your Name</label>
                        <div class="icon-input-container">
                             <i class="fas fa-user icon"></i>
                            <input type="text" id="name" name="name">
                        </div>
                        <span class="validation-error-message" id="name-error"></span>
                    </div>

                    <div class="info-field">
                        <label for="email">Your Email</label>
                        <div class="icon-input-container">
                             <i class="fas fa-envelope icon"></i>
                            <input type="email" id="email" name="email">
                        </div>
                        <span class="validation-error-message" id="email-error"></span>
                    </div>

                    <div class="info-field">
                        <label for="subject">Subject</label>
                         <%-- No standard icon for subject, but keep container structure --%>
                        <div class="icon-input-container">
                            <input type="text" id="subject" name="subject">
                        </div>
                        <span class="validation-error-message" id="subject-error"></span>
                    </div>

                    <div class="info-field">
                        <label for="message">Message</label>
                        
                         <div class="icon-input-container" style="align-items: flex-start; padding-top: 10px;">
                             <i class="fas fa-comment-alt icon"></i>
                             <textarea id="message" name="message" rows="6"></textarea>
                         </div>
                         <span class="validation-error-message" id="message-error"></span>
                    </div>
                </div>

                <div class="info-actions">
                    <%-- Submit Button --%>
                    <button type="submit" class="submit-btn">Send Message</button>
                </div>
            </form>
        </section>

    </div> <%-- End Page Container --%>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const contactForm = document.getElementById('contactForm');
            const messageArea = document.getElementById('contact-message-area');

            // Get references to input fields and their error message spans
            const nameInput = document.getElementById('name');
            const nameError = document.getElementById('name-error');

            const emailInput = document.getElementById('email');
            const emailError = document.getElementById('email-error');

            const subjectInput = document.getElementById('subject');
            const subjectError = document.getElementById('subject-error');

            const messageInput = document.getElementById('message');
            const messageError = document.getElementById('message-error');

            // List of required fields and their corresponding error spans
            const requiredFields = [
                { input: nameInput, errorSpan: nameError, message: 'Full Name is required.' },
                { input: emailInput, errorSpan: emailError, message: 'Email is required.' },
                 { input: subjectInput, errorSpan: subjectError, message: 'Subject is required.' },
                { input: messageInput, errorSpan: messageError, message: 'Message is required.' }
            ];

            // Function to clear all validation error messages
            function clearErrors() {
                messageArea.innerHTML = ''; // Clear any "Message Sent" or general errors
                requiredFields.forEach(field => {
                    field.input.classList.remove('error'); // Remove error class from input
                    field.errorSpan.textContent = ''; // Clear error text
                    field.errorSpan.style.display = 'none'; // Hide error span
                });
            }

            // Function to show a specific error message
            function showError(field, message) {
                field.input.classList.add('error'); // Add error class to input
                field.errorSpan.textContent = message; // Set error text
                field.errorSpan.style.display = 'block'; // Show error span
            }

            // Function to show the success message
            function showSuccessMessage(message) {
                messageArea.innerHTML = `<p class="success-message">${message}</p>`;
            }

            // Add event listener for form submission
            contactForm.addEventListener('submit', function(event) {
                event.preventDefault(); // Prevent the default form submission (which would reload the page)

                clearErrors(); // Clear previous errors before validating

                let formIsValid = true; // Flag to track overall form validity

                // Validate each required field
                requiredFields.forEach(field => {
                    if (field.input.value.trim() === '') {
                        showError(field, field.message); // Show specific error message
                        formIsValid = false; // Mark form as invalid
                    } else {
                        // Optional: Add more specific validation for email format here
                        if (field.input.type === 'email') {
                            // Basic email format check (can be more complex)
                            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            if (!emailPattern.test(field.input.value.trim())) {
                                showError(field, 'Please enter a valid email address.');
                                formIsValid = false;
                            }
                        }
                    }
                });

                // If the form is valid, show the success message
                if (formIsValid) {
                    showSuccessMessage('Your message has been sent!');
                    contactForm.reset(); // Clear the form fields after "sending"
                   
                } else {
                    
                }
            });
        });
    </script>

</body>
</html>