package lk.helpdesk.support.servlet.feedback;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/feedback")
public class SubmitFeedbackServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String role = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);
        req.setAttribute("isAdmin", isAdmin);

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
        int rating = 5;
        try {
            rating = Integer.parseInt(req.getParameter("rating"));
            if (rating < 1 || rating > 5) rating = 5;
        } catch (NumberFormatException ignored) {}

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

        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}