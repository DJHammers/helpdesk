package lk.helpdesk.support.servlet.feedback;

import lk.helpdesk.support.dao.FeedbackDAO;
import lk.helpdesk.support.model.Feedback;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewFeedback")
public class ViewFeedbackServlet extends HttpServlet {

    private final FeedbackDAO dao = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String role = (String) req.getAttribute("role");
        req.setAttribute("isAdmin", "Admin".equals(role));

        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}

        int totalCount;
        int totalPages;
        try {
            totalCount = dao.countAll();
            totalPages = (totalCount + FeedbackDAO.PAGE_SIZE - 1) / FeedbackDAO.PAGE_SIZE;
            if (totalPages < 1) totalPages = 1;
        } catch (Exception e) {
            throw new ServletException("Unable to count feedback", e);
        }

        if (page > totalPages) page = totalPages;

        List<Feedback> feedbackList;
        try {
            feedbackList = dao.findPage(page);
        } catch (Exception e) {
            throw new ServletException("Unable to load feedback", e);
        }

        req.setAttribute("feedbackList", feedbackList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("/WEB-INF/jsp/view_feedback.jsp")
           .forward(req, resp);
    }
}
