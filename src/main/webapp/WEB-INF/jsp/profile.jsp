<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>My Profile</title>
</head>

<body class="bg-gray-50 flex items-center justify-center min-h-screen">
  <div class="w-full max-w-xl bg-white rounded-2xl shadow-lg p-8">

    <a href="${pageContext.request.contextPath}/dashboard"
       class="inline-flex items-center text-sm text-blue-600 hover:underline mb-4">
      ← Back to Dashboard
    </a>

    <h2 class="text-2xl font-semibold mb-6 text-center">My Profile</h2>

    <c:if test="${not empty param.success}">
      <div class="mb-4 rounded-lg bg-green-100 text-green-800 px-4 py-2 text-sm">
        Profile updated successfully!
      </div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="mb-4 rounded-lg bg-red-100 text-red-800 px-4 py-2 text-sm">
        ${error}
      </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/profile"
          method="post" enctype="multipart/form-data" class="space-y-5">

      <!-- avatar preview + upload -->
      <div class="flex items-center space-x-4">
        <c:choose>
          <c:when test="${hasAvatar}">
            <img src="${pageContext.request.contextPath}/avatar?id=${userId}"
                 alt="avatar" class="h-16 w-16 rounded-full object-cover"/>
          </c:when>
          <c:otherwise>
            <div class="h-16 w-16 rounded-full bg-gray-200 flex items-center justify-center text-gray-500">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="7" r="4"></circle>
                <path d="M5.5 21h13a1.5 1.5 0 0 0 1.5-1.5v-1A6.5 6.5 0 0 0 13.5 12h-3A6.5 6.5 0 0 0 4 18.5v1A1.5 1.5 0 0 0 5.5 21z"/>
              </svg>
            </div>
          </c:otherwise>
        </c:choose>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Upload avatar&nbsp;(PNG/JPEG&nbsp;≤&nbsp;5&nbsp;MB)
          </label>
          <input type="file" name="avatarFile" accept="image/*"
                 class="block w-full text-sm text-gray-700 file:mr-4 file:rounded-lg
                        file:border-0 file:bg-blue-600 file:px-4 file:py-2
                        file:text-white file:cursor-pointer hover:file:bg-blue-700"/>
        </div>
      </div>

      <!-- username (read-only) -->
      <div>
        <label class="block text-sm font-medium text-gray-700">Username</label>
        <input type="text" value="${username}" disabled
               class="w-full rounded-lg border px-4 py-2 bg-gray-100 text-gray-600"/>
      </div>

      <!-- editable fields -->
      <div>
        <label class="block text-sm font-medium text-gray-700">Full name</label>
        <input name="fullName" type="text" maxlength="100" value="${fullName}"
               class="w-full rounded-lg border px-4 py-2"/>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700">Email</label>
        <input name="email" type="email" maxlength="100" value="${email}" required
               class="w-full rounded-lg border px-4 py-2"/>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700">Phone</label>
        <input name="phone" type="tel" maxlength="20" value="${phone}"
               class="w-full rounded-lg border px-4 py-2"/>
      </div>

      <hr class="my-4"/>

      <p class="text-sm text-gray-600">
        Leave the fields below blank if you don’t want to change your password.
      </p>

      <div>
        <label class="block text-sm font-medium text-gray-700">New password</label>
        <input name="password" type="password" minlength="6"
               class="w-full rounded-lg border px-4 py-2"/>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700">Confirm password</label>
        <input name="confirm" type="password" minlength="6"
               class="w-full rounded-lg border px-4 py-2"/>
      </div>

      <button type="submit"
              class="w-full rounded-lg bg-blue-600 py-2 font-semibold text-white hover:bg-blue-700">
        Save Changes
      </button>
    </form>
  </div>
</body>
</html>
