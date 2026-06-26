package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservacionResponse {
    private Long id;
    private Long sucursalId;
    private String sucursalNombre;
    private Long clienteId;
    private String clienteRazonSocial;
    private Long mesaId;
    private String mesaNumero;
    private Long fsFacturaSimplId;
    private LocalDate fecha;
    private LocalTime hora;
    private Integer comensales;
    private String estado;
    private String observaciones;
    private String motivoCancelacion;
    private String flagEstado;
    private List<ReservacionDetResponse> items;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ReservacionDetResponse {
        private Long id;
        private Long articuloId;
        private BigDecimal cantidad;
        private String observacion;
    }
}
