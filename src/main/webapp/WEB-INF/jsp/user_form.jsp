<%@ page contentType="text/html; charset=UTF-8" %>
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
<body class="bg-gray-50 flex items-center justify-center min-h-screen">
  <div class="w-full max-w-md bg-white rounded-2xl shadow-lg p-8">
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

    <form action="${pageContext.request.contextPath}/admin/users/${empty user ? 'add' : 'edit'}"
          method="post" class="space-y-6">
      <c:if test="${not empty user}">
        <input type="hidden" name="id" value="${user.id}" />
      </c:if>

      <div class="space-y-1">
        <label for="username" class="text-sm font-medium text-gray-700">Username</label>
        <input id="username" name="username" type="text" required value="${user.username}"
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>

      <div class="space-y-1">
        <label for="email" class="text-sm font-medium text-gray-700">Email</label>
        <input id="email" name="email" type="email" required value="${user.email}"
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>

      <div class="space-y-1">
        <label for="role" class="text-sm font-medium text-gray-700">Role</label>
        <select id="role" name="role" required
                class="block w-full rounded-lg border border-gray-300 bg-white px-3 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
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
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>

      <button type="submit"
              class="w-full rounded-lg bg-blue-600 py-2 font-semibold text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
        <c:choose>
          <c:when test="${not empty user}">Update User</c:when>
          <c:otherwise>Create User</c:otherwise>
        </c:choose>
      </button>
    </form>
  </div>
</body>
</html>
