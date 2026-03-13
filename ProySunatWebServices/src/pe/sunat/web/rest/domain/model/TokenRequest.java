package pe.sunat.web.rest.domain.model;

/**
 * Modelo para solicitud de token
 */
public class TokenRequest {
    
    private String usuario;
    private String clave;
    private String empresa;
    private String ipLocal;
    private String computerName;
    
    public TokenRequest() {}
    
    public TokenRequest(String usuario, String clave, String empresa, String ipLocal, String computerName) {
        this.usuario = usuario;
        this.clave = clave;
        this.empresa = empresa;
        this.ipLocal = ipLocal;
        this.computerName = computerName;
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
    
    public String getIpLocal() {
        return ipLocal;
    }
    
    public void setIpLocal(String ipLocal) {
        this.ipLocal = ipLocal;
    }
    
    public String getComputerName() {
        return computerName;
    }
    
    public void setComputerName(String computerName) {
        this.computerName = computerName;
    }
}
