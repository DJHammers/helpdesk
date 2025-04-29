<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Register</title>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen">
  <div class="max-w-md w-full bg-white p-8 rounded-2xl shadow-lg">
    <h2 class="text-2xl font-bold mb-6 text-center">Create Account</h2>
    <form method="post" action="${pageContext.request.contextPath}/register" class="space-y-4">
      <div>
        <label class="block text-sm font-medium">Username</label>
        <input name="username" type="text" required class="mt-1 w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>
      <div>
        <label class="block text-sm font-medium">Email</label>
        <input name="email" type="email" required class="mt-1 w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>
      <div>
        <label class="block text-sm font-medium">Password</label>
        <input name="password" type="password" required class="mt-1 w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>
      <button type="submit" class="w-full py-2 mt-4 font-semibold rounded-lg bg-blue-600 text-white hover:bg-blue-700">Register</button>
    </form>
    <c:if test="${not empty error}"><p class="mt-4 text-red-600 text-sm">${error}</p></c:if>
    <p class="mt-6 text-sm text-center">Already have an account? <a href="${pageContext.request.contextPath}/login" class="text-blue-600 hover:underline">Sign in</a></p>
  </div>
</body>
</html>