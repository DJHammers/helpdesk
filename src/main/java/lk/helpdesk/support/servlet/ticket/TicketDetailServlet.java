package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.dao.TicketDAO;
import lk.helpdesk.support.dao.TicketMessageDAO;
import lk.helpdesk.support.model.Ticket;
import lk.helpdesk.support.model.TicketMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/tickets/view")
public class TicketDetailServlet extends HttpServlet {
    private final TicketDAO ticketDao = new TicketDAO();
    private final TicketMessageDAO msgDao = new TicketMessageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int ticketId;
        try {
            ticketId = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        String role = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);
        req.setAttribute("isAdmin", isAdmin);  

        try {
            Ticket t = ticketDao.findById(ticketId);
            if (t == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            List<TicketMessage> msgs = msgDao.findByTicket(ticketId);

            req.setAttribute("ticketId",     ticketId);
            req.setAttribute("subject",      t.getSubject());
            req.setAttribute("status",       t.getStatus());
            req.setAttribute("assignedRole", t.getAssignedRole());
            req.setAttribute("messages",     msgs);

        } catch (Exception e) {
            throw new ServletException(e);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/ticket_detail.jsp")
           .forward(req, resp);
    }
}
