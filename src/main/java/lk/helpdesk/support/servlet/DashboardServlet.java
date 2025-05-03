package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final int LEADER_LIMIT = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);

        if (!isAdmin) {
            resp.sendRedirect(req.getContextPath() + "/tickets");
            return;
        }

        Map<String,Integer> statusCounts = new LinkedHashMap<>();
        statusCounts.put("Open",         0);
        statusCounts.put("In_Progress",  0);
        statusCounts.put("Resolved",     0);
        statusCounts.put("Closed",       0);

        Map<String,Integer> topTicketCreators  = new LinkedHashMap<>();
        Map<String,Integer> topMessageSenders  = new LinkedHashMap<>();
        Map<String,Integer> topMessagedTickets = new LinkedHashMap<>();

        String statusSql =
                "SELECT status, COUNT(*) AS cnt " +
                        "FROM tickets " +
                        "GROUP BY status " +
                        "ORDER BY FIELD(status,'Open','In_Progress','Resolved','Closed')";

        String ticketsSql =
                "SELECT u.username, COUNT(*) AS cnt " +
                        "FROM tickets t JOIN users u ON t.user_id = u.id " +
                        "GROUP BY u.id ORDER BY cnt DESC LIMIT " + LEADER_LIMIT;

        String sendersSql =
                "SELECT u.username, COUNT(*) AS cnt " +
                        "FROM ticket_messages m JOIN users u ON m.sender_id = u.id " +
                        "GROUP BY u.id ORDER BY cnt DESC LIMIT " + LEADER_LIMIT;

        String ticketsByMsgSql =
                "SELECT t.subject, COUNT(*) AS cnt " +
                        "FROM ticket_messages m JOIN tickets t ON m.ticket_id = t.id " +
                        "GROUP BY t.id ORDER BY cnt DESC LIMIT " + LEADER_LIMIT;

        try (Connection conn = DBConfig.getConnection()) {
            // overwrite zeros with real counts
            try (PreparedStatement ps = conn.prepareStatement(statusSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    statusCounts.put(
                            rs.getString("status"),
                            rs.getInt("cnt")
                    );
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(ticketsSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    topTicketCreators.put(rs.getString("username"), rs.getInt("cnt"));
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sendersSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    topMessageSenders.put(rs.getString("username"), rs.getInt("cnt"));
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(ticketsByMsgSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    topMessagedTickets.put(rs.getString("subject"), rs.getInt("cnt"));
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to load dashboard data", e);
        }

        req.setAttribute("statusCounts",       statusCounts);
        req.setAttribute("topTicketCreators",   topTicketCreators);
        req.setAttribute("topMessageSenders",   topMessageSenders);
        req.setAttribute("topMessagedTickets",  topMessagedTickets);
        req.setAttribute("isAdmin", true);
        req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp")
                .forward(req, resp);
    }
}
