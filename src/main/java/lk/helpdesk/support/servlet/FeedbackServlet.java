package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // (optional) you could load and show past feedback here,
        // or have a separate ViewFeedbackServlet+JSP for that.
        req.getRequestDispatcher("/WEB-INF/jsp/feedback.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) pull the logged-in userId from the request (set by your JwtAuthFilter)
        Integer userId = (Integer) req.getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2) read form inputs
        String message = req.getParameter("message");
        int rating = 5;
        try {
            rating = Integer.parseInt(req.getParameter("rating"));
            if (rating < 1 || rating > 5) rating = 5;
        } catch (NumberFormatException ignore) {}

        // 3) insert into MySQL
        String sql = "INSERT INTO feedback (user_id, message, rating) VALUES (?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.setInt(3, rating);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException("Unable to save feedback", e);
        }

        // 4) send back to dashboard
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}