package pe.com.hermes.appmobile.data.remote.dto;

/** Espejo de com.sigre.seguridad.dto.LoginRequest. */
public class LoginRequest {
    public String email;
    public String password;
    public String ipAddress;
    public String ipPrivada;
    public String browser = "Hermes Android";
    public String sistemaOperativo = "Android";
    public String deviceName;

    public LoginRequest(String email, String password) {
        this.email = email;
        this.password = password;
    }
}
