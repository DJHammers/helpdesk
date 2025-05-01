package lk.helpdesk.support.servlet.user;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/users")
public class UsersServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String  role    = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);

        if (!isAdmin) {
            resp.sendRedirect(req.getContextPath() + "/tickets");
            return;
        }

        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, email, role, created_at FROM users ORDER BY username";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
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
        req.setAttribute("isAdmin",   true);
        req.getRequestDispatcher("/WEB-INF/jsp/users.jsp")
           .forward(req, resp);
    }
}
