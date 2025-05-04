<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, lk.helpdesk.support.model.Contact" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>View Contact Messages</title>
</head>
<body class="flex h-screen bg-gray-50">
  <aside class="w-64 bg-white border-r flex flex-col justify-between">
    <!-- your existing sidebar here -->
  </aside>

  <main class="flex-1 p-6 overflow-auto">
    <h2 class="text-2xl font-semibold mb-6">All Contact Messages</h2>
    <table class="min-w-full bg-white rounded-lg overflow-hidden shadow">
      <thead class="bg-gray-50">
        <tr>
          <th class="px-4 py-2 text-left text-xs font-semibold uppercase">#</th>
          <th class="px-4 py-2 text-left text-xs font-semibold uppercase">Name</th>
          <th class="px-4 py-2 text-left text-xs font-semibold uppercase">Email</th>
          <th class="px-4 py-2 text-left text-xs font-semibold uppercase">Subject</th>
          <th class="px-4 py-2 text-left text-xs font-semibold uppercase">Message</th>
          <th class="px-4 py-2 text-left text-xs font-semibold uppercase">Date</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200">
        <c:forEach var="c" items="${contactList}" varStatus="st">
          <tr>
            <td class="px-4 py-2 text-sm text-gray-500">${st.index + 1}</td>
            <td class="px-4 py-2 text-sm text-gray-900">${c.name}</td>
            <td class="px-4 py-2 text-sm text-gray-900">${c.email}</td>
            <td class="px-4 py-2 text-sm text-gray-900">${c.subject}</td>
            <td class="px-4 py-2 text-sm text-gray-800 break-words">${c.message}</td>
            <td class="px-4 py-2 text-sm text-gray-500">
              <fmt:formatDate value="${c.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </main>
</body>
</html>
