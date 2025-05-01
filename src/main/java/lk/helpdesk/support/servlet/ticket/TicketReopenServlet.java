package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.dao.TicketDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/tickets/reopen")
public class TicketReopenServlet extends HttpServlet {
    private final TicketDAO ticketDao = new TicketDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String tid = req.getParameter("ticketId");
        try {
            int ticketId = Integer.parseInt(tid);
            ticketDao.updateStatus(ticketId, "Open");
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Unable to reopen ticket", e);
        }
        resp.sendRedirect(req.getContextPath() + "/tickets/view?id=" + tid);
    }
}
