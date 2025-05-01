package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/avatar")
public class AvatarServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String sid = req.getParameter("id");
        if (sid == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        int userId = Integer.parseInt(sid);

        String sql = "SELECT mime_type, img_blob FROM user_avatars WHERE user_id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                resp.setContentType(rs.getString("mime_type"));
                try (var in = rs.getBinaryStream("img_blob");
                     var out = resp.getOutputStream()) {
                    in.transferTo(out);
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
