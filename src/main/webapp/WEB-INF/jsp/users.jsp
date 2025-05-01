<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, lk.helpdesk.support.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Manage Users</title>
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

  <!-- Manage Users Content -->
  <main class="flex-1 p-6 overflow-auto">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-2xl font-semibold">Manage Users</h2>
      <c:if test="${isAdmin}">
        <a href="${pageContext.request.contextPath}/users/add"
           class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm font-medium">
          Add User
        </a>
      </c:if>
    </div>
    <div class="overflow-hidden rounded-lg border bg-white shadow">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Username</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Role</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <c:forEach var="u" items="${usersList}">
            <tr class="hover:bg-gray-50">
              <td class="px-4 py-2 text-sm text-gray-700">${u.id}</td>
              <td class="px-4 py-2 text-sm text-gray-700">${u.username}</td>
              <td class="px-4 py-2 text-sm text-gray-700">${u.email}</td>
              <td class="px-4 py-2 text-sm text-gray-700">${u.role}</td>
              <td class="px-4 py-2 space-x-2 text-sm">
                <c:if test="${isAdmin}">
                  <a href="${pageContext.request.contextPath}/users/edit?id=${u.id}"
                     class="inline-flex px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 text-xs font-medium">
                    Edit
                  </a>
                  <form method="post" action="${pageContext.request.contextPath}/users/delete"
                        class="inline" onsubmit="return confirm('Delete this user?');">
                    <input type="hidden" name="id" value="${u.id}"/>
                    <button type="submit"
                            class="inline-flex px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-xs font-medium">
                      Delete
                    </button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty usersList}">
            <tr>
              <td colspan="5" class="px-4 py-4 text-center text-sm text-gray-500">No users found.</td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </main>
</body>
</html>
