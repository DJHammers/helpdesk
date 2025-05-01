package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.dao.TicketDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/tickets/assign")
public class TicketAssignServlet extends HttpServlet {
    private final TicketDAO dao = new TicketDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ticketId = Integer.parseInt(req.getParameter("ticketId"));
        String role  = req.getParameter("role");

        try {
            dao.assign(ticketId, role);
        } catch (Exception e) {
            throw new ServletException("Unable to assign ticket", e);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets/view?id=" + ticketId);
    }
}
