package lk.helpdesk.support.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/aboutus")
public class AboutUsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = (String) req.getAttribute("role");
        req.setAttribute("isAdmin", "Admin".equals(role));

        req.getRequestDispatcher("/WEB-INF/jsp/about_us.jsp")
           .forward(req, resp);
    }
}
