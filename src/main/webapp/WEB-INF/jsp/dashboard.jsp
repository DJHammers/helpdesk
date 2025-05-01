<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Dashboard</title>
</head>
<body class="flex h-screen bg-gray-50">
  <!-- Sidebar -->
  <aside class="w-64 bg-white border-r flex flex-col justify-between">
    <div>
      <div class="p-6">
        <h2 class="text-2xl font-bold">Help Desk</h2>
      </div>
      <nav class="mt-6 space-y-2">
        <!-- Admin-only links -->
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

        <!-- Visible to all authenticated users -->
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
    <h2 class="text-2xl font-semibold mb-6">Ticket Status Overview</h2>

    <c:if test="${isAdmin}">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <c:forEach var="entry" items="${statusCounts.entrySet()}">
          <c:set var="status" value="${entry.key}" />
          <c:set var="count"  value="${entry.value}" />
          <a href="${pageContext.request.contextPath}/tickets?status=${status}"
             class="block p-6 bg-white rounded-lg shadow hover:shadow-lg transition">
            <div class="text-sm font-medium text-gray-500 uppercase mb-2">
              ${status.replace('_',' ')}
            </div>
            <div class="text-3xl font-bold">${count}</div>
          </a>
        </c:forEach>
      </div>
    </c:if>
  </main>
</body>
</html>
