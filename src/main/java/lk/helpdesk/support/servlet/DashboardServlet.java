package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.User;
import lk.helpdesk.support.model.Ticket;

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
        HttpSession session = req.getSession(false);
        Integer userId = session == null ? null : (Integer) session.getAttribute("userId");
        String  role   = session == null ? null : (String)  session.getAttribute("role");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        boolean showUsers = "ADMIN".equals(role) && "users".equals(req.getParameter("view"));
        if (showUsers) {
            List<User> users = new ArrayList<>();
            String uSql = "SELECT id,username,email,role,created_at FROM users";
            try (Connection conn = DBConfig.getConnection();
                 PreparedStatement ps = conn.prepareStatement(uSql);
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
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT t.id,u.username,t.subject,t.status,t.created_at ")
           .append("FROM tickets t JOIN users u ON t.user_id=u.id");
        List<Object> params = new ArrayList<>();

        boolean whereUsed = false;
        if ("USER".equals(role)) {
            sql.append(" WHERE t.user_id = ?");
            params.add(userId);
            whereUsed = true;
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(whereUsed ? " AND " : " WHERE ");
            sql.append("t.status = ?");
            params.add(statusFilter);
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
                    t.setUsername(rs.getString("username"));
                    t.setSubject(rs.getString("subject"));
                    t.setStatus(rs.getString("status"));
                    t.setCreatedAt(rs.getTimestamp("created_at"));
                    tickets.add(t);
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Error loading tickets", e);
        }

        req.setAttribute("ticketsList", tickets);
        req.setAttribute("statusFilter", statusFilter == null ? "" : statusFilter);
        req.setAttribute("showUsers", showUsers);

        req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp")
           .forward(req, resp);
    }
}
