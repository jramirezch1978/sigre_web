package pe.restaurant.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenTrabajoResponse {

    private Long id;

    private SucursalInfo sucursal;
    private OtTipoInfo otTipo;
    private OtAdministracionInfo otAdministracion;

    private String codigo;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String flagEstado;

    private List<OperacionInfo> operaciones;

    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
