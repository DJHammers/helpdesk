<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Contact Us – Help Desk Support System</title>
</head>
<body class="flex h-screen bg-white">
  <!-- Sidebar -->
  <aside class="w-64 bg-[#1b87e7] flex flex-col justify-between">
    <div>
      <div class="p-6 flex items-center">
        <img
          src="${pageContext.request.contextPath}/images/helpdesk.png"
          alt="Help Desk Logo"
          class="h-10 w-10 mr-3"
        />
        <h2 class="text-2xl font-bold text-white">Help Desk</h2>
      </div>
      <nav class="mt-6 space-y-2 px-2">
        <c:if test="${isAdmin}">
          <a href="${pageContext.request.contextPath}/dashboard"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/dashboard' ? 'bg-[#156ab0]' : ''}">
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/users"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/users' ? 'bg-[#156ab0]' : ''}">
            Manage Users
          </a>
          <a href="${pageContext.request.contextPath}/viewContact"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/viewContact' ? 'bg-[#156ab0]' : ''}">
            View Contacts
          </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/tickets"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/tickets' ? 'bg-[#156ab0]' : ''}">
          View Tickets
        </a>
        <a href="${pageContext.request.contextPath}/profile"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition">
          My Profile
        </a>
        <a href="${pageContext.request.contextPath}/feedback"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/feedback' ? 'bg-[#156ab0]' : ''}">
          Feedback
        </a>
        <a href="${pageContext.request.contextPath}/viewFeedback"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/viewFeedback' ? 'bg-[#156ab0]' : ''}">
          View Feedback
        </a>
        <a href="${pageContext.request.contextPath}/contact"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/contact' ? 'bg-[#156ab0]' : ''}">
          Contact Us
        </a>
        <a href="${pageContext.request.contextPath}/aboutus"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/aboutus' ? 'bg-[#156ab0]' : ''}">
          About Us
        </a>
      </nav>
    </div>
    <div class="p-6">
      <a href="${pageContext.request.contextPath}/logout"
         class="block w-full text-center py-3 rounded-lg bg-white text-[#1b87e7] font-medium
                hover:bg-gray-100 transition">
        Sign Out
      </a>
    </div>
  </aside>

  <!-- Main Content -->
  <main class="flex-1 p-6 overflow-auto bg-white">
    <a href="${pageContext.request.contextPath}/dashboard"
       class="inline-flex items-center text-sm text-[#1b87e7] hover:underline mb-4">
      ← Back to Dashboard
    </a>

    <div class="max-w-lg mx-auto bg-white border border-[#1b87e7] rounded-lg ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm p-6 space-y-6">
      <h2 class="text-2xl font-semibold text-gray-800 mb-4">Contact Us</h2>

      <c:if test="${param.sent == 'true'}">
        <p class="text-sm text-green-600 mb-4">Thank you! Your message has been sent.</p>
      </c:if>
      <c:if test="${not empty error}">
        <p class="text-sm text-red-600 mb-4">${error}</p>
      </c:if>

      <form action="${pageContext.request.contextPath}/contact" method="post" class="space-y-6">
        <!-- Name -->
        <div>
          <label for="name" class="block text-sm font-medium mb-1">Name</label>
          <input
            id="name"
            type="text"
            name="name"
            required
            maxlength="100"
            class="w-full border border-gray-200 rounded p-2 
                   focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"
          />
          <div class="text-xs text-gray-500 mt-1">
            <span id="name-count">0</span>/100
          </div>
        </div>

        <!-- Email -->
        <div>
          <label for="email" class="block text-sm font-medium mb-1">Email</label>
          <input
            id="email"
            type="email"
            name="email"
            required
            maxlength="100"
            class="w-full border border-gray-200 rounded p-2 
                   focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"
          />
          <div class="text-xs text-gray-500 mt-1">
            <span id="email-count">0</span>/100
          </div>
        </div>

        <!-- Subject -->
        <div>
          <label for="subject" class="block text-sm font-medium mb-1">Subject</label>
          <input
            id="subject"
            type="text"
            name="subject"
            required
            maxlength="150"
            class="w-full border border-gray-200 rounded p-2 
                   focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"
          />
          <div class="text-xs text-gray-500 mt-1">
            <span id="subject-count">0</span>/150
          </div>
        </div>

        <!-- Message -->
        <div>
          <label for="message" class="block text-sm font-medium mb-1">Your Message</label>
          <textarea
            id="message"
            name="message"
            required
            maxlength="1000"
            class="w-full border border-gray-200 rounded p-2 h-32
                   focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"
          ></textarea>
          <div class="text-xs text-gray-500 mt-1">
            <span id="message-count">0</span>/1000
          </div>
        </div>

        <button
          type="submit"
          class="w-full px-4 py-2 bg-[#1b87e7] text-white rounded-lg hover:bg-[#1b87e7]/80 transition"
        >
          Send Message
        </button>
      </form>
    </div>
  </main>

  <script>
    document.addEventListener("DOMContentLoaded", () => {
      const fields = [
        { id: 'name', max: 100 },
        { id: 'email', max: 100 },
        { id: 'subject', max: 150 },
        { id: 'message', max: 1000 }
      ];

      fields.forEach(f => {
        const el = document.getElementById(f.id);
        const counter = document.getElementById(f.id + '-count');

        counter.textContent = el.value.length;
        el.addEventListener('input', () => {
          counter.textContent = el.value.length;
        });
      });
    });
  </script>
</body>
</html>
