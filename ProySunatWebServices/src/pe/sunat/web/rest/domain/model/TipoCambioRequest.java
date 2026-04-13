package pe.sunat.web.rest.domain.model;

/**
 * Modelo para solicitud de tipo de cambio
 * Si fecha es null o vacio, se consulta el dia actual ("today")
 */
public class TipoCambioRequest {
    
    private String fecha;
    
    public TipoCambioRequest() {}
    
    public String getFecha() {
        return fecha;
    }
    
    public void setFecha(String fecha) {
        this.fecha = fecha;
    }
}
