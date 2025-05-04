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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = (String) req.getAttribute("role");
        if (!"Admin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        List<Contact> list;
        try {
            list = dao.findAll();
        } catch (Exception e) {
            throw new ServletException("Unable to load contact messages", e);
        }

        req.setAttribute("contactList", list);
        req.getRequestDispatcher("/WEB-INF/jsp/view_contact.jsp")
           .forward(req, resp);
    }
}
