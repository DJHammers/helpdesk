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
<body class="bg-gray-50 p-6">
  <div class="max-w-3xl mx-auto space-y-6">

    <!-- Back to Dashboard -->
    <div>
      <a href="${pageContext.request.contextPath}/dashboard"
       class="inline-flex items-center text-sm text-blue-600 hover:underline mb-4">
      ← Back to Dashboard
        </a>
    </div>

    <h1 class="text-2xl font-bold">All Feedback</h1>

    <!-- Feedback cards -->
    <c:forEach var="fb" items="${feedbackList}">
      <div class="bg-white p-4 rounded-lg shadow">
        <div class="flex justify-between items-center mb-2">
          <span class="font-medium text-lg">${fb.username}</span>
          <span class="text-sm text-gray-500">
            <fmt:formatDate value="${fb.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
          </span>
        </div>

        <!-- Star rating -->
        <div class="flex space-x-1 mb-3 text-xl">
          <c:forEach var="i" begin="1" end="5">
            <span class="${i <= fb.rating ? 'text-yellow-400' : 'text-gray-300'}">
              &#9733;
            </span>
          </c:forEach>
        </div>

        <p class="whitespace-pre-line text-gray-800">${fb.message}</p>
      </div>
    </c:forEach>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
      <div class="flex justify-center items-center space-x-4 mt-6">
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

  </div>
</body>
</html>
