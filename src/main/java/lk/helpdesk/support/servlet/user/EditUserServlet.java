package lk.helpdesk.support.servlet.user;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Arrays;
import java.util.List;

@MultipartConfig(
    fileSizeThreshold   = 1024 * 1024,
    maxFileSize         = 5 * 1024 * 1024,
    maxRequestSize      = 6 * 1024 * 1024
)
@WebServlet("/users/edit")
public class EditUserServlet extends HttpServlet {
    private static final List<String> ROLES = Arrays.asList("User", "Support", "Admin");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user id");
            return;
        }

        String sql = "SELECT id, username, email, role, created_at FROM users WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                    return;
                }
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                req.setAttribute("user", u);
            }
        } catch (SQLException e) {
            throw new ServletException("Error loading user", e);
        }

        req.setAttribute("roles", ROLES);
        boolean isAdmin = "Admin".equals(req.getAttribute("role"));
        req.setAttribute("isAdmin", isAdmin);

        req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam  = req.getParameter("id");
        String username = req.getParameter("username").trim();
        String email    = req.getParameter("email").trim();
        String role     = req.getParameter("role");
        String password = req.getParameter("password");

        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user id");
            return;
        }

        boolean updatePwd = password != null && !password.isBlank();
        StringBuilder sb = new StringBuilder(
            "UPDATE users SET username = ?, email = ?, role = ?");
        if (updatePwd) sb.append(", password_hash = ?");
        sb.append(" WHERE id = ?");
        String updateSql = sb.toString();

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {
            int idx = 1;
            ps.setString(idx++, username);
            ps.setString(idx++, email);
            ps.setString(idx++, role);
            if (updatePwd) {
                ps.setString(idx++, BCrypt.hashpw(password, BCrypt.gensalt()));
            }
            ps.setInt(idx, userId);
            ps.executeUpdate();

            // avatar upload
            Part avatar = req.getPart("avatarFile");
            if (avatar != null && avatar.getSize() > 0) {
                String avSql =
                  "INSERT INTO user_avatars(user_id, mime_type, original_name, img_blob) VALUES (?,?,?,?) " +
                  "ON DUPLICATE KEY UPDATE mime_type=VALUES(mime_type), original_name=VALUES(original_name), img_blob=VALUES(img_blob)";
                try (PreparedStatement psAv = conn.prepareStatement(avSql);
                     InputStream in = avatar.getInputStream()) {
                    psAv.setInt(1, userId);
                    psAv.setString(2, avatar.getContentType());
                    psAv.setString(3, avatar.getSubmittedFileName());
                    psAv.setBinaryStream(4, in);
                    psAv.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Error updating user", e);
        }

        resp.sendRedirect(req.getContextPath() + "/users");
    }
}
