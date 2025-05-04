<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="lk.helpdesk.support.model.Contact" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Contact Message Detail – Help Desk</title>
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
    <a href="${pageContext.request.contextPath}/viewContact"
       class="inline-flex items-center text-sm text-[#1b87e7] hover:underline mb-4">
      ← Back to All Messages
    </a>

    <div class="flex items-center justify-between mb-4">
      <h2 class="text-2xl font-semibold text-gray-800">Contact Message Detail</h2>
    </div>

    <!-- Outer container -->
    <div class="bg-white border border-[#1b87e7] rounded-lg ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20 p-6 max-w-4xl mx-auto">
      <h1 class="text-2xl font-semibold mb-6 text-gray-800">Contact Message Detail</h1>
      
      <!-- Grid of boxes -->
      <dl class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <div class="border border-[#1b87e7] rounded-lg p-4">
          <dt class="text-xs font-medium text-gray-500 uppercase">Name</dt>
          <dd class="mt-1 text-sm text-gray-900 break-words">${contact.name}</dd>
        </div>
        
        <!-- Email -->
        <div class="border border-[#1b87e7] rounded-lg p-4">
          <dt class="text-xs font-medium text-gray-500 uppercase">Email</dt>
          <dd class="mt-1 text-sm text-gray-900 break-words">${contact.email}</dd>
        </div>
        
        <!-- Subject (full width) -->
        <div class="sm:col-span-2 border border-[#1b87e7] rounded-lg p-4">
          <dt class="text-xs font-medium text-gray-500 uppercase">Subject</dt>
          <dd class="mt-1 text-sm text-gray-900 break-words">${contact.subject}</dd>
        </div>
        
        <!-- Date -->
        <div class="border border-[#1b87e7] rounded-lg p-4">
          <dt class="text-xs font-medium text-gray-500 uppercase">Date</dt>
          <dd class="mt-1 text-sm text-gray-800">
            <fmt:formatDate value="${contact.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
          </dd>
        </div>
        
        <!-- Message (full width) -->
        <div class="sm:col-span-2 border border-[#1b87e7] rounded-lg p-4">
          <dt class="text-xs font-medium text-gray-500 uppercase">Message</dt>
          <dd class="mt-1 text-sm text-gray-900 whitespace-pre-wrap break-words">
            <c:out value="${contact.message}"/>
          </dd>
        </div>
      </dl>
    </div>
  </main>
</body>
</html>
