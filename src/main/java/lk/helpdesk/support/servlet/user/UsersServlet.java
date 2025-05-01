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
    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);
        if (!isAdmin) {
            resp.sendRedirect(req.getContextPath() + "/tickets");
            return;
        }

        int page = 1;
        String p = req.getParameter("page");
        if (p != null) {
            try { page = Math.max(1, Integer.parseInt(p)); }
            catch (NumberFormatException ignore) {}
        }
        int offset = (page - 1) * PAGE_SIZE;


        int totalCount = 0;
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) FROM users");
             ResultSet rs = psCount.executeQuery()) {
            if (rs.next()) totalCount = rs.getInt(1);
        } catch (SQLException e) {
            throw new ServletException("Error counting users", e);
        }
        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;


        List<User> users = new ArrayList<>();
        String sql = "SELECT id,username,email,role,created_at "
                   + "FROM users ORDER BY username "
                   + "LIMIT ? OFFSET ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, PAGE_SIZE);
            ps.setInt(2, offset);
            try (ResultSet rs2 = ps.executeQuery()) {
                while (rs2.next()) {
                    User u = new User();
                    u.setId(rs2.getInt("id"));
                    u.setUsername(rs2.getString("username"));
                    u.setEmail(rs2.getString("email"));
                    u.setRole(rs2.getString("role"));
                    u.setCreatedAt(rs2.getTimestamp("created_at"));
                    users.add(u);
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Error loading users", e);
        }

        req.setAttribute("usersList",  users);
        req.setAttribute("isAdmin",    true);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.getRequestDispatcher("/WEB-INF/jsp/users.jsp")
           .forward(req, resp);
    }
}