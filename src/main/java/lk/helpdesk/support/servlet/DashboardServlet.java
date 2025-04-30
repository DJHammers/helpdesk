package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.Ticket;
import lk.helpdesk.support.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = (Integer) req.getAttribute("userId");
        String  role   = (String)  req.getAttribute("role");
        String  view   = req.getParameter("view") == null ? "tickets" : req.getParameter("view");

        boolean isAdmin   = "Admin".equals(role);
        boolean showUsers = isAdmin && "users".equals(view);

        if (showUsers) {
            List<User> users = new ArrayList<>();
            try (Connection conn = DBConfig.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "SELECT id, username, email, role, created_at FROM users");
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    users.add(u);
                }
            } catch (SQLException e) {
                throw new ServletException("Error loading users", e);
            }
            req.setAttribute("usersList", users);
        }

        String statusFilter = req.getParameter("status");
        List<Ticket> tickets = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT t.id, t.user_id AS userId, u.username, " +
            "       t.subject, t.status, t.assigned_role, t.created_at " +
            "FROM tickets t JOIN users u ON t.user_id = u.id");

        List<Object> params = new ArrayList<>();
        boolean whereUsed = false;

        if ("User".equals(role)) {
            sql.append(" WHERE t.user_id = ?");
            params.add(userId);
            whereUsed = true;
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            switch (statusFilter) {
                case "Open":
                case "In_Progress":
                case "Resolved":
                case "Closed":
                    sql.append(whereUsed ? " AND " : " WHERE ")
                       .append("t.status = ?");
                    params.add(statusFilter);
                    whereUsed = true;
                    break;
                case "ASSIGNED_Admin":
                    sql.append(whereUsed ? " AND " : " WHERE ")
                       .append("t.assigned_role = 'Admin'");
                    whereUsed = true;
                    break;
                case "ASSIGNED_Support":
                    sql.append(whereUsed ? " AND " : " WHERE ")
                       .append("t.assigned_role = 'Support'");
                    whereUsed = true;
                    break;
            }
        }

        sql.append(" ORDER BY t.created_at DESC");

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
        req.setAttribute("view",        view);
        req.setAttribute("isAdmin",     isAdmin);
        req.setAttribute("showUsers",   showUsers);

        req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp")
           .forward(req, resp);
    }
}
