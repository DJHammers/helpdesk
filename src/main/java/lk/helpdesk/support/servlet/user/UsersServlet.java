package lk.helpdesk.support.servlet.user;

import lk.helpdesk.support.dao.UserDAO;
import lk.helpdesk.support.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/users")
public class UsersServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String role = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);
        req.setAttribute("isAdmin", isAdmin);
        if (!isAdmin) {
            resp.sendRedirect(req.getContextPath() + "/tickets");
            return;
        }

        int page = 1;
        String p = req.getParameter("page");
        if (p != null) {
            try { page = Math.max(1, Integer.parseInt(p)); }
            catch (NumberFormatException ignored) {}
        }

        try {
            int totalCount = dao.countAll();
            int totalPages = (totalCount + UserDAO.PAGE_SIZE - 1) / UserDAO.PAGE_SIZE;
            List<User> users = dao.findPage(page);

            req.setAttribute("usersList",  users);
            req.setAttribute("isAdmin",    true);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages",  totalPages);

        } catch (Exception e) {
            throw new ServletException("Error loading users", e);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/users.jsp")
           .forward(req, resp);
    }
}
