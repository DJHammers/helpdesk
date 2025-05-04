<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Dashboard – Help Desk Support System</title>
</head>
<body class="flex h-screen bg-white">
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

  <main class="flex-1 p-6 overflow-auto bg-white">
    <h2 class="text-2xl font-semibold mb-6 text-gray-800">Ticket Status Overview</h2>
    <c:if test="${isAdmin}">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
        <c:forEach var="entry" items="${statusCounts.entrySet()}">
          <c:set var="status" value="${entry.key}" />
          <c:set var="count"  value="${entry.value}" />
          <a href="${pageContext.request.contextPath}/tickets?status=${status}"
             class="block p-6 bg-white rounded-lg shadow-lg shadow-[#1b87e7]/20 ring-1 ring-[#1b87e7] ring-opacity-100 transition
                    hover:bg-[#1b87e7]/10 hover:shadow-xl">
            <div class="text-sm font-medium text-gray-500 uppercase mb-2">
              ${status.replace('_',' ')}
            </div>
            <div class="text-3xl font-bold text-gray-800">${count}</div>
          </a>
        </c:forEach>
      </div>

      <h2 class="text-2xl font-semibold mb-4 text-gray-800">Leaderboards</h2>
      <div class="space-y-8">
        <!-- Top Ticket Creators -->
        <div class="bg-white p-6 rounded-lg shadow-lg shadow-[#1b87e7]/20 ring-1 ring-[#1b87e7] ring-opacity-100">
          <h3 class="text-lg font-medium mb-4 text-gray-800">Top Ticket Creators</h3>
          <div class="overflow-hidden rounded-lg border border-[#1b87e7]">
            <table class="min-w-full divide-y divide-[#1b87e7]">
              <thead class="bg-[#1b87e7]/20">
                <tr>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">#</th>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">User</th>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">Tickets</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-[#1b87e7]">
                <c:forEach var="entry" items="${topTicketCreators.entrySet()}" varStatus="st">
                  <tr>
                    <td class="px-4 py-2 text-sm text-gray-500">${st.index + 1}</td>
                    <td class="px-4 py-2 text-sm font-medium text-gray-800">${entry.key}</td>
                    <td class="px-4 py-2 text-sm text-gray-500">${entry.value}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Top Message Senders -->
        <div class="bg-white p-6 rounded-lg shadow-lg shadow-[#1b87e7]/20 ring-1 ring-[#1b87e7] ring-opacity-100">
          <h3 class="text-lg font-medium mb-4 text-gray-800">Top Message Senders</h3>
          <div class="overflow-hidden rounded-lg border border-[#1b87e7]">
            <table class="min-w-full divide-y divide-[#1b87e7]">
              <thead class="bg-[#1b87e7]/20">
                <tr>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">#</th>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">User</th>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">Messages</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-[#1b87e7]">
                <c:forEach var="entry" items="${topMessageSenders.entrySet()}" varStatus="st">
                  <tr>
                    <td class="px-4 py-2 text-sm text-gray-500">${st.index + 1}</td>
                    <td class="px-4 py-2 text-sm font-medium text-gray-800">${entry.key}</td>
                    <td class="px-4 py-2 text-sm text-gray-500">${entry.value}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Top Messaged Tickets -->
        <div class="bg-white p-6 rounded-lg shadow-lg shadow-[#1b87e7]/20 ring-1 ring-[#1b87e7] ring-opacity-100">
          <h3 class="text-lg font-medium mb-4 text-gray-800">Top Messaged Tickets</h3>
          <div class="overflow-hidden rounded-lg border border-[#1b87e7]">
            <table class="min-w-full divide-y divide-[#1b87e7]">
              <thead class="bg-[#1b87e7]/20">
                <tr>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">#</th>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">Ticket Subject</th>
                  <th class="px-4 py-2 text-left text-xs font-semibold uppercase text-[#1b87e7]">Messages</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-[#1b87e7]">
                <c:forEach var="entry" items="${topMessagedTickets.entrySet()}" varStatus="st">
                  <tr>
                    <td class="px-4 py-2 text-sm text-gray-500">${st.index + 1}</td>
                    <td class="px-4 py-2 text-sm font-medium text-gray-800 break-words">${entry.key}</td>
                    <td class="px-4 py-2 text-sm text-gray-500">${entry.value}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </c:if>
  </main>
</body>
</html>
