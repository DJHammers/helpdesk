package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Set;

@WebServlet("/tickets/status")
public class UpdateTicketStatusServlet extends HttpServlet {

    private static final Set<String> ALLOWED =
            Set.of("Open", "In_Progress", "Resolved", "Closed");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int    ticketId   = Integer.parseInt(req.getParameter("ticketId"));
        String nextStatus = req.getParameter("status");

        if (!ALLOWED.contains(nextStatus)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status");
            return;
        }

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps =
                     conn.prepareStatement("UPDATE tickets SET status=? WHERE id=?")) {

            ps.setString(1, nextStatus);
            ps.setInt   (2, ticketId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        String back = req.getHeader("referer");
        if (back == null || back.isBlank()) {
            back = req.getContextPath() + "/tickets/detail?id=" + ticketId;
        }
        resp.sendRedirect(back);
    }
}