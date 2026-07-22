package pe.com.hermes.appmobile.data.remote.dto;

/** Espejo de com.sigre.seguridad.dto.LoginRequest. */
public class LoginRequest {
    public String email;
    /** AES-256-CTR cifrado (ver PasswordCrypto) — el backend NUNCA acepta texto plano aquí. */
    public String password;
    /** SHA-256 hex del texto plano, para que el backend verifique integridad tras desencriptar. */
    public String passwordHash;
    public String ipAddress;
    public String ipPrivada;
    public String browser = "Hermes Android";
    public String sistemaOperativo = "Android";
    public String deviceName;
    /** Nro de registro devuelto por /auth/dispositivo/registrar — requerido por /auth/login/mobile. */
    public String nroRegistroDispositivo;

    public LoginRequest(String email, String encryptedPassword, String passwordHash) {
        this.email = email;
        this.password = encryptedPassword;
        this.passwordHash = passwordHash;
    }
}
