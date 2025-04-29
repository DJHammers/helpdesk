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

@WebServlet("/admin/users/add")
public class AddUserServlet extends HttpServlet {
    private static final List<String> ROLES = Arrays.asList(
        "USER",
        "SUPPORT_LEVEL_1",
        "SUPPORT_LEVEL_2",
        "SUPPORT_LEVEL_3",
        "ADMIN"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("roles", ROLES);
        request.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String email    = request.getParameter("email").trim();
        String password = request.getParameter("password");
        String role     = request.getParameter("role");

        String checkSql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(checkSql)) {

            psCheck.setString(1, username);
            psCheck.setString(2, email);
            try (ResultSet rs = psCheck.executeQuery()) {
                rs.next();
                if (rs.getInt(1) > 0) {
                    request.setAttribute("errorMessage", "Username or email already in use");
                    request.setAttribute("roles", ROLES);
                    User pre = new User();
                    pre.setUsername(username);
                    pre.setEmail(email);
                    pre.setRole(role);
                    request.setAttribute("user", pre);
                    request.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp")
                           .forward(request, response);
                    return;
                }
            }

            String insertSql = "INSERT INTO users(username, email, password_hash, role) VALUES (?,?,?,?)";
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());

            try (PreparedStatement psIns = conn.prepareStatement(insertSql)) {
                psIns.setString(1, username);
                psIns.setString(2, email);
                psIns.setString(3, hashed);
                psIns.setString(4, role);
                psIns.executeUpdate();
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        response.sendRedirect(request.getContextPath() + "/dashboard?view=users");
    }
}
