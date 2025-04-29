package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.Arrays;
import java.util.List;

@WebServlet("/tickets/assign")
public class AssignTicketServlet extends HttpServlet {
    private static final List<String> ALLOWED = Arrays.asList("Support","Admin");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String currentRole = (String) req.getAttribute("role");
        if (currentRole == null || !ALLOWED.contains(currentRole)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int ticketId;
        try {
            ticketId = Integer.parseInt(req.getParameter("ticketId"));
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String assignRole = req.getParameter("role");
        if (!ALLOWED.contains(assignRole)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE tickets SET assigned_role = ? WHERE id = ?")) {
            ps.setString(1, assignRole);
            ps.setInt(2, ticketId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets/view?id=" + ticketId);
    }
}
