package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.dao.TicketDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/tickets/status")
public class TicketStatusServlet extends HttpServlet {
    private final TicketDAO dao = new TicketDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ticketId = Integer.parseInt(req.getParameter("ticketId"));
        String status = req.getParameter("status");

        try {
            dao.updateStatus(ticketId, status);
        } catch (Exception e) {
            throw new ServletException("Unable to change status", e);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets/view?id=" + ticketId);
    }
}
