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
        Integer userId = (Integer)req.getAttribute("userId");
        String  role   = (String) req.getAttribute("role");
        if (userId == null || !"ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<User> users   = new ArrayList<>();
        List<Ticket> tickets = new ArrayList<>();

        try (Connection conn = DBConfig.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                     "SELECT id,username,email,role,created_at FROM users");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getTimestamp("created_at")
                    ));
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                     "SELECT t.id,u.username,t.subject,t.status,t.created_at " +
                     "FROM tickets t JOIN users u ON t.user_id = u.id");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tickets.add(new Ticket(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("subject"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.setAttribute("usersList", users);
        req.setAttribute("ticketsList", tickets);
        req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp").forward(req, resp);
    }
}
