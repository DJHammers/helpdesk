package lk.helpdesk.support.filter;

import lk.helpdesk.support.util.JwtUtil;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class JwtAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest) rq;
        HttpServletResponse response = (HttpServletResponse) rs;

        String ctx  = request.getContextPath();
        String path = request.getRequestURI().substring(ctx.length());

        String token = null;
        if (request.getCookies() != null) {
            for (Cookie c : request.getCookies()) {
                if ("AUTH_TOKEN".equals(c.getName())) {
                    token = c.getValue();
                    break;
                }
            }
        }
        if (path.equals("/") ||
            path.startsWith("/login") ||
            path.startsWith("/register")) {

            if (token != null) {
                try {
                    JwtUtil.parseToken(token);
                    response.sendRedirect(ctx + "/dashboard");
                    return;
                } catch (JwtException e) {
                    Cookie expired = new Cookie("AUTH_TOKEN", "");
                    expired.setMaxAge(0);
                    expired.setPath(ctx.isEmpty() ? "/" : ctx);
                    response.addCookie(expired);
                }
            }
            chain.doFilter(request, response);
            return;
        }

        if (token == null) {
            response.sendRedirect(ctx + "/login");
            return;
        }

        try {
            Jws<Claims> claims = JwtUtil.parseToken(token);
            request.setAttribute("userId",   claims.getBody().get("userId", Integer.class));
            request.setAttribute("username", claims.getBody().getSubject());
            request.setAttribute("role",     claims.getBody().get("role", String.class));
            chain.doFilter(request, response);
        } catch (JwtException e) {
            Cookie expired = new Cookie("AUTH_TOKEN", "");
            expired.setMaxAge(0);
            expired.setPath(ctx.isEmpty() ? "/" : ctx);
            response.addCookie(expired);
            response.sendRedirect(ctx + "/login?error=expired");
        }
    }
}
