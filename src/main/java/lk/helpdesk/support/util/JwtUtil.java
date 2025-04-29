package lk.helpdesk.support.util;

import io.jsonwebtoken.*;
import java.util.Date;

public class JwtUtil {
    private static final String SECRET = "a-very-strong-secret-key-change-me";
    // 4 hours
    public static final long EXP_MS = 1000 * 60 * 60 * 4;

    public static String generateToken(int userId, String username, String role) {
        long now = System.currentTimeMillis();
        return Jwts.builder()
            .setSubject(username)
            .claim("userId", userId)
            .claim("role", role)
            .setIssuedAt(new Date(now))
            .setExpiration(new Date(now + EXP_MS))
            .signWith(SignatureAlgorithm.HS256, SECRET)
            .compact();
    }

    public static Jws<Claims> parseToken(String jwt) throws JwtException {
        return Jwts.parser()
            .setSigningKey(SECRET)
            .parseClaimsJws(jwt);
    }
}
