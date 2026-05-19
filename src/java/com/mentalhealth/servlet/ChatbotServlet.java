package com.mentalhealth.chatbot;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;


@WebServlet("/chat")
public class ChatbotServlet extends HttpServlet {
    public static class ChatMessage {
    private String sender;  // "user" or "bot"
    private String text;

    public ChatMessage(String sender, String text) {
        this.sender = sender;
        this.text = text;
    }
    public String getSender() { return sender; }
    public String getText() { return text; }
}

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
HttpSession session = request.getSession();

@SuppressWarnings("unchecked")
java.util.List<ChatbotServlet.ChatMessage> history =
        (java.util.List<ChatbotServlet.ChatMessage>) session.getAttribute("history");
if (history == null) {
    history = new java.util.ArrayList<>();
}

String userInput = request.getParameter("message");
if (userInput == null) userInput = "";

String botResponse = ResponseGenerator.generateEmpatheticResponse(userInput);

history.add(new ChatMessage("user", userInput));
history.add(new ChatMessage("bot", botResponse));

session.setAttribute("history", history);
request.getRequestDispatcher("index.jsp").forward(request, response);

    }
}