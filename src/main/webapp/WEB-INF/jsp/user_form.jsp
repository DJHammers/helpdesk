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
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
  <div class="bg-white p-8 rounded shadow-md w-full max-w-md">
    <h2 class="text-2xl font-semibold mb-6">
      <c:choose>
        <c:when test="${not empty user}">Edit User</c:when>
        <c:otherwise>Add User</c:otherwise>
      </c:choose>
    </h2>

    <c:if test="${not empty errorMessage}">
      <div class="mb-4 p-3 bg-red-100 text-red-700 rounded">
        ${errorMessage}
      </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/users/${empty user ? 'add' : 'edit'}"
          method="post" class="space-y-4">
      <c:if test="${not empty user}">
        <input type="hidden" name="id" value="${user.id}" />
      </c:if>

      <div>
        <label class="block mb-1">Username</label>
        <input type="text" name="username"
               value="${user.username}"
               required
               class="w-full border px-3 py-2 rounded" />
      </div>

      <div>
        <label class="block mb-1">Email</label>
        <input type="email" name="email"
               value="${user.email}"
               required
               class="w-full border px-3 py-2 rounded" />
      </div>

      <div>
        <label class="block mb-1">Role</label>
        <select name="role" required class="w-full border px-3 py-2 rounded">
          <c:forEach var="r" items="${roles}">
            <option value="${r}" ${r == user.role ? 'selected' : ''}>${r}</option>
          </c:forEach>
        </select>
      </div>

      <div>
        <label class="block mb-1">
          <c:choose>
            <c:when test="${empty user}">Password</c:when>
            <c:otherwise>New Password (leave blank to keep current)</c:otherwise>
          </c:choose>
        </label>
        <input type="password" name="password"
               <c:if test="${empty user}">required</c:if>
               class="w-full border px-3 py-2 rounded" />
      </div>

      <button type="submit"
              class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
        <c:choose>
          <c:when test="${not empty user}">Update User</c:when>
          <c:otherwise>Create User</c:otherwise>
        </c:choose>
      </button>
    </form>
  </div>
</body>
</html>
