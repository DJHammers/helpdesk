package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.*;

@WebServlet("/avatar")
public class AvatarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String param = req.getParameter("userId");
        if (param == null) param = req.getParameter("id");
        if (param == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int userId;
        try { userId = Integer.parseInt(param); }
        catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int size = 100;
        try { size = Integer.parseInt(req.getParameter("size")); } catch (Exception ignored) {}

        try (Connection con = DBConfig.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT mime_type, img_blob FROM user_avatars WHERE user_id=?")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        resp.setContentType(rs.getString("mime_type"));
                        try (InputStream in = rs.getBinaryStream("img_blob");
                             OutputStream out = resp.getOutputStream()) {
                            in.transferTo(out);
                            return;
                        }
                    }
                }
            }

            String initial = "?";
            try (PreparedStatement ps2 = con.prepareStatement(
                    "SELECT username FROM users WHERE id=?")) {
                ps2.setInt(1, userId);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        String uname = rs2.getString("username");
                        if (uname != null && !uname.isBlank())
                            initial = uname.substring(0, 1).toUpperCase();
                    }
                }
            }

            BufferedImage img = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
            Graphics2D g = img.createGraphics();
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            Color bg = new Color(96, 125, 139);
            g.setColor(bg);
            g.fillRect(0, 0, size, size);
            g.setFont(new Font("SansSerif", Font.BOLD, size / 2));
            FontMetrics fm = g.getFontMetrics();
            int x = (size - fm.stringWidth(initial)) / 2;
            int y = (size - fm.getHeight()) / 2 + fm.getAscent();
            g.setColor(Color.WHITE);
            g.drawString(initial, x, y);
            g.dispose();

            resp.setContentType("image/png");
            try (OutputStream out = resp.getOutputStream()) {
                ImageIO.write(img, "PNG", out);
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
