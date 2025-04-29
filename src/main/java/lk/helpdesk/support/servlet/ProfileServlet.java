package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Locale;

@WebServlet("/profile")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {

    private static String safe(String n) {
        return n == null ? "avatar"
              : n.toLowerCase(Locale.ROOT)
                  .replaceAll("\\s+", "-")
                  .replaceAll("[^a-z0-9._-]", "");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (Integer) req.getAttribute("userId");
        req.setAttribute("userId", userId);

        try (Connection conn = DBConfig.getConnection()) {

            // basic profile data
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT username,email,full_name,phone FROM users WHERE id=?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    req.setAttribute("username", rs.getString("username"));
                    req.setAttribute("email",    rs.getString("email"));
                    req.setAttribute("fullName", rs.getString("full_name"));
                    req.setAttribute("phone",    rs.getString("phone"));
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM user_avatars WHERE user_id=?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                req.setAttribute("hasAvatar", rs.getInt(1) > 0);
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int    userId = (Integer) req.getAttribute("userId");
        String email  = req.getParameter("email");
        String name   = req.getParameter("fullName");
        String phone  = req.getParameter("phone");
        String p1     = req.getParameter("password");
        String p2     = req.getParameter("confirm");

        if (p1 != null && !p1.isBlank() && !p1.equals(p2)) {
            req.setAttribute("error", "Passwords do not match");
            doGet(req, resp);
            return;
        }

        Part part = req.getPart("avatarFile");
        if (part != null && part.getSize() > 0) {

            if (!part.getContentType().startsWith("image/")) {
                req.setAttribute("error", "Avatar must be an image");
                doGet(req, resp);
                return;
            }

            try (Connection conn = DBConfig.getConnection()) {
                conn.setAutoCommit(false);

                try (PreparedStatement del = conn.prepareStatement(
                        "DELETE FROM user_avatars WHERE user_id=?")) {
                    del.setInt(1, userId);
                    del.executeUpdate();
                }

                try (PreparedStatement ins = conn.prepareStatement(
                        "INSERT INTO user_avatars "
                      + "(user_id,mime_type,original_name,img_blob) VALUES (?,?,?,?)")) {
                    ins.setInt(1, userId);
                    ins.setString(2, part.getContentType());
                    ins.setString(3, safe(part.getSubmittedFileName()));
                    try (InputStream in = part.getInputStream()) {
                        ins.setBlob(4, in);
                        ins.executeUpdate();
                    }
                }
                conn.commit();
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        }

        StringBuilder sql = new StringBuilder(
                "UPDATE users SET email=?, full_name=?, phone=?");
        if (p1 != null && !p1.isBlank()) sql.append(", password_hash=?");
        sql.append(" WHERE id=?");

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            ps.setString(i++, email);
            ps.setString(i++, name);
            ps.setString(i++, phone);
            if (p1 != null && !p1.isBlank())
                ps.setString(i++, BCrypt.hashpw(p1, BCrypt.gensalt(10)));
            ps.setInt(i, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        resp.sendRedirect(req.getContextPath() + "/profile?success=1");
    }
}
