<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List,lk.helpdesk.support.model.TicketMessage" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
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
          | Assigned to role: <strong>${assignedRole}</strong>
        </c:if>
      </div>

      <form action="${pageContext.request.contextPath}/tickets/assign" method="post"
            class="mt-4 flex items-center space-x-2">
        <input type="hidden" name="ticketId" value="${ticketId}"/>
        <label>Assign to role:</label>
        <select name="assignedRole" required class="border px-2 py-1 rounded">
          <c:forEach var="r" items="${roles}">
            <option value="${r}" ${r==assignedRole?'selected':''}>${r}</option>
          </c:forEach>
        </select>
        <button type="submit"
                class="px-3 py-1 bg-green-600 text-white rounded hover:bg-green-700">
          Assign
        </button>
      </form>
    </div>

    <div class="space-y-4">
      <c:forEach var="m" items="${messages}">
        <div class="bg-white p-4 rounded shadow">
          <div class="text-sm text-gray-700">
            <strong>${m.senderUsername}</strong>
            <span class="ml-2 text-xs">${m.createdAt}</span>
          </div>
          <p class="mt-2">${m.message}</p>
        </div>
      </c:forEach>
    </div>

    <form action="${pageContext.request.contextPath}/tickets/message" method="post"
          class="mt-6 bg-white p-6 rounded shadow space-y-4">
      <input type="hidden" name="ticketId" value="${ticketId}"/>
      <textarea name="message" required
                class="w-full border px-3 py-2 rounded h-24"
                placeholder="Your message…"></textarea>
      <button type="submit"
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
        Send Message
      </button>
    </form>
  </div>
</body>
</html>
