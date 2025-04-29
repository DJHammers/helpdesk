<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List,lk.helpdesk.support.model.User,lk.helpdesk.support.model.Ticket" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Dashboard</title>
</head>
<body class="flex h-screen bg-gray-100">
  <aside class="w-64 bg-white shadow-md flex flex-col justify-between">
    <div>
      <div class="p-6"><h2 class="text-xl font-bold">Helpdesk</h2></div>
      <nav class="mt-6">
        <a href="${pageContext.request.contextPath}/dashboard?view=tickets"
           class="block py-2 px-6 hover:bg-gray-200 ${!showUsers?'bg-gray-200':''}">
          View Tickets
        </a>
        <c:if test="${showUsers}">
          <a href="${pageContext.request.contextPath}/dashboard?view=users"
             class="block py-2 px-6 hover:bg-gray-200 ${showUsers?'bg-gray-200':''}">
            Manage Users
          </a>
        </c:if>
      </nav>
    </div>
    <div class="p-6">
      <a href="${pageContext.request.contextPath}/logout"
         class="block w-full text-center py-2 bg-red-600 text-white rounded hover:bg-red-700">
        Sign Out
      </a>
    </div>
  </aside>

  <main class="flex-1 p-8 overflow-auto">
    <c:choose>
      <c:when test="${showUsers}">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-2xl font-semibold">Manage Users</h2>
          <a href="${pageContext.request.contextPath}/admin/users/add"
             class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
            Add User
          </a>
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
                  <form method="post"
                        action="${pageContext.request.contextPath}/admin/users/delete"
                        style="display:inline">
                    <input type="hidden" name="id" value="${u.id}"/>
                    <button onclick="return confirm('Delete?')"
                            class="text-red-600 hover:underline">Delete</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:when>
      <c:otherwise>
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-2xl font-semibold">Tickets</h2>
          <a href="${pageContext.request.contextPath}/tickets/create"
             class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
            New Ticket
          </a>
        </div>
        <form method="get"
              action="${pageContext.request.contextPath}/dashboard"
              class="mb-4 flex items-center space-x-2">
          <input type="hidden" name="view" value="tickets"/>
          <label>Status:</label>
          <select name="status" onchange="this.form.submit()" class="border px-2 py-1 rounded">
            <option value=""  ${statusFilter==''?'selected':''}>All</option>
            <option value="OPEN"         ${statusFilter=='OPEN'?'selected':''}>OPEN</option>
            <option value="IN_PROGRESS"  ${statusFilter=='IN_PROGRESS'?'selected':''}>
              IN_PROGRESS
            </option>
            <option value="RESOLVED"     ${statusFilter=='RESOLVED'?'selected':''}>RESOLVED</option>
            <option value="CLOSED"       ${statusFilter=='CLOSED'?'selected':''}>CLOSED</option>
          </select>
        </form>
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
              <tr onclick="location.href='${pageContext.request.contextPath}/tickets/view?id=${t.id}'"
                  class="hover:bg-gray-50 cursor-pointer">
                <td class="border px-4 py-2">${t.id}</td>
                <td class="border px-4 py-2">${t.username}</td>
                <td class="border px-4 py-2">${t.subject}</td>
                <td class="border px-4 py-2">${t.status}</td>
                <td class="border px-4 py-2">${t.createdAt}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </main>
</body>
</html>
