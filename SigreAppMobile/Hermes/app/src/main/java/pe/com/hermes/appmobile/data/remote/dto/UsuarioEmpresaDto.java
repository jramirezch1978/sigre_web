package pe.com.hermes.appmobile.data.remote.dto;

/** Usuario activo de la empresa (auth/seguridad). */
public class UsuarioEmpresaDto {
    public long id;
    public String email;
    public String username;
    public String nombres;
    public String apellidos;
    public String nombreCompleto;
    public Boolean activo;
}
