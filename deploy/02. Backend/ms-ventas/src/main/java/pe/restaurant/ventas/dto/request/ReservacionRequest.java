package pe.restaurant.ventas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservacionRequest {

    private Long sucursalId;
    private Long clienteId;
    private Long mesaId;

    /** Opcional: enlace a factura/boleta simplificada (no anulada) para validaciones al anular comprobante. */
    private Long fsFacturaSimplId;

    @NotNull
    private LocalDate fecha;

    @NotNull
    private LocalTime hora;

    private Integer comensales;
    private String observaciones;

    @Valid
    private List<ReservacionItemRequest> items;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ReservacionItemRequest {
        private Long articuloId;
        private java.math.BigDecimal cantidad;
        private String observacion;
    }
}
