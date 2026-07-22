package pe.com.sytco.fastsales.beans;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Bean para representar un registro de ping en el historial
 */
public class BeanPingHistory implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private long id;
    private String deviceId;
    private long timestampMs; // Timestamp con milisegundos
    private String endpoint;
    private Long latencyMs; // Tiempo de respuesta total en milisegundos (puede ser null si falló)
    private Long dbConnectionMs; // Tiempo de conexión a BD en milisegundos
    private Long dbQueryMs; // Tiempo de query a BD en milisegundos
    private boolean success;
    private String errorMessage;
    
    public BeanPingHistory() {
    }
    
    public BeanPingHistory(String deviceId, long timestampMs, String endpoint, 
                          Long latencyMs, boolean success, String errorMessage) {
        this.deviceId = deviceId;
        this.timestampMs = timestampMs;
        this.endpoint = endpoint;
        this.latencyMs = latencyMs;
        this.success = success;
        this.errorMessage = errorMessage;
    }
    
    // Getters y Setters
    
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public String getDeviceId() {
        return deviceId;
    }
    
    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }
    
    public long getTimestampMs() {
        return timestampMs;
    }
    
    public void setTimestampMs(long timestampMs) {
        this.timestampMs = timestampMs;
    }
    
    /**
     * Setter alternativo que acepta un String (para compatibilidad con DB queries)
     * Formato esperado: "yyyy-MM-dd HH:mm:ss.SSS"
     */
    public void setTimestamp(String timestamp) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.getDefault());
            Date date = sdf.parse(timestamp);
            this.timestampMs = date.getTime();
        } catch (Exception e) {
            e.printStackTrace();
            this.timestampMs = System.currentTimeMillis();
        }
    }
    
    /**
     * Getter que devuelve el timestamp como String
     */
    public String getTimestamp() {
        return getFormattedTimestamp();
    }
    
    public String getEndpoint() {
        return endpoint;
    }
    
    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }
    
    public Long getLatencyMs() {
        return latencyMs;
    }
    
    public void setLatencyMs(Long latencyMs) {
        this.latencyMs = latencyMs;
    }
    
    public Long getDbConnectionMs() {
        return dbConnectionMs;
    }
    
    public void setDbConnectionMs(Long dbConnectionMs) {
        this.dbConnectionMs = dbConnectionMs;
    }
    
    public Long getDbQueryMs() {
        return dbQueryMs;
    }
    
    public void setDbQueryMs(Long dbQueryMs) {
        this.dbQueryMs = dbQueryMs;
    }
    
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    /**
     * Obtiene la fecha formateada con milisegundos
     */
    public String getFormattedTimestamp() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.getDefault());
        return sdf.format(new Date(timestampMs));
    }
    
    /**
     * Obtiene la latencia formateada para mostrar
     */
    public String getFormattedLatency() {
        if (latencyMs == null) {
            return "N/A";
        }
        return latencyMs + " ms";
    }
    
    @Override
    public String toString() {
        return "BeanPingHistory{" +
                "id=" + id +
                ", deviceId='" + deviceId + '\'' +
                ", timestampMs=" + timestampMs +
                ", endpoint='" + endpoint + '\'' +
                ", latencyMs=" + latencyMs +
                ", success=" + success +
                ", errorMessage='" + errorMessage + '\'' +
                '}';
    }
}

