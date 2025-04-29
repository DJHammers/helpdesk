package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.util.JwtUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        if (username == null || password == null || username.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Missing credentials");
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
            return;
        }

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT id,password_hash,role FROM users WHERE username = ?")) {
            ps.setString(1, username.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || !BCrypt.checkpw(password, rs.getString("password_hash"))) {
                    req.setAttribute("error", "Invalid credentials");
                    req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
                    return;
                }

                int userId = rs.getInt("id");
                String role = rs.getString("role");
                String token = JwtUtil.generateToken(userId, username.trim(), role);

                Cookie cookie = new Cookie("AUTH_TOKEN", token);
                cookie.setHttpOnly(true);
                cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
                cookie.setMaxAge((int)(JwtUtil.EXP_MS / 1000));
                resp.addCookie(cookie);

                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
