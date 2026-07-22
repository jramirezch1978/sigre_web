package pe.com.hermes.appmobile.data.remote.dto;

/** Espejo de com.sigre.common.dto.ApiResponse&lt;T&gt; (todos los microservicios). */
public class ApiResponse<T> {
    public boolean success;
    public String message;
    public String errorCode;
    public T data;
}
