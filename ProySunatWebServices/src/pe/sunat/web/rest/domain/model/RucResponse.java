package pe.sunat.web.rest.domain.model;

/**
 * Modelo para respuesta de consulta RUC
 */
public class RucResponse {
    
    private boolean success;
    private String mensaje;
    private RucData data;
    
    public RucResponse() {}
    
    public static RucResponse ok(RucData data) {
        RucResponse response = new RucResponse();
        response.setSuccess(true);
        response.setData(data);
        return response;
    }
    
    public static RucResponse error(String mensaje) {
        RucResponse response = new RucResponse();
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
    
    public String getMensaje() {
        return mensaje;
    }
    
    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
    
    public RucData getData() {
        return data;
    }
    
    public void setData(RucData data) {
        this.data = data;
    }
}
