package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.dao.TicketDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/tickets/create")
public class TicketCreateServlet extends HttpServlet {
    private final TicketDAO dao = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = (String) req.getAttribute("role");
        req.setAttribute("isAdmin", "Admin".equals(role));
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

        try {
            dao.create(userId, subject, description);
        } catch (SQLException ex) {
            Logger.getLogger(TicketCreateServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets");
    }
}
