package lk.helpdesk.support.servlet.user;

import lk.helpdesk.support.dao.UserDAO;
import lk.helpdesk.support.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/users/add")
@MultipartConfig(
    fileSizeThreshold   = 1024 * 1024,
    maxFileSize         = 5 * 1024 * 1024,
    maxRequestSize      = 6 * 1024 * 1024
)
public class AddUserServlet extends HttpServlet {
    private static final List<String> ROLES = Arrays.asList("User", "Support", "Admin");
    private final UserDAO dao = new UserDAO();

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

        boolean isAdmin = "Admin".equals(req.getAttribute("role"));
        req.setAttribute("isAdmin", isAdmin);
        req.setAttribute("roles", ROLES);

        if (username.isBlank() || email.isBlank() || password == null || password.isBlank() ||
            role == null || !ROLES.contains(role)) {
            req.setAttribute("errorMessage", "All fields except profile picture are required and must be valid.");
            User pre = new User();
            pre.setUsername(username);
            pre.setEmail(email);
            pre.setRole(role);
            req.setAttribute("user", pre);
            req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp").forward(req, resp);
            return;
        }

        try {
            if (dao.existsByUsernameOrEmail(username, email)) {
                req.setAttribute("errorMessage", "Username or email already in use");
                User pre = new User();
                pre.setUsername(username);
                pre.setEmail(email);
                pre.setRole(role);
                req.setAttribute("user", pre);
                req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp").forward(req, resp);
                return;
            }

            String hash = BCrypt.hashpw(password, BCrypt.gensalt());
            int newUserId = dao.createUser(username, email, hash, role);

            Part avatar = req.getPart("avatarFile");
            if (avatar != null && avatar.getSize() > 0) {
                dao.saveAvatar(
                  newUserId,
                  avatar.getContentType(),
                  avatar.getSubmittedFileName(),
                  avatar.getInputStream()
                );
            }

            resp.sendRedirect(req.getContextPath() + "/users");
        } catch (SQLException e) {
            throw new ServletException("Error adding user", e);
        }
    }
}