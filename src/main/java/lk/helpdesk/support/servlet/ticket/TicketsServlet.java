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
    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = (Integer) req.getAttribute("userId");
        String  role   = (String)  req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);

        int page = 1;
        String p = req.getParameter("page");
        if (p != null) {
            try { page = Math.max(1, Integer.parseInt(p)); }
            catch (NumberFormatException ignore) {}
        }
        int offset = (page - 1) * PAGE_SIZE;

        String statusFilter = req.getParameter("status");

        StringBuilder countSql = new StringBuilder(
            "SELECT COUNT(*) FROM tickets t");
        List<Object> countParams = new ArrayList<>();
        boolean where = false;

        if (!isAdmin) {
            countSql.append(" WHERE t.user_id = ?");
            countParams.add(userId);
            where = true;
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            if (!where) { countSql.append(" WHERE "); where = true; }
            else      { countSql.append(" AND "); }
            if (statusFilter.startsWith("ASSIGNED_")) {
                String ar = statusFilter.substring("ASSIGNED_".length());
                countSql.append("t.assigned_role = '").append(ar).append("'");
            } else {
                countSql.append("t.status = ?");
                countParams.add(statusFilter);
            }
        }

        int totalCount = 0;
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement psC = conn.prepareStatement(countSql.toString())) {
            for (int i = 0; i < countParams.size(); i++) {
                psC.setObject(i+1, countParams.get(i));
            }
            try (ResultSet rs = psC.executeQuery()) {
                if (rs.next()) totalCount = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new ServletException("Error counting tickets", e);
        }
        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;


        StringBuilder sql = new StringBuilder(
            "SELECT t.id, t.user_id AS userId, u.username, "
          + "t.subject, t.status, t.assigned_role, t.created_at "
          + "FROM tickets t JOIN users u ON t.user_id = u.id");
        List<Object> params = new ArrayList<>();
        where = false;

        if (!isAdmin) {
            sql.append(" WHERE t.user_id = ?");
            params.add(userId);
            where = true;
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            if (!where) { sql.append(" WHERE "); where = true; }
            else        { sql.append(" AND "); }
            if (statusFilter.startsWith("ASSIGNED_")) {
                String ar = statusFilter.substring("ASSIGNED_".length());
                sql.append("t.assigned_role = '").append(ar).append("'");
            } else {
                sql.append("t.status = ?");
                params.add(statusFilter);
            }
        }

        sql.append(" ORDER BY t.created_at DESC LIMIT ? OFFSET ?");
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            for (Object o : params) {
                ps.setObject(idx++, o);
            }
            ps.setInt(idx++, PAGE_SIZE);
            ps.setInt(idx,   offset);

            List<Ticket> tickets = new ArrayList<>();
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

            req.setAttribute("ticketsList",  tickets);

        } catch (SQLException e) {
            throw new ServletException("Error loading tickets", e);
        }

        req.setAttribute("statusFilter", statusFilter == null ? "" : statusFilter);
        req.setAttribute("isAdmin",      isAdmin);
        req.setAttribute("currentPage",  page);
        req.setAttribute("totalPages",   totalPages);
        req.getRequestDispatcher("/WEB-INF/jsp/tickets.jsp")
           .forward(req, resp);
    }
}