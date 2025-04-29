package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/tickets/reopen")
public class ReopenTicketServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ticketId;
        try {
            ticketId = Integer.parseInt(req.getParameter("ticketId"));
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Integer userId = (Integer) req.getAttribute("userId");
        String  role   = (String)  req.getAttribute("role");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String sql;
        if ("USER".equals(role)) {
            sql = "UPDATE tickets SET status = 'OPEN' WHERE id = ? AND user_id = ?";
        } else {
            sql = "UPDATE tickets SET status = 'OPEN' WHERE id = ?";
        }

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            if ("USER".equals(role)) {
                ps.setInt(2, userId);
            }
            int updated = ps.executeUpdate();
            if (updated == 0 && "USER".equals(role)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets/view?id=" + ticketId);
    }
}
