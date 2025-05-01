package lk.helpdesk.support.servlet.ticket;

import lk.helpdesk.support.dao.TicketDAO;
import lk.helpdesk.support.model.Ticket;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/tickets")
public class TicketsServlet extends HttpServlet {
    private final TicketDAO dao = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = (Integer) req.getAttribute("userId");
        String  role   = (String)  req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);
        req.setAttribute("isAdmin", isAdmin);

        String statusFilter = req.getParameter("status");
        int page = 1;
        String p = req.getParameter("page");
        if (p != null) {
            try { page = Math.max(1, Integer.parseInt(p)); }
            catch (NumberFormatException ignored) {}
        }

        try {
            int total = dao.countAll(userId, role, statusFilter);
            int totalPages = (total + TicketDAO.PAGE_SIZE - 1) / TicketDAO.PAGE_SIZE;
            List<Ticket> tickets = dao.findPage(userId, role, statusFilter, page);

            req.setAttribute("ticketsList",  tickets);
            req.setAttribute("statusFilter", statusFilter == null ? "" : statusFilter);
            req.setAttribute("isAdmin",      isAdmin);
            req.setAttribute("currentPage",  page);
            req.setAttribute("totalPages",   totalPages);

        } catch (Exception e) {
            throw new ServletException("Error loading tickets", e);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/tickets.jsp")
           .forward(req, resp);
    }
}
