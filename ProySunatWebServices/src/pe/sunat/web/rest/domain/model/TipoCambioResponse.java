package pe.sunat.web.rest.domain.model;

/**
 * Modelo para respuesta de consulta de tipo de cambio
 */
public class TipoCambioResponse {
    
    private boolean success;
    private String mensaje;
    private TipoCambioData data;
    
    public TipoCambioResponse() {}
    
    public static TipoCambioResponse ok(TipoCambioData data) {
        TipoCambioResponse response = new TipoCambioResponse();
        response.setSuccess(true);
        response.setData(data);
        return response;
    }
    
    public static TipoCambioResponse error(String mensaje) {
        TipoCambioResponse response = new TipoCambioResponse();
        response.setSuccess(false);
        response.setMensaje(mensaje);
        return response;
    }
    
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    
    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }
    
    public TipoCambioData getData() { return data; }
    public void setData(TipoCambioData data) { this.data = data; }
}
