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
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) { }
        }

        try {
            int totalCount = dao.countAll();
            int totalPages = (totalCount + UserDAO.PAGE_SIZE - 1) / UserDAO.PAGE_SIZE;
            List<User> users = dao.findPage(page);

            req.setAttribute("usersList",   users);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages",  totalPages);

            req.getRequestDispatcher("/WEB-INF/jsp/users.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading users", e);
        }
    }
}
