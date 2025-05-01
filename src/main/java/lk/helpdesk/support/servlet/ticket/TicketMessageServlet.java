package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.dao.TicketMessageDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/tickets/message")
public class TicketMessageServlet extends HttpServlet {
    private final TicketMessageDAO dao = new TicketMessageDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int ticketId = Integer.parseInt(req.getParameter("ticketId"));
        Integer senderId = (Integer) req.getAttribute("userId");
        String message = req.getParameter("message");

        try {
            dao.create(ticketId, senderId, message);
        } catch (Exception e) {
            throw new ServletException("Unable to post message", e);
        }

        resp.sendRedirect(req.getContextPath() + "/tickets/view?id=" + ticketId);
    }
}
