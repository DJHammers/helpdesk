package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/tickets/close")
public class CloseTicketServlet extends HttpServlet {
    private static final String STATUS_CLOSED = "Closed";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        int ticketId;
        try {
            ticketId = Integer.parseInt(req.getParameter("ticketId"));
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Integer userId = (Integer) req.getAttribute("userId");
        String  role   = (String)  req.getAttribute("role");
        if (userId == null || role == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String sql;
        if ("User".equals(role)) {
            sql = "UPDATE tickets SET status = ? WHERE id = ? AND user_id = ?";
        } else {
            sql = "UPDATE tickets SET status = ? WHERE id = ?";
        }

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, STATUS_CLOSED);
            ps.setInt(2, ticketId);
            if ("User".equals(role)) {
                ps.setInt(3, userId);
            }

            int updated = ps.executeUpdate();
            if (updated == 0 && "User".equals(role)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Error closing ticket", e);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets/view?id=" + ticketId);
    }
}
