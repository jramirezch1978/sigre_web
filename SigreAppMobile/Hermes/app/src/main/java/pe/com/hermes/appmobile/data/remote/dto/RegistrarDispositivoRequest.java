package pe.com.hermes.appmobile.data.remote.dto;

/** Espejo de com.sigre.seguridad.dto.RegistrarDispositivoRequest. */
public class RegistrarDispositivoRequest {
    public String deviceId;
    public String imei;
    public String fabricante;
    public String modelo;
    public String nombreDispositivo;
    public String software;

    public RegistrarDispositivoRequest(String deviceId, String fabricante, String modelo,
                                        String nombreDispositivo, String software) {
        this.deviceId = deviceId;
        this.fabricante = fabricante;
        this.modelo = modelo;
        this.nombreDispositivo = nombreDispositivo;
        this.software = software;
    }
}
