package lk.helpdesk.support.servlet.contact;

import lk.helpdesk.support.dao.ContactDAO;
import lk.helpdesk.support.model.Contact;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewContact")
public class ViewContactServlet extends HttpServlet {

    private final ContactDAO dao = new ContactDAO();

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

        int page = 1;
        String p = req.getParameter("page");
        if (p != null) {
            try {
                page = Integer.parseInt(p);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) { }
        }

        int totalCount;
        int totalPages;
        try {
            totalCount = dao.countAll();
            totalPages = Math.max(1, (totalCount + ContactDAO.PAGE_SIZE - 1) / ContactDAO.PAGE_SIZE);
            if (page > totalPages) page = totalPages;
        } catch (Exception e) {
            throw new ServletException("Unable to count contact messages", e);
        }

        List<Contact> contactList;
        try {
            contactList = dao.findPage(page);
        } catch (Exception e) {
            throw new ServletException("Unable to load contact messages", e);
        }

        req.setAttribute("contactList", contactList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("/WEB-INF/jsp/view_contact.jsp")
           .forward(req, resp);
    }
}
