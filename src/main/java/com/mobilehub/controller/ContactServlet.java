package com.mobilehub.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/contact") 
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // forward the request to the contact.jsp page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/contact.jsp");
        dispatcher.forward(request, response);
    }

    

    @Override
    public String getServletInfo() {
        return "Servlet that serves the Contact Us page.";
    }
}