package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.Ticket;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/tickets")
public class TicketsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = (Integer) req.getAttribute("userId");
        String  role   = (String)  req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);


        String statusFilter = req.getParameter("status");
        StringBuilder sql = new StringBuilder(
            "SELECT t.id, t.user_id AS userId, u.username, "
          + "t.subject, t.status, t.assigned_role, t.created_at "
          + "FROM tickets t JOIN users u ON t.user_id = u.id"
        );
        List<Object> params = new ArrayList<>();
        boolean whereUsed = false;

        if (!isAdmin) {
            sql.append(" WHERE t.user_id = ?");
            params.add(userId);
            whereUsed = true;
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(whereUsed ? " AND " : " WHERE ")
               .append("t.status = ?");
            params.add(statusFilter);
            whereUsed = true;
        }

        
        if (isAdmin && "ASSIGNED_Admin".equals(statusFilter)) {
            sql.append(whereUsed ? " AND " : " WHERE ")
               .append("t.assigned_role = 'Admin'");
            whereUsed = true;
        }
        if (isAdmin && "ASSIGNED_Support".equals(statusFilter)) {
            sql.append(whereUsed ? " AND " : " WHERE ")
               .append("t.assigned_role = 'Support'");
            whereUsed = true;
        }

        sql.append(" ORDER BY t.created_at DESC");

        
        List<Ticket> tickets = new ArrayList<>();
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ticket t = new Ticket();
                    t.setId(rs.getInt("id"));
                    t.setUserId(rs.getInt("userId"));
                    t.setUsername(rs.getString("username"));
                    t.setSubject(rs.getString("subject"));
                    t.setStatus(rs.getString("status"));
                    t.setAssignedRole(rs.getString("assigned_role"));
                    t.setCreatedAt(rs.getTimestamp("created_at"));
                    tickets.add(t);
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Error loading tickets", e);
        }

        req.setAttribute("ticketsList",  tickets);
        req.setAttribute("statusFilter", statusFilter == null ? "" : statusFilter);
        req.setAttribute("isAdmin",      isAdmin);
        req.getRequestDispatcher("/WEB-INF/jsp/tickets.jsp")
           .forward(req, resp);
    }
}
