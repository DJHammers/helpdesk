<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List,lk.helpdesk.support.model.User,lk.helpdesk.support.model.Ticket" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Admin Dashboard</title>
</head>
<body class="flex h-screen bg-gray-100">
  <!-- Sidebar -->
  <aside class="w-64 bg-white shadow-md">
    <div class="p-6">
      <h2 class="text-xl font-bold">Helpdesk Admin</h2>
    </div>
    <nav class="mt-6">
      <a href="${pageContext.request.contextPath}/dashboard?view=users"
         class="block py-2 px-6 text-gray-700 hover:bg-gray-200">Manage Users</a>
      <a href="${pageContext.request.contextPath}/dashboard?view=tickets"
         class="block py-2 px-6 text-gray-700 hover:bg-gray-200">View Tickets</a>
    </nav>
  </aside>

  <!-- Main Content -->
  <main class="flex-1 p-8 overflow-auto">
    <c:choose>
      <c:when test="${param.view == 'tickets'}">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-2xl font-semibold">Tickets</h2>
        </div>
        <table class="min-w-full bg-white">
          <thead>
            <tr class="bg-gray-100">
              <th class="px-4 py-2 border">ID</th>
              <th class="px-4 py-2 border">User</th>
              <th class="px-4 py-2 border">Subject</th>
              <th class="px-4 py-2 border">Status</th>
              <th class="px-4 py-2 border">Created At</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="t" items="${ticketsList}">
              <tr class="hover:bg-gray-50">
                <td class="border px-4 py-2">${t.id}</td>
                <td class="border px-4 py-2">${t.username}</td>
                <td class="border px-4 py-2">${t.subject}</td>
                <td class="border px-4 py-2">${t.status}</td>
                <td class="border px-4 py-2">${t.createdAt}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:when>

      <c:otherwise>
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-2xl font-semibold">Manage Users</h2>
          <a href="${pageContext.request.contextPath}/admin/users/add"
             class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">Add User</a>
        </div>
        <table class="min-w-full bg-white">
          <thead>
            <tr class="bg-gray-100">
              <th class="px-4 py-2 border">ID</th>
              <th class="px-4 py-2 border">Username</th>
              <th class="px-4 py-2 border">Email</th>
              <th class="px-4 py-2 border">Role</th>
              <th class="px-4 py-2 border">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="u" items="${usersList}">
              <tr class="hover:bg-gray-50">
                <td class="border px-4 py-2">${u.id}</td>
                <td class="border px-4 py-2">${u.username}</td>
                <td class="border px-4 py-2">${u.email}</td>
                <td class="border px-4 py-2">${u.role}</td>
                <td class="border px-4 py-2 space-x-2">
                  <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}"
                     class="text-blue-600 hover:underline">Edit</a>
                  <form method="post" action="${pageContext.request.contextPath}/admin/users/delete"
                        style="display:inline">
                    <input type="hidden" name="id" value="${u.id}" />
                    <button onclick="return confirm('Delete this user?')"
                            class="text-red-600 hover:underline">Delete</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </main>
</body>
</html>
