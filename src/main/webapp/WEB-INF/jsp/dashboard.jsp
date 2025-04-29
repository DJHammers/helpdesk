<%@ page session="false" contentType="text/html; charset=UTF-8" %>
  <%@ page import="java.util.List,lk.helpdesk.support.model.User,lk.helpdesk.support.model.Ticket" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1.0" />
        <script src="https://cdn.tailwindcss.com"></script>
        <title>Dashboard</title>
      </head>

      <body class="flex h-screen bg-gray-100">
        <aside class="w-64 bg-white shadow-md flex flex-col justify-between">
          <div>
            <div class="p-6">
              <h2 class="text-xl font-bold">Helpdesk</h2>
            </div>
            <nav class="mt-6">
              <a href="${pageContext.request.contextPath}/dashboard?view=tickets"
                class="block py-2 px-6 hover:bg-gray-200 ${view=='tickets'?'bg-gray-200':''}">
                View Tickets
              </a>
              <c:if test="${isAdmin}">
                <a href="${pageContext.request.contextPath}/dashboard?view=users"
                  class="block py-2 px-6 hover:bg-gray-200 ${view=='users'?'bg-gray-200':''}">
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
            <c:when test="${view=='users'}">
              <div class="flex justify-between items-center mb-4">
                <h2 class="text-2xl font-semibold">Manage Users</h2>
                <a href="${pageContext.request.contextPath}/admin/users/add"
                  class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
                  Add User
                </a>
              </div>
              <table class="min-w-full bg-white border">
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
                          <button onclick="return confirm('Delete?')"
                            class="text-red-600 hover:underline">Delete</button>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty usersList}">
                    <tr>
                      <td colspan="5" class="text-center py-4 text-gray-500">No users found.</td>
                    </tr>
                  </c:if>
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
              <form method="get" action="${pageContext.request.contextPath}/dashboard"
                class="mb-4 flex items-center space-x-2">
                <input type="hidden" name="view" value="tickets" />
                <label>Status:</label>
                <select name="status" onchange="this.form.submit()" class="border px-2 py-1 rounded">
                  <option value="" ${statusFilter=='' ?'selected':''}>All</option>
                  <option value="Open" ${statusFilter=='Open' ?'selected':''}>Open</option>
                  <option value="In_Progress" ${statusFilter=='In_Progress' ?'selected':''}>In_Progress</option>
                  <option value="Resolved" ${statusFilter=='Resolved' ?'selected':''}>Resolved</option>
                  <option value="Close" ${statusFilter=='Close' ?'selected':''}>Close</option>
                  <c:if test="${isAdmin}">
                    <option value="ASSIGNED_Admin" ${statusFilter=='ASSIGNED_Admin' ?'selected':''}>
                      Assigned to Admin
                    </option>
                  </c:if>
                  <c:if test="${!isAdmin}">
                    <option value="ASSIGNED_Support" ${statusFilter=='ASSIGNED_Support' ?'selected':''}>
                      Assigned to Support
                    </option>
                  </c:if>
                </select>
              </form>
              <table class="min-w-full bg-white border">
                <thead>
                  <tr class="bg-gray-100">
                    <th class="px-4 py-2 border">ID</th>
                    <th class="px-4 py-2 border">User</th>
                    <th class="px-4 py-2 border">Subject</th>
                    <th class="px-4 py-2 border">Status</th>
                    <th class="px-4 py-2 border">Assigned</th>
                    <th class="px-4 py-2 border">Assign To</th>
                    <th class="px-4 py-2 border">Created At</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="t" items="${ticketsList}">
                    <tr onclick="window.location='${pageContext.request.contextPath}/tickets/view?id=${t.id}'"
                      class="hover:bg-gray-50 cursor-pointer">
                      <td class="border px-4 py-2">${t.id}</td>
                      <td class="border px-4 py-2">${t.username}</td>
                      <td class="border px-4 py-2">${t.subject}</td>
                      <td class="border px-4 py-2">${t.status}</td>
                      <td class="border px-4 py-2">${t.assignedRole}</td>
                      <td class="border px-4 py-2">
                        <c:if test="${role=='Admin' or role=='Support'}">
                          <form action="${pageContext.request.contextPath}/tickets/assign" method="post"
                            class="flex items-center space-x-1">
                            <input type="hidden" name="ticketId" value="${t.id}" />
                            <select name="role" class="border px-2 py-1 rounded">
                              <option value="Support" ${t.assignedRole=='Support' ?'selected':''}>Support</option>
                              <option value="Admin" ${t.assignedRole=='Admin' ?'selected':''}>Admin</option>
                            </select>
                            <button type="submit" class="px-2 py-1 bg-green-600 text-white rounded">OK</button>
                          </form>
                        </c:if>
                      </td>
                      <td class="border px-4 py-2">${t.createdAt}</td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty ticketsList}">
                    <tr>
                      <td colspan="7" class="text-center py-4 text-gray-500">No tickets found.</td>
                    </tr>
                  </c:if>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </main>
      </body>

      </html>