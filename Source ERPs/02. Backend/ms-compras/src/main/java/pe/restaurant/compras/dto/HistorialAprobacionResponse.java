package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HistorialAprobacionResponse {

    private Long id;
    private Integer nivel;
    private String accion;
    private Long aprobadorId;
    private String comentario;
    private OffsetDateTime fecha;
}
