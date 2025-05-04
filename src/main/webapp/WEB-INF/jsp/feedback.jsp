<%@ page session="false" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/helpdesk.png"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Submit Feedback – Help Desk Support System</title>
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

  <!-- Main Content -->
  <main class="flex-1 p-6 overflow-auto bg-white">
    <a href="${pageContext.request.contextPath}/dashboard"
       class="inline-flex items-center text-sm text-[#1b87e7] hover:underline mb-4">
      ← Back to Dashboard
    </a>

    <div class="max-w-xl mx-auto bg-white border border-[#1b87e7] rounded-lg ring-1 ring-[#1b87e7] ring-opacity-100 shadow-sm shadow-[#1b87e7]/20 p-6 space-y-6">
      <h2 class="text-2xl font-semibold text-gray-800 mb-4">Submit Feedback</h2>

      <c:if test="${not empty error}">
        <p class="text-sm text-red-600 mb-4">${error}</p>
      </c:if>

      <form action="${pageContext.request.contextPath}/feedback" method="post" class="space-y-6">
        <!-- Feedback message (500-character limit) -->
        <textarea
          id="message"
          name="message"
          required
          maxlength="500"
          placeholder="Your feedback (max 500 characters)…"
          oninput="updateCounter()"
          class="w-full h-32 border border-gray-200 rounded p-2 focus:outline-none focus:ring-2 focus:ring-[#1b87e7]"
        ></textarea>
        <div class="text-xs text-gray-500">
          <span id="char-count">0</span>/500
        </div>

        <!-- Star Rating -->
        <div id="star-rating" class="flex space-x-1 mb-6">
          <c:forEach var="i" begin="1" end="5">
            <label class="cursor-pointer">
              <input type="radio" name="rating" value="${i}" class="hidden" ${i==5?"checked":""}/>
              <svg data-value="${i}"
                   class="star h-8 w-8 text-gray-300 cursor-pointer"
                   xmlns="http://www.w3.org/2000/svg"
                   fill="currentColor"
                   viewBox="0 0 20 20">
                <path d="M9.049 2.927C9.259 2.194 10.741 2.194 10.951 2.927l1.286 3.97a1 1 0 00.95.69h4.18c.969 0 1.371 1.24.588 1.81l-3.388 2.462a1 1 0 00-.364 1.118l1.287 3.97c.3.921-.755 1.688-1.54 1.118l-3.388-2.462a1 1 0 00-1.175 0l-3.388 2.462c-.784.57-1.838-.197-1.539-1.118l1.286-3.97a1 1 0 00-.364-1.118L2.045 9.397c-.783-.57-.38-1.81.588-1.81h4.18a1 1 0 00.951-.69l1.285-3.97z"/>
              </svg>
            </label>
          </c:forEach>
        </div>

        <button
          type="submit"
          class="w-full px-4 py-2 bg-[#1b87e7] text-white rounded-lg hover:bg-[#1b87e7]/80 transition"
        >
          Submit Feedback
        </button>
      </form>
    </div>
  </main>

  <script>
    document.addEventListener("DOMContentLoaded", () => {
        
      const stars = document.querySelectorAll(".star");
      const inputs = document.querySelectorAll("input[name='rating']");
      function paintStars(r) {
        stars.forEach(s => {
          const v = +s.dataset.value;
          s.classList.toggle("text-yellow-400", v <= r);
          s.classList.toggle("text-gray-300",  v >  r);
        });
      }
      inputs.forEach(i => i.addEventListener("change", e => paintStars(+e.target.value)));
      const sel = document.querySelector("input[name='rating']:checked");
      if (sel) paintStars(+sel.value);

      const msg     = document.getElementById("message");
      const counter = document.getElementById("char-count");
      window.updateCounter = () => counter.textContent = msg.value.length;
      updateCounter();
    });
  </script>
</body>
</html>
