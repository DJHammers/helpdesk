<%@ page contentType="text/html; charset=UTF-8" %>
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
    <h1 class="text-2xl font-bold">All Feedback</h1>

    <c:forEach var="fb" items="${feedbackList}">
      <div class="bg-white p-4 rounded-lg shadow">
        <div class="flex justify-between items-center mb-2">
          <span class="font-medium text-lg">${fb.username}</span>
          <span class="text-sm text-gray-500">
            <fmt:formatDate value="${fb.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
          </span>
        </div>

        <!-- Display the star rating -->
        <div class="flex space-x-1 mb-3">
          <c:forEach var="i" begin="1" end="5">
            <svg xmlns="http://www.w3.org/2000/svg"
                 class="h-6 w-6 ${i <= fb.rating ? 'text-yellow-400' : 'text-gray-300'}"
                 fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927…"/>
            </svg>
          </c:forEach>
        </div>

        <p class="whitespace-pre-line text-gray-800">${fb.message}</p>
      </div>
    </c:forEach>
  </div>
</body>
</html>
