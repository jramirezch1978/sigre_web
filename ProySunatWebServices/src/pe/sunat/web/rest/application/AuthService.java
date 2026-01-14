package pe.sunat.web.rest.application;

import java.util.Date;

import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import pe.sunat.web.beans.BeanUsuario;
import pe.sunat.web.controlador.CntrlUsuario;
import pe.sunat.web.rest.domain.model.TokenRequest;
import pe.sunat.web.rest.domain.model.TokenResponse;
import pe.sunat.web.rest.domain.port.AuthPort;

/**
 * Servicio de autenticacion - Capa de aplicacion
 */
public class AuthService implements AuthPort {
    
    // Clave secreta para firmar el JWT (en produccion usar variable de entorno)
    private static final String SECRET_KEY = "SunatWebServices_JWT_Secret_Key_2024_Seguro";
    private static final long EXPIRATION_TIME = 15 * 60 * 1000; // 15 minutos en milisegundos
    
    private CntrlUsuario cntrlUsuario;
    
    public AuthService() {
        this.cntrlUsuario = new CntrlUsuario();
    }
    
    @Override
    public TokenResponse generarToken(TokenRequest request) {
        try {
            // Validar credenciales usando el controlador existente
            BeanUsuario usuario = cntrlUsuario.validarCredenciales(
                request.getUsuario(), 
                request.getClave()
            );
            
            if (usuario == null) {
                return TokenResponse.error("Credenciales invalidas");
            }
            
            // Generar token JWT
            String token = crearJWT(
                request.getUsuario(),
                request.getEmpresa(),
                EXPIRATION_TIME
            );
            
            return TokenResponse.ok(token, EXPIRATION_TIME / 1000); // segundos
            
        } catch (Exception e) {
            return TokenResponse.error(e.getMessage());
        }
    }
    
    @Override
    public TokenClaims validarToken(String token) {
        try {
            Claims claims = Jwts.parser()
                .setSigningKey(DatatypeConverter.parseBase64Binary(SECRET_KEY))
                .parseClaimsJws(token)
                .getBody();
            
            String usuario = claims.getSubject();
            String empresa = claims.get("empresa", String.class);
            
            // Verificar expiracion
            if (claims.getExpiration().before(new Date())) {
                return TokenClaims.invalid("Token expirado");
            }
            
            return TokenClaims.valid(usuario, empresa);
            
        } catch (Exception e) {
            return TokenClaims.invalid("Token invalido: " + e.getMessage());
        }
    }
    
    /**
     * Crea un JWT
     */
    private String crearJWT(String usuario, String empresa, long ttlMillis) {
        SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;
        
        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);
        
        byte[] apiKeySecretBytes = DatatypeConverter.parseBase64Binary(SECRET_KEY);
        SecretKeySpec signingKey = new SecretKeySpec(apiKeySecretBytes, signatureAlgorithm.getJcaName());
        
        JwtBuilder builder = Jwts.builder()
            .setId(String.valueOf(nowMillis))
            .setIssuedAt(now)
            .setSubject(usuario)
            .claim("empresa", empresa)
            .setIssuer("SunatWebServices")
            .signWith(signatureAlgorithm, signingKey);
        
        if (ttlMillis > 0) {
            long expMillis = nowMillis + ttlMillis;
            Date exp = new Date(expMillis);
            builder.setExpiration(exp);
        }
        
        return builder.compact();
    }
}
