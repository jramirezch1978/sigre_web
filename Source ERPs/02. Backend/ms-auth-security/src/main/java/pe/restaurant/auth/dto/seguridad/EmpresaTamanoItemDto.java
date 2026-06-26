package pe.restaurant.auth.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmpresaTamanoItemDto {
    private Long empresaId;
    private String codigo;
    private String razonSocial;
    private String dbName;
    /** Tamaño de la BD en el cluster actual (megabytes). 0 si no existe el datname. */
    private Double tamanoMb;
}
