<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List,lk.helpdesk.support.model.TicketMessage" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Ticket #${ticketId}</title>

  <script>
    // live counter for message box (1000)
    function updMsg() {
      const m = document.getElementById('message');
      document.getElementById('msgCount').textContent = m.value.length + '/1000';
    }
    document.addEventListener('DOMContentLoaded', updMsg);
  </script>
</head>

<body class="bg-gray-50 min-h-screen">
  <div class="max-w-4xl mx-auto p-6">

    <!-- Back link -->
    <a href="${pageContext.request.contextPath}/dashboard?view=tickets"
       class="inline-flex items-center text-sm font-medium text-blue-600 hover:underline mb-6">
      ← Back to Tickets
    </a>

    <!-- Ticket header -->
    <div class="bg-white rounded-2xl shadow p-6 mb-6">
      <h1 class="text-2xl font-semibold mb-2 break-words whitespace-pre-line">
        Ticket #${ticketId}: ${subject}
      </h1>

      <div class="flex flex-wrap items-center text-sm text-gray-600 space-x-4 mb-4">
        <span>Status: <strong>${status}</strong></span>
        <c:if test="${not empty assignedRole}">
          <span>Assigned to: <strong>${assignedRole}</strong></span>
        </c:if>
      </div>

      <!-- Action buttons (close / reopen / assign) -->
      <div class="flex flex-wrap items-center space-x-2">
        <form action="${pageContext.request.contextPath}/tickets/close" method="post" class="inline">
          <input type="hidden" name="ticketId" value="${ticketId}" />
          <button type="submit"
                  class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 text-sm font-medium">
            Close Ticket
          </button>
        </form>

        <c:if test="${status == 'Closed'}">
          <form action="${pageContext.request.contextPath}/tickets/reopen" method="post" class="inline">
            <input type="hidden" name="ticketId" value="${ticketId}" />
            <button type="submit"
                    class="px-4 py-2 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 text-sm font-medium">
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
            <button type="submit"
                    class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm font-medium">
              Assign
            </button>
          </form>
        </c:if>
      </div>
    </div>

    <!-- Message history -->
    <div class="space-y-4">
      <c:forEach var="m" items="${messages}">
        <fmt:formatDate value="${m.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" var="time" />
        <div class="bg-white rounded-2xl shadow p-4">
          <div class="flex justify-between items-center">
            <div class="text-sm text-gray-700 font-medium">
              <c:choose>
                <c:when test="${m.senderRole=='User'}">User</c:when>
                <c:otherwise>${m.senderRole}</c:otherwise>
              </c:choose>
              : ${m.senderUsername}
            </div>
            <div class="text-xs text-gray-500">${time}</div>
          </div>
          <div class="mt-2 text-gray-800 whitespace-pre-line break-words">
            ${fn:length(m.message) > 1000 ? fn:substring(m.message, 0, 1000) : m.message}
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- New message form (hidden when ticket closed) -->
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

        <button type="submit"
                class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm font-medium">
          Send Message
        </button>
      </form>
    </c:if>

  </div>
</body>
</html>
