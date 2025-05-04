<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, lk.helpdesk.support.model.User" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Manage Users – Help Desk</title>
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

  <!-- Manage Users Content -->
  <main class="flex-1 p-6 overflow-auto bg-white">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-2xl font-semibold text-gray-800">Manage Users</h2>
      <c:if test="${isAdmin}">
        <a href="${pageContext.request.contextPath}/users/add"
           class="px-4 py-2 bg-[#1b87e7] text-white rounded-lg hover:bg-[#1b87e7]/80 text-sm font-medium">
          Add User
        </a>
      </c:if>
    </div>
    <div class="overflow-hidden rounded-lg border border-[#1b87e7] bg-white ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20">
      <table class="min-w-full divide-y divide-[#1b87e7]">
        <thead class="bg-[#1b87e7]/20">
          <tr>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">ID</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Username</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Email</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Role</th>
            <th class="px-4 py-2 text-left text-xs font-medium uppercase text-[#1b87e7]">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-[#1b87e7]">
          <c:forEach var="u" items="${usersList}">
            <tr class="hover:bg-[#1b87e7]/10">
              <td class="px-4 py-2 text-sm text-gray-800">${u.id}</td>
              <td class="px-4 py-2">
                <div class="flex items-center space-x-2">
                  <div class="relative w-8 h-8 flex-shrink-0">
                    <img
                      src="${pageContext.request.contextPath}/avatar?userId=${u.id}"
                      alt="${u.username}"
                      class="w-8 h-8 rounded-full object-cover"
                      onerror="
                        this.style.display='none';
                        this.nextElementSibling.style.display='flex';
                      "/>
                    <span
                      class="absolute inset-0 hidden items-center justify-center rounded-full bg-gray-300 text-white font-bold">
                      ${fn:toUpperCase(fn:substring(u.username,0,1))}
                    </span>
                  </div>
                  <span class="text-sm text-gray-800">${u.username}</span>
                </div>
              </td>
              <td class="px-4 py-2 text-sm text-gray-800">${u.email}</td>
              <td class="px-4 py-2 text-sm text-gray-800">${u.role}</td>
              <td class="px-4 py-2 space-x-2 text-sm">
                <c:if test="${isAdmin}">
                  <a href="${pageContext.request.contextPath}/users/edit?id=${u.id}"
                     class="inline-flex px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-xs font-medium">
                    Edit
                  </a>
                  <form method="post" action="${pageContext.request.contextPath}/users/delete"
                        class="inline" onsubmit="return confirm('Delete this user?');">
                    <input type="hidden" name="id" value="${u.id}"/>
                    <button type="submit"
                            class="inline-flex px-4 py-2 bg-[#1b87e7]/10 text-[#1b87e7] rounded hover:bg-[#1b87e7]/20 text-xs font-medium">
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

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
      <div class="flex justify-center items-center space-x-4 mt-6">
        <c:if test="${currentPage > 1}">
          <a href="${pageContext.request.contextPath}/users?page=${currentPage - 1}"
             class="px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-sm font-medium">
            Previous
          </a>
        </c:if>
        <span class="text-sm text-gray-800">Page ${currentPage} of ${totalPages}</span>
        <c:if test="${currentPage < totalPages}">
          <a href="${pageContext.request.contextPath}/users?page=${currentPage + 1}"
             class="px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-sm font-medium">
            Next
          </a>
        </c:if>
      </div>
    </c:if>
  </main>
</body>
</html>
