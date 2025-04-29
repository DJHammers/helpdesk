package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.TicketMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/tickets/view")
public class TicketDetailServlet extends HttpServlet {
    private static final List<String> ROLES = Arrays.asList(
        "USER","SUPPORT","ADMIN"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer userId = (Integer) req.getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int ticketId;
        try {
            ticketId = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String subject, status, assignedRole = null;
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(
               "SELECT subject,status,assigned_role FROM tickets WHERE id = ?")) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                subject      = rs.getString("subject");
                status       = rs.getString("status");
                assignedRole = rs.getString("assigned_role");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.setAttribute("ticketId",     ticketId);
        req.setAttribute("subject",      subject);
        req.setAttribute("status",       status);
        req.setAttribute("assignedRole", assignedRole);
        req.setAttribute("roles",        ROLES);

        List<TicketMessage> msgs = new ArrayList<>();
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(
               "SELECT m.id,m.ticket_id,m.sender_id,u.username,m.message,m.created_at " +
               "FROM ticket_messages m JOIN users u ON m.sender_id=u.id " +
               "WHERE m.ticket_id=? ORDER BY m.created_at ASC")) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketMessage m = new TicketMessage();
                    m.setId(rs.getInt("id"));
                    m.setTicketId(rs.getInt("ticket_id"));
                    m.setSenderId(rs.getInt("sender_id"));
                    m.setSenderUsername(rs.getString("username"));
                    m.setMessage(rs.getString("message"));
                    m.setCreatedAt(rs.getTimestamp("created_at"));
                    msgs.add(m);
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.setAttribute("messages", msgs);
        req.getRequestDispatcher("/WEB-INF/jsp/ticket_detail.jsp")
           .forward(req, resp);
    }
}
