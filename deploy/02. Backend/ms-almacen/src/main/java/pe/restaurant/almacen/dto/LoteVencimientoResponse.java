package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * Lote próximo a vencer / vencido. Fuente: {@code almacen.lote_pallet}.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoteVencimientoResponse {

    private Long id;
    private Long almacenId;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloNombre;
    private String nroLote;
    private LocalDate fechaProduccion;
    private LocalDate fechaVencimiento;
    /** Días desde hoy hasta el vencimiento (negativo si ya venció). */
    private Long diasParaVencer;
    private String observacion;
    private String flagEstado;
}
