package pe.restaurant.common.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import pe.restaurant.common.dto.SessionTokenClaimsDto;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

@Slf4j
@Component
public class JwtTokenProvider {

    private final SecretKey key;
    private final long accessTokenExpiration;
    private final long definitiveTokenExpiration;
    private final long refreshTokenExpiration;

    public JwtTokenProvider(
            @Value("${app.jwt.secret}") String jwtSecret,
            @Value("${app.jwt.access-token-expiration:900000}") long accessTokenExpiration,
            @Value("${app.jwt.definitive-token-expiration:900000}") long definitiveTokenExpiration,
            @Value("${app.jwt.refresh-token-expiration:604800000}") long refreshTokenExpiration) {
        this.key = Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtSecret));
        this.accessTokenExpiration = accessTokenExpiration;
        this.definitiveTokenExpiration = definitiveTokenExpiration;
        this.refreshTokenExpiration = refreshTokenExpiration;
    }

    public long getAccessTokenExpirationMs() {
        return accessTokenExpiration;
    }

    public String generateAccessToken(String subject, Map<String, Object> extraClaims) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + accessTokenExpiration);

        JwtBuilder builder = Jwts.builder()
                .subject(subject)
                .issuedAt(now)
                .expiration(expiry);

        extraClaims.forEach(builder::claim);

        return builder.signWith(key).compact();
    }

    public long getDefinitiveTokenExpirationMs() {
        return definitiveTokenExpiration;
    }

    public String generateDefinitiveToken(String subject, Map<String, Object> extraClaims) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + definitiveTokenExpiration);

        JwtBuilder builder = Jwts.builder()
                .subject(subject)
                .issuedAt(now)
                .expiration(expiry);

        extraClaims.forEach(builder::claim);

        return builder.signWith(key).compact();
    }

    public long getRefreshTokenExpirationMs() {
        return refreshTokenExpiration;
    }

    /**
     * Refresh token con claims {@code tokenUse=refresh} (p. ej. {@code userId}, {@code tokensSessionId}).
     */
    public String generateRefreshToken(String subject, Map<String, Object> extraClaims) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + refreshTokenExpiration);

        JwtBuilder builder = Jwts.builder()
                .subject(subject)
                .issuedAt(now)
                .expiration(expiry)
                .claim("tokenUse", "refresh");

        if (extraClaims != null && !extraClaims.isEmpty()) {
            extraClaims.forEach(builder::claim);
        }

        return builder.signWith(key).compact();
    }

    public boolean isRefreshToken(String token) {
        try {
            String use = getClaim(token, "tokenUse", String.class);
            return "refresh".equals(use);
        } catch (JwtException | IllegalArgumentException ex) {
            return false;
        }
    }

    public String getUsername(String token) {
        return getClaims(token).getPayload().getSubject();
    }

    public <T> T getClaim(String token, String claimName, Class<T> type) {
        return getClaims(token).getPayload().get(claimName, type);
    }

    public SessionTokenClaimsDto getSessionClaims(String token) {
        Claims claims = getClaims(token).getPayload();
        Map<String, Object> allClaims = new LinkedHashMap<>(claims);
        allClaims.putIfAbsent("sub", claims.getSubject());
        allClaims.putIfAbsent("iat", claims.getIssuedAt());
        allClaims.putIfAbsent("exp", claims.getExpiration());
        return SessionTokenClaimsDto.builder()
                .subject(claims.getSubject())
                .userId(getNumericClaim(claims, "userId"))
                .empresaId(getNumericClaim(claims, "empresaId"))
                .sucursalId(getNumericClaim(claims, "sucursalId"))
                .tokensSessionId(getNumericClaim(claims, "tokensSessionId"))
                .temporal(claims.get("temporal", Boolean.class))
                .issuedAt(claims.getIssuedAt())
                .expiresAt(claims.getExpiration())
                .claims(allClaims)
                .build();
    }

    public Long getUserId(String token) {
        return getClaim(token, "userId", Long.class);
    }

    public Long getEmpresaId(String token) {
        return getClaim(token, "empresaId", Long.class);
    }

    public Long getSucursalId(String token) {
        return getClaim(token, "sucursalId", Long.class);
    }

    public boolean validateToken(String token) {
        try {
            getClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException ex) {
            log.warn("Token JWT inválido: {}", ex.getMessage());
            return false;
        }
    }

    private Jws<Claims> getClaims(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token);
    }

    private Long getNumericClaim(Claims claims, String key) {
        Object value = claims.get(key);
        if (value instanceof Number number) {
            return number.longValue();
        }
        return null;
    }
}
