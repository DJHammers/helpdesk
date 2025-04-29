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
        HttpServletRequest  req  = (HttpServletRequest) rq;
        HttpServletResponse resp = (HttpServletResponse) rs;
        String ctx        = req.getContextPath();
        String servlet    = req.getServletPath();
        String token      = null;

        if (req.getCookies() != null) {
            for (Cookie c : req.getCookies()) {
                if ("AUTH_TOKEN".equals(c.getName())) {
                    token = c.getValue();
                    break;
                }
            }
        }

        boolean isPublic = servlet.equals("/login") || servlet.equals("/register") || servlet.equals("/logout");

        if (isPublic) {
            if (token != null) {
                try {
                    JwtUtil.parseToken(token);
                    resp.sendRedirect(ctx + "/dashboard");
                    return;
                } catch (JwtException e) {
                    Cookie expired = new Cookie("AUTH_TOKEN", "");
                    expired.setPath(ctx.isEmpty() ? "/" : ctx);
                    expired.setMaxAge(0);
                    resp.addCookie(expired);
                }
            }
            chain.doFilter(req, resp);
            return;
        }
        if (token == null) {
            resp.sendRedirect(ctx + "/login");
            return;
        }

        try {
            Jws<Claims> claims = JwtUtil.parseToken(token);
            req.setAttribute("userId",   claims.getBody().get("userId", Integer.class));
            req.setAttribute("username", claims.getBody().getSubject());
            req.setAttribute("role",     claims.getBody().get("role", String.class));
            chain.doFilter(req, resp);
        } catch (JwtException e) {
            Cookie expired = new Cookie("AUTH_TOKEN", "");
            expired.setPath(ctx.isEmpty() ? "/" : ctx);
            expired.setMaxAge(0);
            resp.addCookie(expired);
            resp.sendRedirect(ctx + "/login?error=expired");
        }
    }
}
