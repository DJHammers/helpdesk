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

@WebServlet("/users/edit")
@MultipartConfig(
    fileSizeThreshold   = 1024 * 1024,  
    maxFileSize         = 5 * 1024 * 1024,
    maxRequestSize      = 6 * 1024 * 1024
)
public class EditUserServlet extends HttpServlet {
    private static final List<String> ROLES = Arrays.asList("User", "Support", "Admin");
    private final UserDAO dao = new UserDAO();

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

        try {
            User u = dao.findById(userId);
            if (u == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            req.setAttribute("user", u);
        } catch (SQLException e) {
            throw new ServletException("Error loading user", e);
        }

        boolean isAdmin = "Admin".equals(req.getAttribute("role"));
        req.setAttribute("isAdmin", isAdmin);
        req.setAttribute("roles", ROLES);
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

        boolean isAdmin = "Admin".equals(req.getAttribute("role"));
        req.setAttribute("isAdmin", isAdmin);
        req.setAttribute("roles", ROLES);

        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user id");
            return;
        }

        if (username.isBlank() || email.isBlank() ||
            role == null || !ROLES.contains(role)) {
            req.setAttribute("errorMessage", "All fields except profile picture are required and must be valid.");
            User u = new User();
            u.setId(userId);
            u.setUsername(username);
            u.setEmail(email);
            u.setRole(role);
            req.setAttribute("user", u);
            req.getRequestDispatcher("/WEB-INF/jsp/user_form.jsp").forward(req, resp);
            return;
        }

        String hashOrNull = (password != null && !password.isBlank())
                          ? BCrypt.hashpw(password, BCrypt.gensalt())
                          : null;

        try {
            dao.updateUser(userId, username, email, role, hashOrNull);

            Part avatar = req.getPart("avatarFile");
            if (avatar != null && avatar.getSize() > 0) {
                dao.saveAvatar(
                  userId,
                  avatar.getContentType(),
                  avatar.getSubmittedFileName(),
                  avatar.getInputStream()
                );
            }

            resp.sendRedirect(req.getContextPath() + "/users");
        } catch (SQLException e) {
            throw new ServletException("Error updating user", e);
        }
    }
}