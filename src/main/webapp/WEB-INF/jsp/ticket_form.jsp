<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Create Ticket</title>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
  <div class="bg-white p-8 rounded shadow-md w-full max-w-lg">
    <h2 class="text-2xl font-semibold mb-6">Create Ticket</h2>
    <form action="${pageContext.request.contextPath}/tickets/create" method="post" class="space-y-4">
      <div>
        <label class="block mb-1">Subject</label>
        <input type="text" name="subject" required class="w-full border px-3 py-2 rounded"/>
      </div>
      <div>
        <label class="block mb-1">Description</label>
        <textarea name="description" required class="w-full border px-3 py-2 rounded h-32"></textarea>
      </div>
      <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
        Submit Ticket
      </button>
    </form>
  </div>
</body>
</html>
