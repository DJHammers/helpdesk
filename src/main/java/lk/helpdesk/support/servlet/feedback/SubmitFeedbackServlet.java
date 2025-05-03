package lk.helpdesk.support.servlet.feedback;

import lk.helpdesk.support.dao.FeedbackDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/feedback")
public class SubmitFeedbackServlet extends HttpServlet {

    private final FeedbackDAO dao = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String role = (String) req.getAttribute("role");
        req.setAttribute("isAdmin", "Admin".equals(role));

        req.getRequestDispatcher("/WEB-INF/jsp/feedback.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = (Integer) req.getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String message = req.getParameter("message");
        if (message == null) message = "";
        if (message.length() > 500) {
            req.setAttribute("error", "Feedback must be 500 characters or less.");
            doGet(req, resp);
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(req.getParameter("rating"));
            if (rating < 1 || rating > 5) rating = 5;
        } catch (NumberFormatException e) {
            rating = 5;
        }

        try {
            dao.create(userId, message, rating);
        } catch (Exception e) {
            throw new ServletException("Unable to save feedback", e);
        }

        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}
