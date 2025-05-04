package lk.helpdesk.support.servlet.contact;

import lk.helpdesk.support.dao.ContactDAO;
import lk.helpdesk.support.model.Contact;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/viewContactDetail")
public class ViewContactDetailServlet extends HttpServlet {
    private final ContactDAO dao = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String role = (String) req.getAttribute("role");
        if (!"Admin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.setAttribute("isAdmin", true);

        String idParam = req.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (Exception e) {
            resp.sendError(400, "Invalid message ID");
            return;
        }

        Contact c;
        try {
            c = dao.findById(id);
        } catch (Exception e) {
            throw new ServletException("Unable to load contact message", e);
        }
        if (c == null) {
            resp.sendError(404, "Message not found");
            return;
        }

        req.setAttribute("contact", c);
        req.getRequestDispatcher("/WEB-INF/jsp/view_contact_detail.jsp")
           .forward(req, resp);
    }
}
