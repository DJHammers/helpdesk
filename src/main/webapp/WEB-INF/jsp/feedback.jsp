<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <title>Submit Feedback</title>
</head>
<body class="bg-gray-50 p-6">
  <div class="max-w-xl mx-auto bg-white p-6 rounded-lg shadow">
       <a href="${pageContext.request.contextPath}/dashboard"
       class="inline-flex items-center text-sm text-blue-600 hover:underline mb-4">
      ← Back to Dashboard
    </a>
    <h2 class="text-2xl font-semibold mb-4">Submit Feedback</h2>

    <form action="${pageContext.request.contextPath}/feedback" method="post">
      <textarea name="message" required maxlength="1000"
                class="w-full h-32 border rounded p-2 mb-4"
                placeholder="Your feedback..."></textarea>


      <div id="star-rating" class="flex space-x-1 mb-6">
        <c:forEach var="i" begin="1" end="5">
          <label>
            <input type="radio" name="rating" value="${i}" class="hidden"
                   ${i == 5 ? 'checked' : ''}/>
            <svg data-value="${i}"
                 class="star h-8 w-8 text-gray-300 cursor-pointer"
                 xmlns="http://www.w3.org/2000/svg"
                 fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 
                       3.97a1 1 0 00.95.69h4.18c.969 0 1.371 
                       1.24.588 1.81l-3.388 2.462a1 1 0 
                       00-.364 1.118l1.287 3.97c.3.921-.755 
                       1.688-1.54 1.118l-3.388-2.462a1 1 0 
                       00-1.175 0l-3.388 2.462c-.784.57-1.838
                       -.197-1.539-1.118l1.286-3.97a1 1 0 
                       00-.364-1.118L2.045 9.397c-.783-.57
                       -.38-1.81.588-1.81h4.18a1 1 0 00.951
                       -.69l1.285-3.97z"/>
            </svg>
          </label>
        </c:forEach>
      </div>

      <div class="flex justify-between">
        <button type="submit"
                class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
          Submit Feedback
        </button>
      </div>
    </form>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const stars  = document.querySelectorAll('.star');
      const inputs = document.querySelectorAll('input[name="rating"]');

      function updateStars(rating) {
        stars.forEach(star => {
          const val = parseInt(star.getAttribute('data-value'), 10);
          if (val <= rating) {
            star.classList.add('text-yellow-400');
            star.classList.remove('text-gray-300');
          } else {
            star.classList.add('text-gray-300');
            star.classList.remove('text-yellow-400');
          }
        });
      }

      inputs.forEach(input =>
        input.addEventListener('change', e =>
          updateStars(parseInt(e.target.value, 10))
        )
      );


      const checked = document.querySelector('input[name="rating"]:checked');
      if (checked) {
        updateStars(parseInt(checked.value, 10));
      }
    });
  </script>
</body>
</html>
