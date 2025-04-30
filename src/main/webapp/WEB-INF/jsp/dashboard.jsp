<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, lk.helpdesk.support.model.User, lk.helpdesk.support.model.Ticket" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  <%-- added for date formatting --%>
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
      <!-- Reduced spacing for a tighter nav -->
      <nav class="mt-6 space-y-2">
        <a href="${pageContext.request.contextPath}/dashboard?view=tickets"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100 ${view=='tickets'?'bg-gray-100':''}">
          View Tickets
        </a>
        <c:if test="${isAdmin}">
          <a href="${pageContext.request.contextPath}/dashboard?view=users"
             class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100 ${view=='users'?'bg-gray-100':''}">
            Manage Users
          </a>
        </c:if>

        <!-- NEW  My Profile Link -->
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

  <!-- Main Content -->
  <main class="flex-1 p-6 overflow-auto">
    <c:choose>
      <c:when test="${view=='users'}">
        <!-- Tighter header margin -->
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-2xl font-semibold">Manage Users</h2>
          <a href="${pageContext.request.contextPath}/admin/users/add"
             class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm font-medium">
            Add User
          </a>
        </div>
        <div class="overflow-hidden rounded-lg border bg-white shadow">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Username</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
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
                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}"
                       class="inline-flex px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 text-xs font-medium">
                      Edit
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/admin/users/delete"
                          class="inline" onsubmit="return confirm('Delete this user?');">
                      <input type="hidden" name="id" value="${u.id}" />
                      <button type="submit"
                              class="inline-flex px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-xs font-medium">
                        Delete
                      </button>
                    </form>
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
      </c:when>
      <c:otherwise>
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-2xl font-semibold">Tickets</h2>
          <a href="${pageContext.request.contextPath}/tickets/create"
             class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm font-medium">
            New Ticket
          </a>
        </div>
        <form method="get" action="${pageContext.request.contextPath}/dashboard"
              class="mb-4 flex flex-wrap gap-4 items-center">
          <input type="hidden" name="view" value="tickets" />
          <label for="status" class="text-sm font-medium text-gray-700">Status:</label>
          <select id="status" name="status" onchange="this.form.submit()"
                  class="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
            <option value="" ${statusFilter=='' ?'selected':''}>All</option>
            <option value="Open" ${statusFilter=='Open' ?'selected':''}>Open</option>
            <option value="In_Progress" ${statusFilter=='In_Progress' ?'selected':''}>In Progress</option>
            <option value="Resolved" ${statusFilter=='Resolved' ?'selected':''}>Resolved</option>
            <option value="Closed" ${statusFilter=='Closed' ?'selected':''}>Closed</option>
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
        <div class="overflow-hidden rounded-lg border bg-white shadow">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Requester</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Subject</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Assigned</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Assign To</th>
                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Created&nbsp;At</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <c:forEach var="t" items="${ticketsList}">
                <tr class="hover:bg-gray-50 cursor-pointer"
                    onclick="if (!event.target.closest('form')) window.location='${pageContext.request.contextPath}/tickets/view?id=${t.id}';">
                  <td class="px-4 py-2 text-sm text-gray-700">${t.id}</td>
                  <td class="px-4 py-2 whitespace-nowrap">
                    <div class="flex items-center space-x-2">
                      <img
                        class="w-8 h-8 rounded-full"
                        src="${pageContext.request.contextPath}/avatar?userId=${t.userId}"
                        alt="${t.username}"
                        onerror="this.src='${pageContext.request.contextPath}/static/img/default-avatar.png';"
                      />
                      <span class="text-sm font-medium">${t.username}</span>
                    </div>
                  </td>
                  <td class="px-4 py-2 text-sm text-gray-700">${t.subject}</td>
                  <td class="px-4 py-2 text-sm text-gray-700">${t.status}</td>
                  <td class="px-4 py-2 text-sm text-gray-700">${t.assignedRole}</td>
                  <td class="px-4 py-2 text-sm text-gray-700">
                    <c:if test="${role=='Admin' or role=='Support'}">
                      <form action="${pageContext.request.contextPath}/tickets/assign" method="post"
                            class="flex items-center space-x-2" onclick="event.stopPropagation()">
                        <input type="hidden" name="ticketId" value="${t.id}" />
                        <select name="role"
                                class="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500">
                          <option value="Support" ${t.assignedRole=='Support' ?'selected':''}>Support</option>
                          <option value="Admin" ${t.assignedRole=='Admin' ?'selected':''}>Admin</option>
                        </select>
                        <button type="submit"
                                class="px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm font-medium">
                          Assign
                        </button>
                      </form>
                    </c:if>
                  </td>
                  <td class="px-4 py-2 text-sm text-gray-700 whitespace-nowrap">
                    <fmt:setTimeZone value="Asia/Colombo" />
                    <fmt:formatDate value="${t.createdAt}" pattern="dd MMM yyyy, HH:mm" />
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty ticketsList}">
                <tr>
                  <td colspan="7" class="px-4 py-4 text-center text-sm text-gray-500">No tickets found.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>
  </main>
</body>
</html>
