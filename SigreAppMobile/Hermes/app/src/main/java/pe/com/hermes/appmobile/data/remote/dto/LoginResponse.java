package pe.com.hermes.appmobile.data.remote.dto;

/** Espejo de com.sigre.seguridad.dto.LoginResponse. */
public class LoginResponse {
    public String accessToken;
    public String refreshToken;
    public String tokenType;
    public long expiresInSeconds;
    public boolean temporal;
    public Long userId;
    public String email;
    public String username;
    public String nombres;
    public String apellidos;
    public String nombreCompleto;
    public Long empresaId;
    public String empresaCodigo;
    public String empresaNombre;
    public String empresaRuc;
    public Long sucursalId;
    public String sucursalNombre;
    public Boolean adminSistema;
    public String tipoSales;
}
