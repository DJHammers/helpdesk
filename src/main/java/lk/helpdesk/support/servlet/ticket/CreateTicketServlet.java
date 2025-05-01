package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/tickets/create")
public class CreateTicketServlet extends HttpServlet {
    private static final int MAX_SUBJECT_LENGTH     = 100;
    private static final int MAX_DESCRIPTION_LENGTH = 1000;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);
        req.setAttribute("isAdmin", isAdmin);

        req.getRequestDispatcher("/WEB-INF/jsp/ticket_form.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer userId = (Integer) req.getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String subject     = req.getParameter("subject");
        String description = req.getParameter("description");
        if (subject == null)     subject = "";
        if (description == null) description = "";
        subject     = subject.trim();
        description = description.trim();

        if (subject.length() > MAX_SUBJECT_LENGTH) {
            subject = subject.substring(0, MAX_SUBJECT_LENGTH);
        }
        if (description.length() > MAX_DESCRIPTION_LENGTH) {
            description = description.substring(0, MAX_DESCRIPTION_LENGTH);
        }

        String sql = "INSERT INTO tickets(user_id, subject, description) VALUES (?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, subject);
            ps.setString(3, description);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException("Error creating ticket", e);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets");
    }
}