package lk.helpdesk.support.servlet.user;

import lk.helpdesk.support.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/users/delete")
public class DeleteUserServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    private boolean isAdmin(HttpServletRequest req) {
        Object role = req.getAttribute("role");
        return role != null && "Admin".equals(role.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String idParam = req.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user id");
            return;
        }

        try {
            dao.delete(id);
        } catch (Exception e) {
            throw new ServletException("Unable to delete user", e);
        }

        resp.sendRedirect(req.getContextPath() + "/users");
    }
}
