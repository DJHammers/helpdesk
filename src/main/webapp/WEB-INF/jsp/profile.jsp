<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>My Profile – Help Desk</title>
</head>

<body class="flex h-screen bg-white">
  <!-- Sidebar -->
  <aside class="w-64 bg-[#1b87e7] flex flex-col justify-between">
    <div>
      <div class="p-6 flex items-center">
        <img
          src="${pageContext.request.contextPath}/images/helpdesk.png"
          alt="Help Desk Logo"
          class="h-10 w-10 mr-3"
        />
        <h2 class="text-2xl font-bold text-white">Help Desk</h2>
      </div>
      <nav class="mt-6 space-y-2 px-2">
        <c:if test="${isAdmin}">
          <a href="${pageContext.request.contextPath}/dashboard"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/dashboard'?'bg-[#156ab0]':''}">
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/users"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/users'?'bg-[#156ab0]':''}">
            Manage Users
          </a>
          <a href="${pageContext.request.contextPath}/viewContact"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/viewContact'?'bg-[#156ab0]':''}">
            View Contacts
          </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/tickets"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/tickets'?'bg-[#156ab0]':''}">
          View Tickets
        </a>
        <a href="${pageContext.request.contextPath}/profile"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition">
          My Profile
        </a>
        <a href="${pageContext.request.contextPath}/feedback"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/feedback'?'bg-[#156ab0]':''}">
          Feedback
        </a>
        <a href="${pageContext.request.contextPath}/viewFeedback"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/viewFeedback'?'bg-[#156ab0]':''}">
          View Feedback
        </a>
        <a href="${pageContext.request.contextPath}/contact"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/contact'?'bg-[#156ab0]':''}">
          Contact Us
        </a>
        <a href="${pageContext.request.contextPath}/aboutus"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/aboutus'?'bg-[#156ab0]':''}">
          About Us
        </a>
      </nav>
    </div>
    <div class="p-6">
      <a href="${pageContext.request.contextPath}/logout"
         class="block w-full text-center py-3 rounded-lg bg-white text-[#1b87e7] font-medium
                hover:bg-gray-100 transition">
        Sign Out
      </a>
    </div>
  </aside>

  <!-- Main Content -->
  <main class="flex-1 flex items-center justify-center p-8 overflow-auto">
    <div class="w-full max-w-xl bg-white border border-[#1b87e7] rounded-2xl ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20 p-8">

      <a href="${pageContext.request.contextPath}/dashboard"
         class="inline-flex items-center text-sm text-[#1b87e7] hover:underline mb-4">
        ← Back to Dashboard
      </a>

      <h2 class="text-2xl font-semibold mb-6 text-center text-gray-800">My Profile</h2>

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
                   class="block w-full text-sm text-gray-700
                          file:mr-4 file:py-2 file:px-4
                          file:rounded-lg file:border-0
                          file:text-sm file:font-semibold
                          file:bg-[#1b87e7] file:text-white
                          hover:file:bg-[#1b87e7]/80 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
          </div>
        </div>

        <!-- username (read-only) -->
        <div>
          <label class="block text-sm font-medium text-gray-700">Username</label>
          <input type="text" value="${username}" disabled
                 class="w-full rounded-lg border border-gray-300 px-4 py-2 bg-gray-100 text-gray-600 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <!-- editable fields -->
        <div>
          <label class="block text-sm font-medium text-gray-700">Full name</label>
          <input name="fullName" type="text" maxlength="100" value="${fullName}"
                 class="w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Email</label>
          <input name="email" type="email" maxlength="100" value="${email}" required
                 class="w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Phone</label>
          <input name="phone" type="tel" maxlength="20" value="${phone}"
                 class="w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <hr class="my-4 border-gray-200"/>

        <p class="text-sm text-gray-600">
          Leave the fields below blank if you don’t want to change your password.
        </p>

        <div>
          <label class="block text-sm font-medium text-gray-700">New password</label>
          <input name="password" type="password" minlength="6"
                 class="w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Confirm password</label>
          <input name="confirm" type="password" minlength="6"
                 class="w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <button type="submit"
                class="w-full rounded-lg bg-[#1b87e7] py-2 font-semibold text-white hover:bg-[#1b87e7]/80 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]">
          Save Changes
        </button>
      </form>
    </div>
  </main>
</body>
</html>
