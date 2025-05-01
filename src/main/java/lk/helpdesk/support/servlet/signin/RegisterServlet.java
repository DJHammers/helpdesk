package lk.helpdesk.support.servlet.signin;

import lk.helpdesk.support.config.DBConfig;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String hash = BCrypt.hashpw(password, BCrypt.gensalt());

        String sql = "INSERT INTO users(username,email,password_hash) VALUES (?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, hash);
            ps.executeUpdate();
            resp.sendRedirect(req.getContextPath() + "/login?registered=true");
        } catch (Exception e) {
            req.setAttribute("error", "Registration failed: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
        }
    }
}