package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/tickets/message")
public class PostMessageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ticketId = Integer.parseInt(req.getParameter("ticketId"));
        int senderId = (Integer) req.getAttribute("userId");
        String msg   = req.getParameter("message");
        String sql   = "INSERT INTO ticket_messages(ticket_id,sender_id,message) VALUES(?,?,?)";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            ps.setInt(2, senderId);
            ps.setString(3, msg);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets/view?id=" + ticketId);
    }
}
