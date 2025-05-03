package lk.helpdesk.support.servlet.user;

import lk.helpdesk.support.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/users/delete")
public class DeleteUserServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        try {
            dao.delete(id);
        } catch (Exception e) {
            throw new ServletException("Unable to delete user", e);
        }
        resp.sendRedirect(req.getContextPath() + "/users");
    }
}