<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, lk.helpdesk.support.model.Ticket" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>View Tickets – Help Desk Support System</title>
</head>
<body class="flex h-screen bg-white">
  <!-- Sidebar -->
  <aside class="w-64 bg-[#1b87e7] flex flex-col justify-between">
    <div>
      <div class="p-6 flex items-center">
        <img
          src="${pageContext.request.contextPath}/images/helpdesk.png"
          alt="Help Desk Logo"
          class="h-10 w-10 mr-3"
        />
        <h2 class="text-2xl font-bold text-white">Help Desk</h2>
      </div>
      <nav class="mt-6 space-y-2 px-2">
        <c:if test="${isAdmin}">
          <a href="${pageContext.request.contextPath}/dashboard"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/dashboard' ? 'bg-[#156ab0]' : ''}">
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/users"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/users' ? 'bg-[#156ab0]' : ''}">
            Manage Users
          </a>
          <a href="${pageContext.request.contextPath}/viewContact"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/viewContact' ? 'bg-[#156ab0]' : ''}">
            View Contacts
          </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/tickets"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/tickets' ? 'bg-[#156ab0]' : ''}">
          View Tickets
        </a>
        <a href="${pageContext.request.contextPath}/profile"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition">
          My Profile
        </a>
        <a href="${pageContext.request.contextPath}/feedback"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/feedback' ? 'bg-[#156ab0]' : ''}">
          Feedback
        </a>
        <a href="${pageContext.request.contextPath}/viewFeedback"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/viewFeedback' ? 'bg-[#156ab0]' : ''}">
          View Feedback
        </a>
        <a href="${pageContext.request.contextPath}/contact"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/contact' ? 'bg-[#156ab0]' : ''}">
          Contact Us
        </a>
        <a href="${pageContext.request.contextPath}/aboutus"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/aboutus' ? 'bg-[#156ab0]' : ''}">
          About Us
        </a>
      </nav>
    </div>
    <div class="p-6">
      <a href="${pageContext.request.contextPath}/logout"
         class="block w-full text-center py-3 rounded-lg bg-white text-[#1b87e7] font-medium
                hover:bg-gray-100 transition">
        Sign Out
      </a>
    </div>
  </aside>

  <!-- Main Content -->
  <main class="flex-1 p-6 overflow-auto bg-white">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-2xl font-semibold text-gray-800">Tickets</h2>
      <a href="${pageContext.request.contextPath}/tickets/create"
         class="px-4 py-2 bg-[#1b87e7] text-white rounded-lg hover:bg-[#1b87e7]/80 text-sm font-medium transition">
        New Ticket
      </a>
    </div>

    <form method="get" action="${pageContext.request.contextPath}/tickets"
          class="mb-4 flex flex-wrap gap-4 items-center">
      <label for="status" class="text-sm font-medium text-gray-700">Filter by:</label>
      <select id="status" name="status" onchange="this.form.submit()"
              class="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-[#1b87e7]">
        <option value="" ${empty statusFilter ? 'selected' : ''}>All</option>
        <option value="Open"         ${statusFilter=='Open'        ? 'selected' : ''}>Open</option>
        <option value="In_Progress"  ${statusFilter=='In_Progress' ? 'selected' : ''}>In Progress</option>
        <option value="Resolved"     ${statusFilter=='Resolved'    ? 'selected' : ''}>Resolved</option>
        <option value="Closed"       ${statusFilter=='Closed'      ? 'selected' : ''}>Closed</option>

        <c:if test="${isAdmin}">
          <option value="ASSIGNED_Admin"
                  ${statusFilter=='ASSIGNED_Admin'   ? 'selected' : ''}>
            Assigned to Admin
          </option>
        </c:if>

        <c:if test="${isAdmin || isSupport}">
          <option value="ASSIGNED_Support"
                  ${statusFilter=='ASSIGNED_Support' ? 'selected' : ''}>
            Assigned to Support
          </option>
        </c:if>
      </select>
    </form>

    <div class="overflow-hidden rounded-lg border border-[#1b87e7] bg-white ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20">
      <table class="min-w-full divide-y divide-[#1b87e7]">
        <thead class="bg-[#1b87e7]/20">
          <tr>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">ID</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Requester</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Subject</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Status</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Assigned</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Assign To</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Created At</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-[#1b87e7]">
          <c:forEach var="t" items="${ticketsList}">
            <tr class="hover:bg-[#1b87e7]/10 cursor-pointer"
                onclick="if (!event.target.closest('form')) 
                         window.location='${pageContext.request.contextPath}/tickets/view?id=${t.id}';">
              <td class="px-4 py-2 text-sm text-gray-800">${t.id}</td>
              <td class="px-4 py-2 whitespace-nowrap">
                <div class="flex items-center space-x-2">
                  <div class="relative w-8 h-8">
                    <img
                      class="w-8 h-8 rounded-full object-cover"
                      src="${pageContext.request.contextPath}/avatar?userId=${t.userId}"
                      alt="${t.username}"
                      onerror="
                        this.style.display='none';
                        this.nextElementSibling.style.display='flex';
                      "/>
                    <span
                      class="absolute inset-0 hidden items-center justify-center rounded-full bg-gray-300 text-white font-bold">
                      ${fn:toUpperCase(fn:substring(t.username,0,1))}  
                    </span>
                  </div>
                  <span class="text-sm font-medium text-gray-800">${t.username}</span>
                </div>
              </td>
              <td class="px-4 py-2 text-sm text-gray-800">${t.subject}</td>
              <td class="px-4 py-2 text-sm text-gray-800">${t.status}</td>
              <td class="px-4 py-2 text-sm text-gray-800">${t.assignedRole}</td>
              <td class="px-4 py-2 text-sm text-gray-800">
                <!-- show assign form to Admin OR Support -->
                <c:if test="${isAdmin || isSupport}">
                  <form action="${pageContext.request.contextPath}/tickets/assign" method="post"
                        class="flex items-center space-x-2" onclick="event.stopPropagation()">
                    <input type="hidden" name="ticketId" value="${t.id}"/>

                    <select name="role"
                            class="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#1b87e7]">
                      <option value="Support" ${t.assignedRole=='Support'?'selected':''}>Support</option>
                      <option value="Admin"   ${t.assignedRole=='Admin'  ?'selected':''}>Admin</option>
                    </select>

                    <button type="submit"
                            class="px-3 py-2 bg-[#1b87e7] text-white rounded-lg hover:bg-[#1b87e7]/80 focus:outline-none focus:ring-2 focus:ring-[#1b87e7] text-sm font-medium transition">
                      Assign
                    </button>
                  </form>
                </c:if>
              </td>
              <td class="px-4 py-2 text-sm text-gray-800 whitespace-nowrap">
                <fmt:setTimeZone value="Asia/Colombo"/>
                <fmt:formatDate value="${t.createdAt}" pattern="dd MMM yyyy, HH:mm"/>
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

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
      <div class="flex justify-center items-center space-x-4 mt-6">
        <c:if test="${currentPage > 1}">
          <a href="${pageContext.request.contextPath}/tickets?page=${currentPage - 1}"
             class="px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-sm font-medium transition">
            Previous
          </a>
        </c:if>
        <span class="text-sm text-gray-800">Page ${currentPage} of ${totalPages}</span>
        <c:if test="${currentPage < totalPages}">
          <a href="${pageContext.request.contextPath}/tickets?page=${currentPage + 1}"
             class="px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-sm font-medium transition">
            Next
          </a>
        </c:if>
      </div>
    </c:if>
  </main>
</body>
</html>
