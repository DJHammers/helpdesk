package lk.helpdesk.support.servlet;

import lk.helpdesk.support.dao.UserDAO;
import lk.helpdesk.support.dao.UserDAO.AvatarData;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/avatar")
public class AvatarServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String param = req.getParameter("userId");
        if (param == null) {
            param = req.getParameter("id");
        }
        if (param == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing userId");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(param);
        } catch (NumberFormatException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid userId");
            return;
        }

        AvatarData av;
        try {
            av = dao.loadAvatar(userId);
        } catch (Exception e) {
            throw new ServletException("Unable to load avatar", e);
        }

        if (av == null) {
            resp.sendRedirect(req.getContextPath() + "/static/no-avatar.png");
            return;
        }

        resp.setHeader("Cache-Control", "max-age=86400");
        resp.setContentType(av.mimeType);
        resp.setContentLength(av.bytes.length);

        try (OutputStream out = resp.getOutputStream()) {
            out.write(av.bytes);
        }
    }
}
