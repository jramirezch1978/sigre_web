package pe.com.hermes.appmobile.data.remote.dto;

/** Espejo de com.sigre.seguridad.dto.SeleccionEmpresaRequest. */
public class SeleccionEmpresaRequest {
    public long empresaId;
    public long sucursalId;
    public String ipAddress;
    public String ipPrivada;
    public String browser = "Hermes Android";
    public String sistemaOperativo = "Android";
    /** Login (correo o usuario). Con password permite llamar sin Bearer. */
    public String email;
    /** Contraseña cifrada AES (PasswordCrypto), igual que /auth/login. */
    public String password;
    public String passwordHash;

    public SeleccionEmpresaRequest(long empresaId, long sucursalId) {
        this.empresaId = empresaId;
        this.sucursalId = sucursalId;
    }
}
