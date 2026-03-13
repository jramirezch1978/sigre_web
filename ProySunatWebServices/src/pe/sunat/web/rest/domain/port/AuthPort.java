package pe.sunat.web.rest.domain.port;

import pe.sunat.web.rest.domain.model.TokenRequest;
import pe.sunat.web.rest.domain.model.TokenResponse;

/**
 * Puerto para autenticacion (arquitectura hexagonal)
 */
public interface AuthPort {
    
    /**
     * Genera un token JWT
     */
    TokenResponse generarToken(TokenRequest request);
    
    /**
     * Valida un token JWT y retorna los claims
     */
    TokenClaims validarToken(String token);
    
    /**
     * Claims del token
     */
    public static class TokenClaims {
        private String usuario;
        private String empresa;
        private String ipLocal;
        private boolean valid;
        private String error;
        
        public static TokenClaims valid(String usuario, String empresa, String ipLocal) {
            TokenClaims claims = new TokenClaims();
            claims.usuario = usuario;
            claims.empresa = empresa;
            claims.ipLocal = ipLocal;
            claims.valid = true;
            return claims;
        }
        
        public static TokenClaims invalid(String error) {
            TokenClaims claims = new TokenClaims();
            claims.valid = false;
            claims.error = error;
            return claims;
        }
        
        public String getUsuario() { return usuario; }
        public String getEmpresa() { return empresa; }
        public String getIpLocal() { return ipLocal; }
        public boolean isValid() { return valid; }
        public String getError() { return error; }
    }
}
