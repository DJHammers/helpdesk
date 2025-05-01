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
    fileSizeThreshold   = 1024 * 1024,     // 1 MB
    maxFileSize         = 5 * 1024 * 1024, // 5 MB
    maxRequestSize      = 6 * 1024 * 1024  // 6 MB
)
@WebServlet("/users/add")
public class AddUserServlet extends HttpServlet {
    private static final List<String> ROLES = Arrays.asList("User", "Support", "Admin");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        boolean isAdmin = "Admin".equals(req.getAttribute("role"));
        req.setAttribute("isAdmin", isAdmin);

        req.setAttribute("roles", ROLES);
        req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username").trim();
        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        String checkSql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(checkSql)) {

            psCheck.setString(1, username);
            psCheck.setString(2, email);
            try (ResultSet rs = psCheck.executeQuery()) {
                rs.next();
                if (rs.getInt(1) > 0) {
                    req.setAttribute("errorMessage", "Username or email already in use");
                    req.setAttribute("roles", ROLES);
                    User pre = new User();
                    pre.setUsername(username);
                    pre.setEmail(email);
                    pre.setRole(role);
                    req.setAttribute("user", pre);

                    boolean isAdmin = "Admin".equals(req.getAttribute("role"));
                    req.setAttribute("isAdmin", isAdmin);

                    req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                       .forward(req, resp);
                    return;
                }
            }

            String insertSql = "INSERT INTO users(username, email, password_hash, role) VALUES (?,?,?,?)";
            try (PreparedStatement psIns = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                psIns.setString(1, username);
                psIns.setString(2, email);
                psIns.setString(3, BCrypt.hashpw(password, BCrypt.gensalt()));
                psIns.setString(4, role);
                psIns.executeUpdate();

                int newUserId;
                try (ResultSet gk = psIns.getGeneratedKeys()) {
                    gk.next();
                    newUserId = gk.getInt(1);
                }

                Part avatar = req.getPart("avatarFile");
                if (avatar != null && avatar.getSize() > 0) {
                    String avSql = "INSERT INTO user_avatars(user_id, mime_type, original_name, img_blob) VALUES (?,?,?,?)";
                    try (PreparedStatement psAv = conn.prepareStatement(avSql);
                         InputStream in = avatar.getInputStream()) {
                        psAv.setInt(1, newUserId);
                        psAv.setString(2, avatar.getContentType());
                        psAv.setString(3, avatar.getSubmittedFileName());
                        psAv.setBinaryStream(4, in);
                        psAv.executeUpdate();
                    }
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Error adding user", e);
        }

        resp.sendRedirect(req.getContextPath() + "/users");
    }
}
