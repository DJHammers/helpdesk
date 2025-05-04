<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, lk.helpdesk.support.model.Feedback" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>View Feedback – Help Desk Support System</title>
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
    <h1 class="text-2xl font-bold mb-6 text-gray-800">All Feedback</h1>
    <div class="space-y-4">
      <c:forEach var="fb" items="${feedbackList}">
        <div class="bg-white border border-[#1b87e7] rounded-lg ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20 p-4">
          <div class="flex justify-between items-center mb-2">
            <div class="flex items-center space-x-2">
              <div class="relative w-8 h-8 flex-shrink-0">
                <img
                  src="${pageContext.request.contextPath}/avatar?userId=${fb.userId}"
                  alt="${fb.username}"
                  class="w-8 h-8 rounded-full object-cover"
                  onerror="
                    this.style.display='none';
                    this.nextElementSibling.style.display='flex';
                  "/>
                <span class="absolute inset-0 hidden items-center justify-center rounded-full bg-[#1b87e7] text-white text-sm font-bold">
                  ${fn:toUpperCase(fn:substring(fb.username,0,1))}
                </span>
              </div>
              <span class="font-medium text-lg text-gray-800">${fb.username}</span>
            </div>
            <span class="text-sm text-gray-500">
              <fmt:formatDate value="${fb.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
            </span>
          </div>
          <div class="flex space-x-1 mb-3 text-2xl">
            <c:forEach var="i" begin="1" end="5">
              <span class="${i <= fb.rating ? 'text-yellow-400' : 'text-gray-300'}">&#9733;</span>
            </c:forEach>
          </div>
          <p class="whitespace-pre-line break-words text-gray-800">${fb.message}</p>
        </div>
      </c:forEach>
    </div>
    <c:if test="${totalPages > 1}">
      <div class="flex justify-center items-center space-x-4 mt-8">
        <c:if test="${currentPage > 1}">
          <a href="${pageContext.request.contextPath}/viewFeedback?page=${currentPage - 1}"
             class="px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-sm font-medium">
            Previous
          </a>
        </c:if>
        <span class="text-sm text-gray-800">Page ${currentPage} of ${totalPages}</span>
        <c:if test="${currentPage < totalPages}">
          <a href="${pageContext.request.contextPath}/viewFeedback?page=${currentPage + 1}"
             class="px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-sm font-medium">
            Next
          </a>
        </c:if>
      </div>
    </c:if>
  </main>
</body>
</html>
