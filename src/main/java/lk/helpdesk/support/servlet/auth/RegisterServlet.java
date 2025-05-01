package lk.helpdesk.support.servlet.auth;

import lk.helpdesk.support.dao.AuthDAO;
import lk.helpdesk.support.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final AuthDAO authDao = new AuthDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username").trim();
        String email    = req.getParameter("email").trim();
        String pw       = req.getParameter("password");
        String confirm  = req.getParameter("confirm");

        if (pw == null || !pw.equals(confirm)) {
            req.setAttribute("error", "Passwords must match");
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
               .forward(req, resp);
            return;
        }

        User u = new User();
        u.setUsername(username);
        u.setEmail(email);
        u.setRole("User");

        try {
            authDao.register(u, pw);
        } catch (SQLException e) {
            String msg = e.getMessage().toLowerCase();
            if (msg.contains("in use")) {
                req.setAttribute("error", "Username or email already in use");
                req.setAttribute("username", username);
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
                   .forward(req, resp);
                return;
            }
            throw new ServletException("Registration failed", e);
        }

        resp.sendRedirect(req.getContextPath() + "/login?registered=1");
    }
}
