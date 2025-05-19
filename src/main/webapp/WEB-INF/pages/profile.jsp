<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    // Basic login check - backup
    if (session.getAttribute("user") == null || !"customer".equalsIgnoreCase((String) session.getAttribute("role"))) {
       session.setAttribute("errorMessage", "Please login first.");
       response.sendRedirect(request.getContextPath() + "/login");
       return;
    }
    // Retrieve profile data set by servlet (userProfile)
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - MobileHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <%-- Font Awesome for Icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        
        .personal-info-card {
            background-color: var(--content-bg, #ffffff);
            border-radius: 12px; padding: 30px 35px;
            box-shadow: 0 5px 15px var(--card-shadow, rgba(0,0,0,0.1));
            border: 1px solid var(--border-color, #e0e0e0);
        }
        .personal-info-card h2 {
             font-size: 1.4rem; font-weight: 600; margin-bottom: 5px; color: var(--text-primary, #333);
        }
         .personal-info-card .subtitle {
             font-size: 0.9rem; color: var(--text-secondary, #666);
             margin-bottom: 30px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }
         .info-field label {
            display: block; font-size: 0.85rem; font-weight: 500;
             color: var(--text-secondary, #666);
             margin-bottom: 6px;
        }
         
         .info-field .value-display {
             display: flex;
             align-items: center;
             width: 100%;
             padding: 12px 15px;
             border: 1px solid var(--border-color, #e0e0e0);
             border-radius: 8px;
             font-size: 1rem;
             color: var(--text-primary, #333);
             background-color: var(--profile-info-field-bg, #f8f6fc);
             box-sizing: border-box;
             box-shadow: none;
             word-break: break-word;
             min-height: 45px; 
         }
          .info-field .value-display .icon {
             color: var(--text-secondary, #666); opacity: 0.8; margin-right: 10px;
         }
          .info-field .value-display .not-provided {
              font-style: italic; color: var(--text-secondary, #666);
          }


         .info-actions { text-align: center; }
         .edit-btn { /* Button to open the modal */
             padding: 12px 30px;
             background-color: var(--button-bg, #7e57c2); color: var(--button-text, #fff);
             border: none; border-radius: 66px; /* Adjusted border-radius to match image */
             text-decoration: none; font-size: 1rem;
             font-weight: 500; cursor: pointer; transition: background-color 0.2s;
             display: inline-flex; /* Use flex to align icon and text */
             align-items: center;
             min-width: 150px;
         }
         .edit-btn:hover { background-color: var(--button-hover-bg, #673ab7); }
         .edit-btn .icon { margin-right: 8px; }


        
         .global-message-area {
             max-width: 700px; 
             margin: 10px auto 20px auto;
             padding: 0 20px; 
             box-sizing: border-box;
         }
         .global-message-area .error-message,
         .global-message-area .success-message {
            
             margin-bottom: 0; 
             padding: 10px 15px; 
         }


       
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* Dark semi-transparent overlay */
            display: flex; justify-content: center; align-items: center;
            z-index: 1000;
             visibility: hidden; opacity: 0;
             transition: opacity 0.3s ease;
        }
        .modal-overlay.visible {
             visibility: visible; opacity: 1;
        }

        .modal-content {
            background-color: #ffffff; /* White background */
            border-radius: 12px; /* Rounded corners */
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            width: 90%; max-width: 450px; 
            position: relative;
            padding: 25px; /* Padding inside the modal */
             transform: translateY(-20px);
             transition: transform 0.3s ease;
        }
         .modal-overlay.visible .modal-content {
             transform: translateY(0);
         }

        .modal-header {
             display: flex; justify-content: space-between; align-items: center;
             border-bottom: 1px solid #e0e0e0; /* Light border */
             padding-bottom: 15px; margin-bottom: 20px;
        }
         .modal-header h3 {
             font-size: 1.2rem; font-weight: 600; margin: 0; color: #333;
         }
         .modal-close {
             background-color: #f0f0f0; 
             border: 1px solid #ccc; 
             border-radius: 4px; 
             width: 30px; height: 30px; /* Fixed size for the square */
             display: flex; justify-content: center; align-items: center;
             font-size: 1rem; /* Size of the 'x' icon */
             cursor: pointer;
             color: #555; /* Darker icon color */
             transition: background-color 0.2s, border-color 0.2s;
         }
         .modal-close:hover { background-color: #e0e0e0; border-color: #bbb; }


        .modal-body .info-field { /* Use info-field for modal form layout */
            margin-bottom: 20px;
        }

         /* Container for icon and input inside modal, matching image */
         .modal-body .icon-input-container {
             display: flex;
             align-items: center;
             width: 100%;
             padding: 0; /* Remove padding from container */
             border: 1px solid var(--input-border, #e0e0e0); /* Border on container */
             border-radius: 4px; /* Slightly less rounded than card? Matches image inputs */
             background-color: var(--profile-info-field-bg, #f8f6fc); /* Light background on container */
             box-sizing: border-box;
             overflow: hidden;
         }
          .modal-body .icon-input-container .icon {
             color: var(--text-secondary, #666); opacity: 0.8; margin: 0 10px;
         }

         /* Style for input fields inside the icon-input-container */
         .modal-body .icon-input-container input[type="text"],
         .modal-body .icon-input-container input[type="email"],
         .modal-body .icon-input-container input[type="tel"] {
             flex-grow: 1;
             padding: 10px 0; 
             border: none; /* Remove border from input */
             background-color: transparent; /* Transparent background */
             font-size: 1rem;
             color: var(--text-primary, #333);
             outline: none; /* Remove default outline */
             transition: none; /* Remove transition */
         }
         /* Add a focus style on the *container* instead of the input */
         .modal-body .icon-input-container:focus-within {
             border-color: var(--primary-purple, #7e57c2);
             box-shadow: 0 0 0 2px rgba(126, 87, 194, 0.2); /* Light purple glow */
         }


        .modal-footer {
             display: flex; justify-content: flex-end; gap: 10px;
             padding-top: 20px;
        }
         .modal-footer button {
             padding: 10px 20px; border-radius: 4px; /* Slightly rounded corners for buttons */
             font-size: 0.95rem; cursor: pointer;
             transition: background-color 0.2s, opacity 0.2s;
             min-width: 80px; /* Ensure buttons aren't too small */
             text-align: center;
         }
         .modal-footer .cancel-btn {
             background-color: #e0e0e0; color: #333; border: 1px solid #ccc;
         }
         .modal-footer .cancel-btn:hover { background-color: #d5d5d5; border-color: #bbb; }

         .modal-footer .save-btn {
             background-color: var(--button-bg, #7e57c2); color: var(--button-text, #fff); border: none;
         }
         .modal-footer .save-btn:hover { background-color: var(--button-hover-bg, #673ab7); }
         .modal-footer .save-btn:disabled {
             opacity: 0.6; cursor: not-allowed;
         }


        /* --- Responsive --- */
        @media (max-width: 768px) {
             .page-container { padding: 0 15px; margin-top: 20px;}
             .profile-header h1 { font-size: 1.6rem; }
             .info-grid { grid-template-columns: 1fr; }
             .personal-info-card { padding: 25px; }
             .edit-btn { width: 100%; min-width: auto; }
             .modal-content { padding: 20px; max-width: 95%; } /* Adjust modal padding and width */
             .modal-body .info-field { margin-bottom: 15px; }
             .global-message-area { padding: 0 15px; }
             .modal-footer button { min-width: auto; padding: 10px 15px; } /* Adjust modal button padding */
             .modal-footer { justify-content: space-around; gap: 5px;} /* Adjust footer layout */
        }

    </style>
</head>
<body>

    <%@ include file="/WEB-INF/pages/navbar.jsp" %>

    <div class="page-container">
        <header class="profile-header">
            <h1>My Profile</h1>
           
        </header>

         <%-- Global Message Area (outside the info card) --%>
         <div class="global-message-area">
             <%-- Display Messages (from session after redirect) --%>
             <c:if test="${not empty sessionScope.errorMessage}">
                 <p class="error-message">${sessionScope.errorMessage}</p>
                 <c:remove var="errorMessage" scope="session"/> <%-- Remove message after displaying --%>
             </c:if>
              <c:if test="${not empty sessionScope.successMessage}">
                 <p class="success-message">${sessionScope.successMessage}</p>
                 <c:remove var="successMessage" scope="session"/> <%-- Remove message after displaying --%>
             </c:if>
         </div>


        <%-- Personal Info Card (Displays current read-only info) --%>
        <section class="personal-info-card">
            <h2>Personal Information</h2>
            <p class="subtitle">View your account details.</p>

            <div class="info-grid">
                <div class="info-field">
                    <label>Full Name</label>
                     <%-- Read-only display div --%>
                     <div class="value-display">
                         <i class="fas fa-user icon"></i>
                         <span id="display-username"><c:out value='${userProfile.username}'/></span>
                     </div>
                </div>
                <div class="info-field">
                    <label>Email Address</label>
                     <%-- Read-only display div --%>
                     <div class="value-display">
                         <i class="fas fa-envelope icon"></i>
                         <span id="display-email"><c:out value='${userProfile.email}'/></span>
                     </div>
                </div>
                 <div class="info-field">
                    <label>Phone Number</label>
                     <%-- Read-only display div --%>
                     <div class="value-display">
                         <i class="fas fa-phone icon"></i>
                         <span id="display-phone">
                             <c:choose>
                                 <c:when test="${not empty userProfile.phone}"><c:out value="${userProfile.phone}"/></c:when>
                                 <c:otherwise><span class="not-provided">Not Provided</span></c:otherwise>
                             </c:choose>
                         </span>
                     </div>
                </div>
                 <div class="info-field">
                    <label>Joined On</label>
                    <%-- This field is always read-only --%>
                    <div class="value-display">
                         <i class="fas fa-calendar-alt icon"></i>
                         <c:if test="${not empty userProfile.createdAt}">
                            <fmt:formatDate value="${userProfile.createdAt}" pattern="MMMM dd, yyyy"/>
                         </c:if>
                         <c:if test="${empty userProfile.createdAt}"> N/A </c:if>
                    </div>
                </div>
            </div>

            <div class="info-actions">
                 <%-- Button to open the modal --%>
                 <button type="button" id="openEditModalBtn" class="edit-btn"><i class="fas fa-pencil-alt icon"></i> Edit Information</button>
            </div>
        </section>

    </div> <%-- End Page Container --%>

    
    <div id="editProfileModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Personal Information</h3>
                <button type="button" class="modal-close"><i class="fas fa-times"></i></button>
            </div>
            <div class="modal-body">
               
                 <div id="modal-message-area"></div>

                 <%-- Form for editing --%>
                <form id="editProfileForm" method="POST" action="${pageContext.request.contextPath}/profile">
                    <%-- Hidden user ID input --%>
                    <input type="hidden" id="modal-userId" name="userId" value="${userProfile.id}">

                    <div class="info-field">
                        <label for="modal-username">Full Name</label>
                         <%-- Container for icon and input --%>
                         <div class="icon-input-container">
                             <i class="fas fa-user icon"></i>
                             <input type="text" id="modal-username" name="username" required>
                         </div>
                         
                    </div>
                    <div class="info-field">
                        <label for="modal-email">Email Address</label>
                         <%-- Container for icon and input --%>
                         <div class="icon-input-container">
                             <i class="fas fa-envelope icon"></i>
                             <input type="email" id="modal-email" name="email" required>
                         </div>
                          
                    </div>
                    <div class="info-field">
                        <label for="modal-phone">Phone Number</label>
                         <%-- Container for icon and input --%>
                         <div class="icon-input-container">
                             <i class="fas fa-phone icon"></i>
                             <input type="tel" id="modal-phone" name="phone">
                         </div>
                        
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="cancel-btn" id="cancelEditModalBtn">Cancel</button>
              
                <button type="submit" form="editProfileForm" class="save-btn" id="saveChangesModalBtn">Save Changes</button>
            </div>
        </div>
    </div>


    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const openEditModalBtn = document.getElementById('openEditModalBtn');
            const editProfileModal = document.getElementById('editProfileModal');
            const modalCloseBtn = editProfileModal.querySelector('.modal-close');
            const cancelEditModalBtn = document.getElementById('cancelEditModalBtn');
            const editProfileForm = document.getElementById('editProfileForm');
            const modalMessageArea = document.getElementById('modal-message-area'); // Area for modal specific messages
             const saveChangesModalBtn = document.getElementById('saveChangesModalBtn'); // Reference to the Save button


            // Get references to display elements (by ID)
            const displayUsernameSpan = document.getElementById('display-username');
            const displayEmailSpan = document.getElementById('display-email');
            const displayPhoneSpan = document.getElementById('display-phone');

            // Get references to modal input fields (by ID)
            const modalUserIdInput = document.getElementById('modal-userId');
            const modalUsernameInput = document.getElementById('modal-username');
            const modalEmailInput = document.getElementById('modal-email');
            const modalPhoneInput = document.getElementById('modal-phone');


            // --- Modal Functions ---
            function openModal() {
               
                modalMessageArea.innerHTML = '';
                 clearValidationErrors(); 

                
                modalUserIdInput.value = '${userProfile.id}'; // User ID is static from JSP variable

                modalUsernameInput.value = displayUsernameSpan.textContent.trim();
                modalEmailInput.value = displayEmailSpan.textContent.trim();

                // Handle phone: if the display text is 'Not Provided', the modal field should be empty
                 const currentPhoneDisplay = displayPhoneSpan.textContent.trim();
                 if (currentPhoneDisplay === 'Not Provided' || currentPhoneDisplay === '') {
                     modalPhoneInput.value = '';
                 } else {
                     modalPhoneInput.value = currentPhoneDisplay;
                 }

                editProfileModal.classList.add('visible'); 
                 document.body.classList.add('modal-open'); 
            }

            function closeModal() {
                editProfileModal.classList.remove('visible'); 
                 document.body.classList.remove('modal-open'); 
                editProfileForm.reset(); 
                modalMessageArea.innerHTML = ''; // Clear messages
                 clearValidationErrors(); // Clear validation errors
            }

            // Helper function to clear validation errors (remove error classes, hide spans)
             function clearValidationErrors() {
                 editProfileForm.querySelectorAll('input').forEach(input => {
                     input.classList.remove('error'); // Remove error class
                 });
                
             }


            // --- Event Listeners ---

            // Open modal button click
            openEditModalBtn.addEventListener('click', openModal);

            // Close modal buttons click
            modalCloseBtn.addEventListener('click', closeModal);
            cancelEditModalBtn.addEventListener('click', closeModal);

            // Close modal if clicking outside (on the overlay itself)
            editProfileModal.addEventListener('click', function(event) {
                if (event.target === editProfileModal) { // Check if click is directly on overlay
                    closeModal();
                }
            });

            // Close modal when pressing Escape key
            document.addEventListener('keydown', function(event) {
                 if (event.key === 'Escape' && editProfileModal.classList.contains('visible')) {
                     closeModal();
                 }
             });

           
            editProfileForm.addEventListener('submit', function(event) {
                
                 saveChangesModalBtn.disabled = true;
                 saveChangesModalBtn.textContent = 'Saving...';
            });

            

        });
    </script>

</body>
</html>