<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Create Ticket</title>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen">
  <div class="w-full max-w-lg bg-white rounded-2xl shadow-lg p-8">
    <h2 class="text-2xl font-semibold mb-6 text-center">Create Ticket</h2>
    <form action="${pageContext.request.contextPath}/tickets/create" method="post" class="space-y-6">
      <div class="space-y-1">
        <label for="subject" class="block text-sm font-medium text-gray-700">Subject</label>
        <input id="subject" name="subject" type="text" required
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>
      <div class="space-y-1">
        <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
        <textarea id="description" name="description" rows="5" required
                  class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Describe your issue…"></textarea>
      </div>
      <button type="submit"
              class="w-full rounded-lg bg-blue-600 py-2 font-semibold text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
        Submit Ticket
      </button>
    </form>
  </div>
</body>
</html>