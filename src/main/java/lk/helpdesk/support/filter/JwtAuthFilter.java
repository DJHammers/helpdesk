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
        HttpServletRequest req = (HttpServletRequest) rq;
        HttpServletResponse resp = (HttpServletResponse) rs;
        String ctx = req.getContextPath();
        String path = req.getRequestURI().substring(ctx.length());

        if ("/logout".equals(path)) {
            chain.doFilter(rq, rs);
            return;
        }

        if ("/login".equals(path) || "/register".equals(path)) {
            Cookie auth = getAuthCookie(req);
            if (auth != null) {
                try {
                    JwtUtil.parseToken(auth.getValue());
                    resp.sendRedirect(ctx + "/dashboard");
                    return;
                } catch (JwtException e) {
                    clearAuthCookie(resp, ctx);
                }
            }
            chain.doFilter(rq, rs);
            return;
        }

        Cookie auth = getAuthCookie(req);
        if (auth == null) {
            resp.sendRedirect(ctx + "/login");
            return;
        }

        try {
            Jws<Claims> claims = JwtUtil.parseToken(auth.getValue());
            req.setAttribute("userId", claims.getBody().get("userId", Integer.class));
            req.setAttribute("username", claims.getBody().getSubject());
            req.setAttribute("role", claims.getBody().get("role", String.class));
            chain.doFilter(rq, rs);
        } catch (JwtException e) {
            clearAuthCookie(resp, ctx);
            resp.sendRedirect(ctx + "/login?error=expired");
        }
    }

    private Cookie getAuthCookie(HttpServletRequest req) {
        if (req.getCookies() == null) return null;
        for (Cookie c : req.getCookies()) {
            if ("AUTH_TOKEN".equals(c.getName())) {
                return c;
            }
        }
        return null;
    }

    private void clearAuthCookie(HttpServletResponse resp, String ctx) {
        Cookie expired = new Cookie("AUTH_TOKEN", "");
        expired.setPath(ctx.isEmpty() ? "/" : ctx);
        expired.setMaxAge(0);
        resp.addCookie(expired);
    }
}
