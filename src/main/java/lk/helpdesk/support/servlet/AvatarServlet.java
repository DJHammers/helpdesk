package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/avatar")
public class AvatarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null) idParam = req.getParameter("userId");
        if (idParam == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int userId;
        try { userId = Integer.parseInt(idParam); }
        catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean sent = false;

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT mime_type, img_blob FROM user_avatars WHERE user_id=?")) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    resp.setContentType(rs.getString("mime_type"));
                    try (OutputStream out = resp.getOutputStream()) {
                        out.write(rs.getBytes("img_blob"));
                        sent = true;
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        if (!sent) {
            resp.setContentType("image/png");
            try (InputStream in = getServletContext().getResourceAsStream("/static/default-avatar.png");
                 OutputStream out = resp.getOutputStream()) {
                if (in != null) in.transferTo(out); else resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }
}
