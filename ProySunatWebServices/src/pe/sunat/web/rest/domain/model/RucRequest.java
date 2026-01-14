package pe.sunat.web.rest.domain.model;

/**
 * Modelo para solicitud de consulta RUC
 */
public class RucRequest {
    
    private String rucConsulta;
    private String rucOrigen;
    private String computerName;
    
    public RucRequest() {}
    
    public String getRucConsulta() {
        return rucConsulta;
    }
    
    public void setRucConsulta(String rucConsulta) {
        this.rucConsulta = rucConsulta;
    }
    
    public String getRucOrigen() {
        return rucOrigen;
    }
    
    public void setRucOrigen(String rucOrigen) {
        this.rucOrigen = rucOrigen;
    }
    
    public String getComputerName() {
        return computerName;
    }
    
    public void setComputerName(String computerName) {
        this.computerName = computerName;
    }
}
