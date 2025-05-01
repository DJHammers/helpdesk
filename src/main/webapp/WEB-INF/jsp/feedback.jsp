<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Submit Feedback</title>
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
    <a href="${pageContext.request.contextPath}/dashboard"
       class="inline-flex items-center text-sm text-blue-600 hover:underline mb-4">
      ← Back to Dashboard
    </a>

    <div class="max-w-xl bg-white p-6 rounded-lg shadow mx-auto">
      <h2 class="text-2xl font-semibold mb-4">Submit Feedback</h2>
      <form action="${pageContext.request.contextPath}/feedback" method="post" class="space-y-6">
        <textarea name="message" required maxlength="1000"
                  class="w-full h-32 border rounded p-2"
                  placeholder="Your feedback..."></textarea>

        <!-- Star Rating -->
        <div id="star-rating" class="flex space-x-1 mb-6">
          <c:forEach var="i" begin="1" end="5">
            <label class="cursor-pointer">
              <input type="radio" name="rating" value="${i}" class="hidden" ${i == 5 ? "checked" : ""}/>
              <svg data-value="${i}"
                class="star h-8 w-8 text-gray-300 cursor-pointer"
                xmlns="http://www.w3.org/2000/svg"
                fill="currentColor"
                viewBox="0 0 20 20">
                <path d="M9.049 2.927C9.259 2.194 10.741 2.194 10.951 2.927l1.286 3.97a1 1 0 00.95.69h4.18c.969 0 1.371 1.24.588 1.81l-3.388 2.462a1 1 0 00-.364 1.118l1.287 3.97c.3.921-.755 1.688-1.54 1.118l-3.388-2.462a1 1 0 00-1.175 0l-3.388 2.462c-.784.57-1.838-.197-1.539-1.118l1.286-3.97a1 1 0 00-.364-1.118L2.045 9.397c-.783-.57-.38-1.81.588-1.81h4.18a1 1 0 00.951-.69l1.285-3.97z"/>
            </svg>
            </label>
          </c:forEach>
        </div>

        <button type="submit"
                class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
          Submit Feedback
        </button>
      </form>
    </div>
  </main>

  <script>
    document.addEventListener("DOMContentLoaded", function() {
      const stars  = document.querySelectorAll(".star");
      const inputs = document.querySelectorAll("input[name='rating']");

      function updateStars(rating) {
        stars.forEach(star => {
          const val = parseInt(star.getAttribute("data-value"), 10);
          star.classList.toggle("text-yellow-400", val <= rating);
          star.classList.toggle("text-gray-300", val > rating);
        });
      }

      inputs.forEach(input =>
        input.addEventListener("change", e =>
          updateStars(parseInt(e.target.value, 10))
        )
      );

      const checked = document.querySelector("input[name='rating']:checked");
      if (checked) {
        updateStars(parseInt(checked.value, 10));
      }
    });
  </script>
</body>
</html>
