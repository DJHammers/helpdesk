package lk.helpdesk.support.servlet;

import lk.helpdesk.support.dao.DashboardDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dao = new DashboardDAO();

    private boolean isAdmin(HttpServletRequest req) {
        Object role = req.getAttribute("role");
        return role != null && "Admin".equals(role.toString());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        req.setAttribute("isAdmin", true);

        try {
            Map<String,Integer> statusCounts       = dao.fetchStatusCounts();
            Map<String,Integer> topTicketCreators  = dao.fetchTopTicketCreators();
            Map<String,Integer> topMessageSenders  = dao.fetchTopMessageSenders();
            Map<String,Integer> topMessagedTickets = dao.fetchTopMessagedTickets();

            req.setAttribute("statusCounts",       statusCounts);
            req.setAttribute("topTicketCreators",  topTicketCreators);
            req.setAttribute("topMessageSenders",  topMessageSenders);
            req.setAttribute("topMessagedTickets", topMessagedTickets);

        } catch (Exception e) {
            throw new ServletException("Unable to load dashboard data", e);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp")
           .forward(req, resp);
    }
}
