package lk.helpdesk.support.servlet.contact;

import lk.helpdesk.support.dao.ContactDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/contact")
public class SubmitContactServlet extends HttpServlet {
    private static final int MAX_NAME_LEN    = 100;
    private static final int MAX_EMAIL_LEN   = 100;
    private static final int MAX_SUBJECT_LEN = 150;
    private static final int MAX_MESSAGE_LEN = 1000;

    private final ContactDAO dao = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String role = (String) req.getAttribute("role");
        req.setAttribute("isAdmin", "Admin".equals(role));

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

        if (name.length()    > MAX_NAME_LEN    ||
            email.length()   > MAX_EMAIL_LEN   ||
            subject.length() > MAX_SUBJECT_LEN ||
            message.length() > MAX_MESSAGE_LEN) {
            req.setAttribute("error",
                "Please respect maximum lengths: " +
                "Name ≤ "    + MAX_NAME_LEN    + ", " +
                "Email ≤ "   + MAX_EMAIL_LEN   + ", " +
                "Subject ≤ " + MAX_SUBJECT_LEN + ", " +
                "Message ≤ " + MAX_MESSAGE_LEN + ".");
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
