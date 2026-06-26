package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AlmacenTacitoResponse {

    private Long id;
    private String codClase;
    private Long sucursalId;
    private Long almacenId;
    private String flagEstado;
    private OffsetDateTime fecCreacion;
    private OffsetDateTime fecModificacion;
}
