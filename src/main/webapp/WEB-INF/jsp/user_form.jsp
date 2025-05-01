<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="lk.helpdesk.support.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://cdn.tailwindcss.com"></script>
  <title>
    <c:choose>
      <c:when test="${not empty user}">Edit User</c:when>
      <c:otherwise>Add User</c:otherwise>
    </c:choose>
  </title>
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
        <a href="${pageContext.request.contextPath}/profile"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100">
          My Profile
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

  <!-- Main Content: User Form -->
  <main class="flex-1 p-8 overflow-auto">
    <div class="w-full max-w-md bg-white rounded-2xl shadow-lg mx-auto p-8">
      <h2 class="text-2xl font-semibold mb-6 text-center">
        <c:choose>
          <c:when test="${not empty user}">Edit User</c:when>
          <c:otherwise>Add User</c:otherwise>
        </c:choose>
      </h2>

      <c:if test="${not empty errorMessage}">
        <div class="mb-4 rounded-lg bg-red-100 px-4 py-3 text-red-700">
          ${errorMessage}
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/users/${empty user ? 'add' : 'edit'}"
            method="post" class="space-y-6">
        <c:if test="${not empty user}">
          <input type="hidden" name="id" value="${user.id}" />
        </c:if>

        <div class="space-y-1">
          <label for="username" class="text-sm font-medium text-gray-700">Username</label>
          <input id="username" name="username" type="text" required
                 value="${user.username}"
                 class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
        </div>

        <div class="space-y-1">
          <label for="email" class="text-sm font-medium text-gray-700">Email</label>
          <input id="email" name="email" type="email" required
                 value="${user.email}"
                 class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
        </div>

        <div class="space-y-1">
          <label for="role" class="text-sm font-medium text-gray-700">Role</label>
          <select id="role" name="role" required
                  class="block w-full rounded-lg border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            <c:forEach var="r" items="${roles}">
              <option value="${r}" ${r == user.role ? 'selected' : ''}>${r}</option>
            </c:forEach>
          </select>
        </div>

        <div class="space-y-1">
          <label for="password" class="text-sm font-medium text-gray-700">
            <c:choose>
              <c:when test="${empty user}">Password</c:when>
              <c:otherwise>New Password (leave blank to keep current)</c:otherwise>
            </c:choose>
          </label>
          <input id="password" name="password" type="password"
                 <c:if test="${empty user}">required</c:if>
                 class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
        </div>

        <button type="submit"
                class="w-full rounded-lg bg-blue-600 py-2 text-white font-semibold hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
          <c:choose>
            <c:when test="${not empty user}">Update User</c:when>
            <c:otherwise>Create User</c:otherwise>
          </c:choose>
        </button>
      </form>
    </div>
  </main>
</body>
</html>
