<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="<c:url value='/images/helpdesk.png'/>"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Register – Help Desk</title>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen px-4">
  <div class="w-full max-w-md bg-white border border-[#1b87e7] rounded-2xl ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20 p-8">
    
    <!-- Logo + System Name -->
    <div class="flex flex-col items-center mb-6">
      <img src="<c:url value='/images/helpdesk.png'/>"
           alt="Help Desk Logo"
           class="w-24 h-24 mb-4"/>
      <h1 class="text-xl font-bold text-center text-gray-800">
        Help Desk Support<br/>Ticket System
      </h1>
    </div>

    <!-- Create Account Header -->
    <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">Create Account</h2>

    <!-- Registration Form -->
    <form method="post"
          action="${pageContext.request.contextPath}/register"
          class="space-y-5">
      
      <div class="space-y-1">
        <label for="username" class="text-sm font-medium text-gray-700">Username</label>
        <input id="username" name="username" type="text" required
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
      </div>

      <div class="space-y-1">
        <label for="email" class="text-sm font-medium text-gray-700">Email</label>
        <input id="email" name="email" type="email" required
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
      </div>

      <div class="space-y-1">
        <label for="password" class="text-sm font-medium text-gray-700">Password</label>
        <input id="password" name="password" type="password" required
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
      </div>

      <div class="space-y-1">
        <label for="confirm" class="text-sm font-medium text-gray-700">Confirm Password</label>
        <input id="confirm" name="confirm" type="password" required
               class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
      </div>

      <button type="submit"
              class="w-full rounded-lg bg-[#1b87e7] py-2 font-semibold text-white hover:bg-[#1b87e7]/80 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]">
        Register
      </button>
    </form>

    <!-- Error Message -->
    <c:if test="${not empty error}">
      <p class="mt-4 text-center text-red-600 text-sm">${error}</p>
    </c:if>

    <!-- Link to Sign In -->
    <p class="mt-6 text-center text-sm text-gray-600">
      Already have an account?
      <a href="${pageContext.request.contextPath}/login"
         class="font-medium text-[#1b87e7] hover:underline">
        Sign In
      </a>
    </p>
  </div>
</body>
</html>
