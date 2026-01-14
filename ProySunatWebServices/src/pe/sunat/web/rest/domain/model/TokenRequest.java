package pe.sunat.web.rest.domain.model;

/**
 * Modelo para solicitud de token
 * Parametros: pUsuario, pClave, pEmpresa
 */
public class TokenRequest {
    
    private String usuario;   // pUsuario
    private String clave;     // pClave
    private String empresa;   // pEmpresa
    
    public TokenRequest() {}
    
    public TokenRequest(String usuario, String clave, String empresa) {
        this.usuario = usuario;
        this.clave = clave;
        this.empresa = empresa;
    }
    
    public String getUsuario() {
        return usuario;
    }
    
    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }
    
    public String getClave() {
        return clave;
    }
    
    public void setClave(String clave) {
        this.clave = clave;
    }
    
    public String getEmpresa() {
        return empresa;
    }
    
    public void setEmpresa(String empresa) {
        this.empresa = empresa;
    }
}
