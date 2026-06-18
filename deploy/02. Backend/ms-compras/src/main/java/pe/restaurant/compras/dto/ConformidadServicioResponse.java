package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConformidadServicioResponse {

    private Long id;
    private Long ordenServicioId;
    private LocalDate fecha;
    private String observacion;
    private Boolean aprobado;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
}
