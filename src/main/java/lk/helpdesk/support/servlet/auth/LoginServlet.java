package lk.helpdesk.support.servlet.auth;

import lk.helpdesk.support.dao.AuthDAO;
import lk.helpdesk.support.model.User;
import lk.helpdesk.support.util.JwtUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final AuthDAO authDao = new AuthDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/login.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || password == null
            || username.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Missing credentials");
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
            return;
        }

        User user;
        try {
            user = authDao.login(username.trim(), password);
        } catch (SQLException e) {
            throw new ServletException("Database error during login", e);
        }

        if (user == null) {
            req.setAttribute("error", "Invalid credentials");
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
            return;
        }

        String token = JwtUtil.generateToken(
            user.getId(),
            user.getUsername(),
            user.getRole()
        );
        Cookie cookie = new Cookie("AUTH_TOKEN", token);
        cookie.setHttpOnly(true);
        cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
        cookie.setMaxAge((int)(JwtUtil.EXP_MS / 1000));
        resp.addCookie(cookie);

        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}
