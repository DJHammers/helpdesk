package lk.helpdesk.support.servlet.contact;

import lk.helpdesk.support.dao.ContactDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/contact")
public class SubmitContactServlet extends HttpServlet {
    private final ContactDAO dao = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/contact.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name    = req.getParameter("name");
        String email   = req.getParameter("email");
        String subject = req.getParameter("subject");
        String message = req.getParameter("message");

        if (name == null || email == null || subject == null || message == null ||
            name.isEmpty() || email.isEmpty() || subject.isEmpty() || message.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            doGet(req, resp);
            return;
        }

        try {
            dao.create(name, email, subject, message);
        } catch (Exception e) {
            throw new ServletException("Unable to save contact message", e);
        }

        resp.sendRedirect(req.getContextPath() + "/contact?sent=true");
    }
}
