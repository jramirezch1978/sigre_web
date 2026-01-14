package pe.sunat.web.rest.domain.model;

/**
 * Modelo para respuesta de token
 */
public class TokenResponse {
    
    private boolean success;
    private String token;
    private String mensaje;
    private long expiresIn;
    
    public TokenResponse() {}
    
    public static TokenResponse ok(String token, long expiresIn) {
        TokenResponse response = new TokenResponse();
        response.setSuccess(true);
        response.setToken(token);
        response.setExpiresIn(expiresIn);
        return response;
    }
    
    public static TokenResponse error(String mensaje) {
        TokenResponse response = new TokenResponse();
        response.setSuccess(false);
        response.setMensaje(mensaje);
        return response;
    }
    
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getMensaje() {
        return mensaje;
    }
    
    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
    
    public long getExpiresIn() {
        return expiresIn;
    }
    
    public void setExpiresIn(long expiresIn) {
        this.expiresIn = expiresIn;
    }
}
