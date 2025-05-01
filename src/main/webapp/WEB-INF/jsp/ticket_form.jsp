<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Create Ticket</title>
  <script>
    // live counters for subject (100) & description (1000)
    function updateCounts() {
      const subjectEl = document.getElementById('subject');
      const descEl    = document.getElementById('description');
      document.getElementById('subCount').textContent  = subjectEl.value.length + '/100';
      document.getElementById('descCount').textContent = descEl.value.length     + '/1000';
    }
    document.addEventListener('DOMContentLoaded', updateCounts);
  </script>
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

  <!-- Create Ticket Form -->
  <main class="flex-1 flex items-center justify-center p-8 overflow-auto">
    <div class="w-full max-w-lg bg-white rounded-2xl shadow-lg p-8">
      <h2 class="text-2xl font-semibold mb-6 text-center">Create Ticket</h2>

      <form action="${pageContext.request.contextPath}/tickets/create"
            method="post"
            class="space-y-6"
            oninput="updateCounts()">

        <!-- Subject (max 100) -->
        <div>
          <label for="subject" class="block text-sm font-medium text-gray-700">
            Subject (<span id="subCount">0/100</span>)
          </label>
          <input id="subject"
                 name="subject"
                 type="text"
                 required
                 maxlength="100"
                 class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:ring-2 focus:ring-blue-500 break-words"/>
        </div>

        <!-- Description (max 1000) -->
        <div>
          <label for="description" class="block text-sm font-medium text-gray-700">
            Description (<span id="descCount">0/1000</span>)
          </label>
          <textarea id="description"
                    name="description"
                    rows="5"
                    required
                    maxlength="1000"
                    class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:ring-2 focus:ring-blue-500 whitespace-pre-line break-words"
                    placeholder="Describe your issue…"></textarea>
        </div>

        <button type="submit"
                class="w-full rounded-lg bg-blue-600 py-2 font-semibold text-white shadow hover:bg-blue-700 focus:ring-2 focus:ring-blue-500">
          Submit Ticket
        </button>
      </form>
    </div>
  </main>
</body>
</html>
