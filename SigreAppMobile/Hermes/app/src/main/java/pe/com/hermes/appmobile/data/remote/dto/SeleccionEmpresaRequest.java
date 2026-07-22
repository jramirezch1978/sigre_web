package pe.com.hermes.appmobile.data.remote.dto;

/** Espejo de com.sigre.seguridad.dto.SeleccionEmpresaRequest. */
public class SeleccionEmpresaRequest {
    public long empresaId;
    public long sucursalId;
    public String ipAddress;
    public String ipPrivada;
    public String browser = "Hermes Android";
    public String sistemaOperativo = "Android";
    public String email;
    public String password;

    public SeleccionEmpresaRequest(long empresaId, long sucursalId) {
        this.empresaId = empresaId;
        this.sucursalId = sucursalId;
    }
}
