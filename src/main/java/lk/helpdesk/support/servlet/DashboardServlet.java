package lk.helpdesk.support.servlet;

import lk.helpdesk.support.dao.DashboardDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dao = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String role = (String) req.getAttribute("role");
        if (!"Admin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/tickets");
            return;
        }
        
        try {
            Map<String, Integer> statusCounts       = dao.fetchStatusCounts();
            Map<String, Integer> topTicketCreators  = dao.fetchTopTicketCreators();
            Map<String, Integer> topMessageSenders  = dao.fetchTopMessageSenders();
            Map<String, Integer> topMessagedTickets = dao.fetchTopMessagedTickets();

            req.setAttribute("statusCounts",       statusCounts);
            req.setAttribute("topTicketCreators",  topTicketCreators);
            req.setAttribute("topMessageSenders",  topMessageSenders);
            req.setAttribute("topMessagedTickets", topMessagedTickets);
            req.setAttribute("isAdmin", true);

            req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp")
               .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Unable to load dashboard data", e);
        }
    }
}
