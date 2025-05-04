<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, lk.helpdesk.support.model.Contact" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>View Contact Messages – Help Desk Support System</title>
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
    <a href="${pageContext.request.contextPath}/dashboard"
       class="inline-flex items-center text-sm text-[#1b87e7] hover:underline mb-4">
      ← Back to Dashboard
    </a>

    <div class="flex items-center justify-between mb-4">
      <h2 class="text-2xl font-semibold text-gray-800">Contact Messages</h2>
    </div>

    <div class="overflow-hidden rounded-lg border border-[#1b87e7] bg-white ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20">
      <table class="min-w-full divide-y divide-[#1b87e7]">
        <thead class="bg-[#1b87e7]/20">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase text-[#1b87e7]">#</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase text-[#1b87e7]">Name</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase text-[#1b87e7]">Email</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase text-[#1b87e7]">Subject</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase text-[#1b87e7]">Date</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-[#1b87e7]">
          <c:forEach var="c" items="${contactList}" varStatus="st">
            <tr class="hover:bg-[#1b87e7]/10 cursor-pointer"
                onclick="window.location='${pageContext.request.contextPath}/viewContactDetail?id=${c.id}'">
              <td class="px-6 py-3 text-sm text-gray-800">${st.index + 1}</td>
              <td class="px-6 py-3 text-sm text-gray-900 max-w-xs truncate">${c.name}</td>
              <td class="px-6 py-3 text-sm text-gray-900 max-w-xs truncate">${c.email}</td>
              <td class="px-6 py-3 text-sm text-gray-900 max-w-xs truncate">${c.subject}</td>
              <td class="px-6 py-3 text-sm text-gray-800 whitespace-nowrap">
                <fmt:formatDate value="${c.createdAt}" pattern="dd MMM yyyy, HH:mm"/>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty contactList}">
            <tr>
              <td colspan="5" class="px-6 py-4 text-center text-sm text-gray-500">
                No messages found.
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
      <div class="flex justify-center items-center space-x-4 mt-6">
        <c:if test="${currentPage > 1}">
          <a href="?page=${currentPage - 1}"
             class="px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-sm font-medium">
            Previous
          </a>
        </c:if>
        <span class="text-sm text-gray-800">Page ${currentPage} of ${totalPages}</span>
        <c:if test="${currentPage < totalPages}">
          <a href="?page=${currentPage + 1}"
             class="px-4 py-2 bg-[#1b87e7] text-white rounded hover:bg-[#1b87e7]/80 text-sm font-medium">
            Next
          </a>
        </c:if>
      </div>
    </c:if>
  </main>
</body>
</html>
