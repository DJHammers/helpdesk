package lk.helpdesk.support.servlet.profile;

import lk.helpdesk.support.dao.ProfileDAO;
import lk.helpdesk.support.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/profile")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {

    private final ProfileDAO dao = new ProfileDAO();

    private static String safe(String n) {
        return n == null
            ? "avatar"
            : n.toLowerCase()
               .replaceAll("\\s+", "-")
               .replaceAll("[^a-z0-9._-]", "");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int loggedInUserId = (Integer) req.getAttribute("userId");
        String role        = (String)  req.getAttribute("role");
        boolean isAdmin    = "Admin".equalsIgnoreCase(role);

        req.setAttribute("role",    role);
        req.setAttribute("isAdmin", isAdmin);

        String idParam = req.getParameter("id");
        int profileId = loggedInUserId;
        if (isAdmin && idParam != null) {
            try {
                profileId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user id");
                return;
            }
        }

        User user;
        try {
            user = dao.findById(profileId);
        } catch (Exception e) {
            throw new ServletException("Unable to load profile", e);
        }
        if (user == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        req.setAttribute("user", user);

        try {
            req.setAttribute("hasAvatar", dao.hasAvatar(profileId));
        } catch (SQLException ex) {
            Logger.getLogger(ProfileServlet.class.getName())
                  .log(Level.SEVERE, "avatar check failed", ex);
        }

        if (isAdmin && profileId != loggedInUserId) {
            req.setAttribute("editUserId", profileId);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int loggedInUserId = (Integer) req.getAttribute("userId");
        String role        = (String)  req.getAttribute("role");
        boolean isAdmin    = "Admin".equalsIgnoreCase(role);

        String idParam = req.getParameter("id");
        int profileId = loggedInUserId;
        if (isAdmin && idParam != null) {
            try {
                profileId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user id");
                return;
            }
        }

        // read submitted fields
        String email    = req.getParameter("email");
        String fullName = req.getParameter("fullName");
        String phone    = req.getParameter("phone");
        String pw1      = req.getParameter("password");
        String pw2      = req.getParameter("confirm");

        if (pw1 != null && !pw1.isBlank() && !pw1.equals(pw2)) {
            req.setAttribute("error", "Passwords do not match");
            req.setAttribute("isAdmin", isAdmin);
            if (isAdmin && profileId != loggedInUserId) {
                req.setAttribute("editUserId", profileId);
            }
            doGet(req, resp);
            return;
        }

        Part part = req.getPart("avatarFile");
        if (part != null && part.getSize() > 0) {
            if (!part.getContentType().startsWith("image/")) {
                req.setAttribute("error", "Avatar must be an image");
                req.setAttribute("isAdmin", isAdmin);
                if (isAdmin && profileId != loggedInUserId) {
                    req.setAttribute("editUserId", profileId);
                }
                doGet(req, resp);
                return;
            }
            try (InputStream in = part.getInputStream()) {
                dao.saveAvatar(
                  profileId,
                  part.getContentType(),
                  safe(part.getSubmittedFileName()),
                  in
                );
            } catch (Exception e) {
                throw new ServletException("Unable to save avatar", e);
            }
        }

        String hash = (pw1 != null && !pw1.isBlank())
                    ? BCrypt.hashpw(pw1, BCrypt.gensalt(10))
                    : null;

        try {
            dao.updateProfile(profileId, email, fullName, phone, hash);
        } catch (Exception e) {
            throw new ServletException("Unable to update profile", e);
        }

        String target = req.getContextPath() + "/profile?success=1";
        if (isAdmin && profileId != loggedInUserId) {
            target += "&id=" + profileId;
        }
        resp.sendRedirect(target);
    }
}
