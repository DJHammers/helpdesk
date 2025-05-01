package lk.helpdesk.support.servlet.feedback;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.Feedback;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/viewFeedback")
public class ViewFeedbackServlet extends HttpServlet {
    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);
        req.setAttribute("isAdmin", isAdmin);

        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try { page = Math.max(1, Integer.parseInt(pageParam)); }
            catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * PAGE_SIZE;

        int totalCount = 0;
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) FROM feedback");
             ResultSet rsCount = psCount.executeQuery()) {
            if (rsCount.next()) {
                totalCount = rsCount.getInt(1);
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to count feedback", e);
        }
        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;

        List<Feedback> feedbackList = new ArrayList<>();
        String sql =
            "SELECT f.id, f.user_id, u.username, f.message, f.rating, f.created_at " +
            "FROM feedback f JOIN users u ON f.user_id = u.id " +
            "ORDER BY f.created_at DESC " +
            "LIMIT ? OFFSET ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, PAGE_SIZE);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setId(rs.getInt("id"));
                    fb.setUserId(rs.getInt("user_id"));
                    fb.setUsername(rs.getString("username"));
                    fb.setMessage(rs.getString("message"));
                    fb.setRating(rs.getInt("rating"));
                    fb.setCreatedAt(rs.getTimestamp("created_at"));
                    feedbackList.add(fb);
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to load feedback", e);
        }

        req.setAttribute("feedbackList", feedbackList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/WEB-INF/jsp/view_feedback.jsp")
           .forward(req, resp);
    }
}