<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List,lk.helpdesk.support.model.TicketMessage" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Ticket #${ticketId}</title>
  <script>
    function updMsg() {
      const m = document.getElementById('message');
      document.getElementById('msgCount').textContent = m.value.length + '/1000';
    }
    document.addEventListener('DOMContentLoaded', updMsg);
  </script>
</head>

<body class="flex h-screen bg-gray-50">
  <!-- Sidebar -->
  <aside class="w-64 bg-white border-r flex flex-col justify-between">
    <div>
      <div class="p-6"><h2 class="text-2xl font-bold">Help Desk</h2></div>
      <nav class="mt-6 space-y-2">
        <c:if test="${isAdmin}">
          <a href="${pageContext.request.contextPath}/dashboard"
             class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                    ${pageContext.request.servletPath=='/dashboard'?'bg-gray-100':''}">
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/users"
             class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                    ${pageContext.request.servletPath=='/users'?'bg-gray-100':''}">
            Manage Users
          </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/tickets"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                  ${pageContext.request.servletPath=='/tickets'?'bg-gray-100':''}">
          View Tickets
        </a>
        <a href="${pageContext.request.contextPath}/profile"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100">
          My Profile
        </a>
        <a href="${pageContext.request.contextPath}/feedback"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                  ${pageContext.request.servletPath=='/feedback'?'bg-gray-100':''}">
          Feedback
        </a>
        <a href="${pageContext.request.contextPath}/viewFeedback"
           class="block w-full px-6 py-3 text-sm font-medium rounded-lg hover:bg-gray-100
                  ${pageContext.request.servletPath=='/viewFeedback'?'bg-gray-100':''}">
          View Feedback
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
    <a href="${pageContext.request.contextPath}/dashboard?view=tickets"
       class="inline-flex items-center text-sm font-medium text-blue-600 hover:underline mb-6">
      ← Back to Tickets
    </a>

    <!-- Ticket header -->
    <div class="bg-white rounded-2xl shadow p-6 mb-6">
      <h1 class="text-2xl font-semibold mb-2 whitespace-pre-line">
        Ticket #${ticketId}: ${subject}
      </h1>
      <div class="flex flex-wrap items-center text-sm text-gray-600 space-x-4 mb-4">
        <span>Status: <strong>${status}</strong></span>
        <c:if test="${not empty assignedRole}">
          <span>Assigned to: <strong>${assignedRole}</strong></span>
        </c:if>
      </div>

      <!-- Action buttons -->
      <div class="flex flex-wrap items-center space-x-2">
        <c:if test="${status ne 'Closed'}">
          <form action="${pageContext.request.contextPath}/tickets/status" method="post" class="inline">
            <input type="hidden" name="ticketId" value="${ticketId}" />
            <input type="hidden" name="status"   value="Closed" />
            <button class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 text-sm font-medium">
              Close Ticket
            </button>
          </form>
        </c:if>
        <c:if test="${status == 'Open' and (role=='Admin' or role=='Support')}">
          <form action="${pageContext.request.contextPath}/tickets/status" method="post" class="inline">
            <input type="hidden" name="ticketId" value="${ticketId}" />
            <input type="hidden" name="status"   value="In_Progress" />
            <button class="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 text-sm font-medium">
              Mark In&nbsp;Progress
            </button>
          </form>
        </c:if>
        <c:if test="${status == 'In_Progress' and (role=='Admin' or role=='Support')}">
          <form action="${pageContext.request.contextPath}/tickets/status" method="post" class="inline">
            <input type="hidden" name="ticketId" value="${ticketId}" />
            <input type="hidden" name="status"   value="Resolved" />
            <button class="px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 text-sm font-medium">
              Mark Resolved
            </button>
          </form>
        </c:if>
        <c:if test="${status == 'Closed'}">
          <form action="${pageContext.request.contextPath}/tickets/status" method="post" class="inline">
            <input type="hidden" name="ticketId" value="${ticketId}" />
            <input type="hidden" name="status"   value="Open" />
            <button class="px-4 py-2 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 text-sm font-medium">
              Reopen Ticket
            </button>
          </form>
        </c:if>
        <c:if test="${role=='Admin' or role=='Support'}">
          <form action="${pageContext.request.contextPath}/tickets/assign" method="post"
                class="ml-4 flex items-center space-x-2">
            <input type="hidden" name="ticketId" value="${ticketId}" />
            <label for="role" class="text-sm font-medium text-gray-700">Assign to:</label>
            <select id="role" name="role"
                    class="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm shadow-sm focus:ring-2 focus:ring-green-500">
              <option value="Support" ${assignedRole=='Support' ? 'selected' : ''}>Support</option>
              <option value="Admin"   ${assignedRole=='Admin'   ? 'selected' : ''}>Admin</option>
            </select>
            <button class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm font-medium">
              Assign
            </button>
          </form>
        </c:if>
      </div>
    </div>

    <!-- Message history -->
    <div class="space-y-4">
      <c:forEach var="m" items="${messages}">
        <div class="bg-white rounded-2xl shadow p-4">
          <div class="flex justify-between items-start">
            <div class="flex items-center gap-2 text-sm text-gray-700 font-medium">
              <div class="relative w-10 h-10 flex-shrink-0">
                <img src="${pageContext.request.contextPath}/avatar?id=${m.senderId}"
                     class="w-10 h-10 rounded-full object-cover"
                     alt="${m.senderUsername}"
                     onerror="
                       this.style.display='none';
                       this.nextElementSibling.style.display='flex';
                     "/>
                <span class="absolute inset-0 hidden items-center justify-center rounded-full bg-gray-300 text-white font-bold">
                  ${fn:toUpperCase(fn:substring(m.senderUsername,0,1))}
                </span>
              </div>
              <span>
                <c:choose>
                  <c:when test="${m.senderRole=='User'}">User</c:when>
                  <c:otherwise>${m.senderRole}</c:otherwise>
                </c:choose>
                : ${m.senderUsername}
              </span>
            </div>
            <div class="text-xs text-gray-500">
              <fmt:formatDate value="${m.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
            </div>
          </div>
          <div class="mt-2 text-gray-800 whitespace-pre-line break-words">
            ${fn:length(m.message) > 1000
              ? fn:substring(m.message, 0, 1000)
              : m.message}
          </div>
        </div>
      </c:forEach>
      <c:if test="${empty messages}">
        <p class="text-gray-500">No messages yet.</p>
      </c:if>
    </div>

    <!-- New message form -->
    <c:if test="${status ne 'Closed'}">
      <form action="${pageContext.request.contextPath}/tickets/message"
            method="post"
            class="mt-6 bg-white rounded-2xl shadow p-6 space-y-4"
            oninput="updMsg()">
        <input type="hidden" name="ticketId" value="${ticketId}" />
        <label class="block text-sm font-medium text-gray-700">
          Your message (<span id="msgCount">0/1000</span>)
        </label>
        <textarea name="message"
                  id="message"
                  rows="4"
                  required
                  maxlength="1000"
                  class="w-full rounded-lg border px-3 py-2 shadow-sm focus:ring-2 focus:ring-blue-500 whitespace-pre-line break-words"
                  placeholder="Your message…"></textarea>
        <button class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm font-medium">
          Send Message
        </button>
      </form>
    </c:if>
  </main>
</body>
</html>
