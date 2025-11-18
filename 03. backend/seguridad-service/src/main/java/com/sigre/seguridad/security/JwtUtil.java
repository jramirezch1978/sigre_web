package com.sigre.seguridad.security;

import com.sigre.seguridad.model.entity.Permiso;
import com.sigre.seguridad.model.entity.Rol;
import com.sigre.seguridad.model.entity.Usuario;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Utilidad para generar y validar JWT
 */
@Component
public class JwtUtil {

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.expiration:86400000}") // 24 horas por defecto
    private long jwtExpiration;

    @Value("${jwt.refresh-expiration:604800000}") // 7 días por defecto
    private long refreshExpiration;

    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * Genera un token JWT para un usuario
     */
    public String generateToken(Usuario usuario) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);

        Set<String> roles = usuario.getRoles().stream()
            .map(Rol::getCodRol)
            .collect(Collectors.toSet());

        Set<String> permisos = usuario.getRoles().stream()
            .flatMap(rol -> rol.getPermisos().stream())
            .map(Permiso::getCodPermiso)
            .collect(Collectors.toSet());

        return Jwts.builder()
            .subject(usuario.getCodUser())
            .claim("email", usuario.getEmail())
            .claim("nombre", usuario.getNomUser())
            .claim("empresa", usuario.getEmpresa())
            .claim("roles", String.join(",", roles))
            .claim("permisos", String.join(",", permisos))
            .issuedAt(now)
            .expiration(expiryDate)
            .signWith(getSigningKey())
            .compact();
    }

    /**
     * Genera un refresh token
     */
    public String generateRefreshToken(String usuario) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + refreshExpiration);

        return Jwts.builder()
            .subject(usuario)
            .issuedAt(now)
            .expiration(expiryDate)
            .signWith(getSigningKey())
            .compact();
    }

    /**
     * Obtiene el usuario desde el token
     */
    public String getUserFromToken(String token) {
        Claims claims = Jwts.parser()
            .verifyWith(getSigningKey())
            .build()
            .parseSignedClaims(token)
            .getPayload();

        return claims.getSubject();
    }

    /**
     * Valida si el token es válido
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Obtiene el tiempo de expiración en segundos
     */
    public long getExpirationTime() {
        return jwtExpiration / 1000;
    }
}

