<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, lk.helpdesk.support.model.Feedback" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>View Feedback</title>
</head>
<body class="flex h-screen bg-gray-50">
  <!-- Sidebar -->
  <aside class="w-64 bg-white border-r flex flex-col justify-between">
    <div>
      <div class="p-6"><h2 class="text-2xl font-bold">Help Desk</h2></div>
      <nav class="mt-6 space-y-2">
        <c:if test="${isAdmin}">
          <a href="${pageContext.request.contextPath}/dashboard"
             class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                    ${pageContext.request.servletPath=='/dashboard'?'bg-gray-100':''}">
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/users"
             class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                    ${pageContext.request.servletPath=='/users'?'bg-gray-100':''}">
            Manage Users
          </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/tickets"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                  ${pageContext.request.servletPath=='/tickets'?'bg-gray-100':''}">
          View Tickets
        </a>
        <a href="${pageContext.request.contextPath}/profile"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100">
          My Profile
        </a>
        <a href="${pageContext.request.contextPath}/feedback"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                  ${pageContext.request.servletPath=='/feedback'?'bg-gray-100':''}">
          Feedback
        </a>
        <a href="${pageContext.request.contextPath}/viewFeedback"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                  ${pageContext.request.servletPath=='/viewFeedback'?'bg-gray-100':''}">
          View Feedback
        </a>
      </nav>
    </div>
    <div class="p-6">
      <a href="${pageContext.request.contextPath}/logout"
         class="block w-full text-center py-3 bg-red-600 text-white rounded-lg hover:bg-red-700">
        Sign Out
      </a>
    </div>
  </aside>

  <!-- Main Content -->
  <main class="flex-1 p-6 overflow-auto">
    <!-- Back to Dashboard -->
    <a href="${pageContext.request.contextPath}/dashboard"
       class="inline-flex items-center text-sm text-blue-600 hover:underline mb-4">
      ← Back to Dashboard
    </a>

    <h1 class="text-2xl font-bold mb-6">All Feedback</h1>

    <!-- Updated feedback cards with tighter spacing -->
    <div class="space-y-4">
      <c:forEach var="fb" items="${feedbackList}">
        <div class="bg-white p-4 rounded-lg shadow">
          <div class="flex justify-between items-center mb-2">
            <span class="font-medium text-lg">${fb.username}</span>
            <span class="text-sm text-gray-500">
              <fmt:formatDate value="${fb.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
            </span>
          </div>
          <div class="flex space-x-1 mb-3 text-2xl">
            <c:forEach var="i" begin="1" end="5">
              <span class="${i <= fb.rating ? 'text-yellow-400' : 'text-gray-300'}">&#9733;</span>
            </c:forEach>
          </div>
          <p class="whitespace-pre-line text-gray-800">${fb.message}</p>
        </div>
      </c:forEach>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
      <div class="flex justify-center items-center space-x-4 mt-8">
        <c:if test="${currentPage > 1}">
          <a href="${pageContext.request.contextPath}/viewFeedback?page=${currentPage - 1}"
             class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300">
            Previous
          </a>
        </c:if>
        <span>Page ${currentPage} of ${totalPages}</span>
        <c:if test="${currentPage < totalPages}">
          <a href="${pageContext.request.contextPath}/viewFeedback?page=${currentPage + 1}"
             class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300">
            Next
          </a>
        </c:if>
      </div>
    </c:if>
  </main>
</body>
</html>
