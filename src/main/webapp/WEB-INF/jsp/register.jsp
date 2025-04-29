<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Register</title>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen">
  <div class="w-full max-w-sm bg-white rounded-2xl shadow-lg p-8">
    <h2 class="text-2xl font-bold mb-6 text-center">Create Account</h2>
    <form method="post" action="${pageContext.request.contextPath}/register" class="space-y-5">
      <div class="space-y-1">
        <label for="username" class="text-sm font-medium text-gray-700">Username</label>
        <input id="username" name="username" type="text" required
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>
      <div class="space-y-1">
        <label for="email" class="text-sm font-medium text-gray-700">Email</label>
        <input id="email" name="email" type="email" required
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>
      <div class="space-y-1">
        <label for="password" class="text-sm font-medium text-gray-700">Password</label>
        <input id="password" name="password" type="password" required
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"/>
      </div>
      <button type="submit"
              class="w-full rounded-lg bg-blue-600 py-2 font-semibold text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
        Register
      </button>
    </form>
    <c:if test="${not empty error}">
      <p class="mt-4 text-center text-red-600 text-sm">${error}</p>
    </c:if>
    <p class="mt-6 text-center text-sm text-gray-600">
      Already have an account?
      <a href="${pageContext.request.contextPath}/login" class="font-medium text-blue-600 hover:underline">Sign in</a>
    </p>
  </div>
</body>
</html>
