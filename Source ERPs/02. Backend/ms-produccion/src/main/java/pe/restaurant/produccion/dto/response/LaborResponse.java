package pe.restaurant.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LaborResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
