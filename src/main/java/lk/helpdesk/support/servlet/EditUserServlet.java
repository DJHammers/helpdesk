package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.Arrays;
import java.util.List;

@WebServlet("/admin/users/edit")
public class EditUserServlet extends HttpServlet {
    private static final List<String> ROLES = Arrays.asList(
        "User",
        "Support",
        "Admin"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user id");
            return;
        }

        String sql = 
            "SELECT id, username, email, role, created_at " +
            "FROM users WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                    return;
                }
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                request.setAttribute("user", user);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        request.setAttribute("roles", ROLES);
        request.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam   = request.getParameter("id");
        String username  = request.getParameter("username").trim();
        String email     = request.getParameter("email").trim();
        String role      = request.getParameter("role");
        String password  = request.getParameter("password");

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user id");
            return;
        }

        boolean updatePassword = password != null && !password.isBlank();
        StringBuilder sb = new StringBuilder();
        sb.append("UPDATE users SET username = ?, email = ?, role = ?");
        if (updatePassword) {
            sb.append(", password_hash = ?");
        }
        sb.append(" WHERE id = ?");
        String updateSql = sb.toString();

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {

            int idx = 1;
            ps.setString(idx++, username);
            ps.setString(idx++, email);
            ps.setString(idx++, role);
            if (updatePassword) {
                String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
                ps.setString(idx++, hashed);
            }
            ps.setInt(idx, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        response.sendRedirect(request.getContextPath() + "/dashboard?view=users");
    }
}
