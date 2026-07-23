package pe.com.hermes.appmobile.data.remote.dto;

public class PerfilUpdateRequest {
    public String nombres;
    public String apellidos;
    public String numeroDocumento;
    public String email;
    public String codigoConfirmacionEmail;

    public PerfilUpdateRequest(String nombres, String apellidos, String numeroDocumento,
                               String email, String codigoConfirmacionEmail) {
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.numeroDocumento = numeroDocumento;
        this.email = email;
        this.codigoConfirmacionEmail = codigoConfirmacionEmail;
    }
}
