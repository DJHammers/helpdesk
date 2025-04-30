package lk.helpdesk.support.servlet;

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
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Feedback> feedbackList = new ArrayList<>();
        try (Connection conn = DBConfig.getConnection()) {
            String sql = "SELECT f.id, f.user_id, u.username, f.message, f.rating, f.created_at " +
                         "FROM feedback f JOIN users u ON f.user_id = u.id " +
                         "ORDER BY f.created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
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
        req.getRequestDispatcher("/WEB-INF/jsp/view_feedback.jsp").forward(req, resp);
    }
}