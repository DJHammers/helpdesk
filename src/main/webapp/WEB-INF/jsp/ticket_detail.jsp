<%@ page session="false" contentType="text/html; charset=UTF-8" %>
  <%@ page import="java.util.List,lk.helpdesk.support.model.TicketMessage" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
          <meta charset="UTF-8" />
          <script src="https://cdn.tailwindcss.com"></script>
          <title>Ticket #${ticketId}</title>
        </head>

        <body class="bg-gray-100 min-h-screen">
          <div class="max-w-4xl mx-auto p-6">
            <a href="${pageContext.request.contextPath}/dashboard?view=tickets"
              class="text-blue-600 hover:underline mb-4 inline-block">← Back to Tickets</a>

            <div class="bg-white p-6 rounded shadow mb-6">
              <h1 class="text-2xl font-semibold">Ticket #${ticketId}: ${subject}</h1>
              <div class="mt-2 text-sm text-gray-600">
                Status: <strong>${status}</strong>
                <c:if test="${not empty assignedRole}">
                  | Assigned to: <strong>${assignedRole}</strong>
                </c:if>
              </div>

              <form action="${pageContext.request.contextPath}/tickets/close" method="post" class="mt-4">
                <input type="hidden" name="ticketId" value="${ticketId}" />
                <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700">
                  Close Ticket
                </button>
              </form>

              <c:if test="${status == 'Close'}">
                <form action="${pageContext.request.contextPath}/tickets/reopen" method="post" class="mt-2">
                  <input type="hidden" name="ticketId" value="${ticketId}" />
                  <button type="submit" class="px-4 py-2 bg-yellow-600 text-white rounded hover:bg-yellow-700">
                    Reopen Ticket
                  </button>
                </form>
              </c:if>

              <c:if test="${role=='Admin' or role=='Support'}">
                <form action="${pageContext.request.contextPath}/tickets/assign" method="post"
                  class="mt-4 flex items-center space-x-2">
                  <input type="hidden" name="ticketId" value="${ticketId}" />
                  <label for="role" class="text-sm">Assign to:</label>
                  <select id="role" name="role" class="border px-2 py-1 rounded">
                    <option value="Support" ${assignedRole=='Support' ?'selected':''}>Support</option>
                    <option value="Admin" ${assignedRole=='Admin' ?'selected':''}>Admin</option>
                  </select>
                  <button type="submit" class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
                    Assign
                  </button>
                </form>
              </c:if>
            </div>

            <div class="space-y-4">
              <c:forEach var="m" items="${messages}">
                <fmt:formatDate value="${m.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" var="time" />
                <div class="bg-white p-4 rounded shadow">
                  <div class="text-sm text-gray-700">
                    <c:choose>
                      <c:when test="${m.senderRole=='User'}">
                        <strong>User: ${m.senderUsername}</strong>
                      </c:when>
                      <c:otherwise>
                        <strong>Support Team ${m.senderRole}: ${m.senderUsername}</strong>
                      </c:otherwise>
                    </c:choose>
                    <span class="ml-2 text-xs">${time}</span>
                  </div>
                  <p class="mt-2">${m.message}</p>
                </div>
              </c:forEach>
            </div>

            <c:if test="${status ne 'Close'}">
              <form action="${pageContext.request.contextPath}/tickets/message" method="post"
                class="mt-6 bg-white p-6 rounded shadow space-y-4">
                <input type="hidden" name="ticketId" value="${ticketId}" />
                <textarea name="message" required class="w-full border px-3 py-2 rounded h-24"
                  placeholder="Your message…"></textarea>
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                  Send Message
                </button>
              </form>
            </c:if>
          </div>
        </body>

        </html>