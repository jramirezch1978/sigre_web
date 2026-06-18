package pe.restaurant.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProvisionEmpresaResponse {

    private Long empresaId;
    private String codigo;
    private String ruc;
    private String dbName;
    /** Usuario y contraseña guardados en master.empresa (sigla normalizada en minúsculas; mismo valor para ambos). */
    private String tenantDbUser;
    private String dbHost;
    private Integer dbPort;
    private boolean exitoso;
    private String mensaje;
}
