package pe.com.sytco.fastsales.api.rrhh.dto;

public class RestResponse<T> {
    private boolean ok;
    private String mensaje;
    private T data;

    public boolean isOk() {
        return ok;
    }

    public String getMensaje() {
        return mensaje;
    }

    public T getData() {
        return data;
    }

    public void setOk(boolean ok) {
        this.ok = ok;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public void setData(T data) {
        this.data = data;
    }
}
