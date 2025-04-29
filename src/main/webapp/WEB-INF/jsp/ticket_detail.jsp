<%@ page session="false" contentType="text/html; charset=UTF-8" %>
  <%@ page import="java.util.List,lk.helpdesk.support.model.TicketMessage" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <script src="https://cdn.tailwindcss.com"></script>
          <title>Ticket #${ticketId}</title>
        </head>

        <body class="bg-gray-50 min-h-screen">
          <div class="max-w-4xl mx-auto p-6">
            <a href="${pageContext.request.contextPath}/dashboard?view=tickets"
              class="inline-flex items-center text-sm font-medium text-blue-600 hover:underline mb-6">
              ← Back to Tickets
            </a>

            <div class="bg-white rounded-2xl shadow p-6 mb-6">
              <h1 class="text-2xl font-semibold mb-2">Ticket #${ticketId}: ${subject}</h1>
              <div class="flex flex-wrap items-center text-sm text-gray-600 space-x-4 mb-4">
                <span>Status: <strong>${status}</strong></span>
                <c:if test="${not empty assignedRole}">
                  <span>Assigned to: <strong>${assignedRole}</strong></span>
                </c:if>
              </div>

              <!-- Combined actions and assign into one row -->
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

                <!-- Assign form moved into same flex container -->
                <c:if test="${role=='Admin' or role=='Support'}">
                  <form action="${pageContext.request.contextPath}/tickets/assign" method="post"
                    class="ml-4 flex items-center space-x-2" onclick="event.stopPropagation()">
                    <input type="hidden" name="ticketId" value="${ticketId}" />
                    <label for="role" class="text-sm font-medium text-gray-700">Assign to:</label>
                    <select id="role" name="role"
                      class="block rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500">
                      <option value="Support" ${assignedRole=='Support' ?'selected':''}>Support</option>
                      <option value="Admin" ${assignedRole=='Admin' ?'selected':''}>Admin</option>
                    </select>
                    <button type="submit"
                      class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm font-medium">
                      Assign
                    </button>
                  </form>
                </c:if>
              </div>
            </div>

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
                  <p class="mt-2 text-gray-800">${m.message}</p>
                </div>
              </c:forEach>
            </div>

            <c:if test="${status ne 'Closed'}">
              <form action="${pageContext.request.contextPath}/tickets/message" method="post"
                class="mt-6 bg-white rounded-2xl shadow p-6 space-y-4">
                <input type="hidden" name="ticketId" value="${ticketId}" />
                <textarea name="message" required rows="4"
                  class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
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