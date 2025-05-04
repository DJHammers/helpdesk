<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ page import="lk.helpdesk.support.model.User" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>
    <c:choose>
      <c:when test="${not empty user}">Edit User</c:when>
      <c:otherwise>Add User</c:otherwise>
    </c:choose>
  </title>
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
                    ${pageContext.request.servletPath=='/dashboard' ? 'bg-[#156ab0]' : ''}">
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/users"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/users' ? 'bg-[#156ab0]' : ''}">
            Manage Users
          </a>
          <a href="${pageContext.request.contextPath}/viewContact"
             class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                    hover:bg-[#156ab0] transition
                    ${pageContext.request.servletPath=='/viewContact' ? 'bg-[#156ab0]' : ''}">
            View Contacts
          </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/tickets"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/tickets' ? 'bg-[#156ab0]' : ''}">
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
                  ${pageContext.request.servletPath=='/feedback' ? 'bg-[#156ab0]' : ''}">
          Feedback
        </a>
        <a href="${pageContext.request.contextPath}/viewFeedback"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/viewFeedback' ? 'bg-[#156ab0]' : ''}">
          View Feedback
        </a>
        <a href="${pageContext.request.contextPath}/contact"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/contact' ? 'bg-[#156ab0]' : ''}">
          Contact Us
        </a>
        <a href="${pageContext.request.contextPath}/aboutus"
           class="block w-full px-4 py-2 text-sm font-medium rounded-lg text-white
                  hover:bg-[#156ab0] transition
                  ${pageContext.request.servletPath=='/aboutus' ? 'bg-[#156ab0]' : ''}">
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

  <!-- User Form -->
  <main class="flex-1 p-8 overflow-auto bg-white">
    <div class="w-full max-w-md bg-white border border-[#1b87e7] rounded-2xl ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20 mx-auto p-8">
      <h2 class="text-2xl font-semibold mb-6 text-center text-gray-800">
        <c:choose>
          <c:when test="${not empty user}">Edit User</c:when>
          <c:otherwise>Add User</c:otherwise>
        </c:choose>
      </h2>

      <c:if test="${not empty errorMessage}">
        <div class="mb-4 rounded-lg bg-red-100 px-4 py-3 text-red-700">
          ${errorMessage}
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/users/${empty user ? 'add' : 'edit'}"
            method="post"
            enctype="multipart/form-data"
            class="space-y-6">

        <c:if test="${not empty user}">
          <input type="hidden" name="id" value="${user.id}" />

          <!-- Current avatar preview -->
          <div class="flex justify-center mb-4">
            <div class="relative w-24 h-24">
              <img
                src="${pageContext.request.contextPath}/avatar?userId=${user.id}"
                alt="${user.username}"
                class="w-24 h-24 rounded-full object-cover mx-auto"
                onerror="
                  this.style.display='none';
                  this.nextElementSibling.style.display='flex';
                "/>
              <span
                class="absolute inset-0 hidden items-center justify-center rounded-full bg-gray-300 text-white text-3xl font-bold">
                ${fn:toUpperCase(fn:substring(user.username,0,1))}
              </span>
            </div>
          </div>
        </c:if>

        <!-- Avatar upload -->
        <div class="space-y-1">
          <label for="avatarFile" class="text-sm font-medium text-gray-700">Profile Picture</label>
          <input id="avatarFile"
                 name="avatarFile"
                 type="file"
                 accept="image/*"
                 class="block w-full text-sm text-gray-600
                        file:mr-4 file:py-2 file:px-4
                        file:rounded-lg file:border-0
                        file:text-sm file:font-semibold
                        file:bg-gray-200 file:text-gray-700
                        hover:file:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <!-- Username -->
        <div class="space-y-1">
          <label for="username" class="text-sm font-medium text-gray-700">Username</label>
          <input id="username" name="username" type="text" required
                 value="${user.username}"
                 class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <!-- Email -->
        <div class="space-y-1">
          <label for="email" class="text-sm font-medium text-gray-700">Email</label>
          <input id="email" name="email" type="email" required
                 value="${user.email}"
                 class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <!-- Role -->
        <div class="space-y-1">
          <label for="role" class="text-sm font-medium text-gray-700">Role</label>
          <select id="role" name="role" required
                  class="block w-full rounded-lg border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]">
            <c:forEach var="r" items="${roles}">
              <option value="${r}" ${r == user.role ? 'selected' : ''}>${r}</option>
            </c:forEach>
          </select>
        </div>

        <!-- Password -->
        <div class="space-y-1">
          <label for="password" class="text-sm font-medium text-gray-700">
            <c:choose>
              <c:when test="${empty user}">Password</c:when>
              <c:otherwise>New Password (leave blank to keep current)</c:otherwise>
            </c:choose>
          </label>
          <input id="password" name="password" type="password"
                 <c:if test="${empty user}">required</c:if>
                 class="block w-full rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"/>
        </div>

        <!-- Submit -->
        <button type="submit"
                class="w-full rounded-lg bg-[#1b87e7] py-2 text-white font-semibold hover:bg-[#1b87e7]/80 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]">
          <c:choose>
            <c:when test="${not empty user}">Update User</c:when>
            <c:otherwise>Create User</c:otherwise>
          </c:choose>
        </button>
      </form>
    </div>
  </main>
</body>
</html>