package lk.helpdesk.support.servlet;

import lk.helpdesk.support.config.DBConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = (String) req.getAttribute("role");
        boolean isAdmin = "Admin".equals(role);

        if (!isAdmin) {
            resp.sendRedirect(req.getContextPath() + "/tickets");
            return;
        }

        Map<String,Integer> statusCounts = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM tickets GROUP BY status";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                statusCounts.put(
                    rs.getString("status"),
                    rs.getInt("cnt")
                );
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to load dashboard data", e);
        }


        req.setAttribute("statusCounts", statusCounts);
        req.setAttribute("isAdmin",      true);
        req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp")
           .forward(req, resp);
    }
}
