package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Línea de pérdida/merma: salida de inventario cuyo tipo de movimiento es de
 * merma/baja/pérdida (ver {@code REGISTRO_PERDIDAS} / HU-ALM-OP-AJU-002).
 * Derivada de {@code vale_mov_det} + su cabecera {@code vale_mov}.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerdidaResponse {

    private Long valeMovId;
    private Long valeMovDetId;
    private String nroVale;
    private LocalDate fecha;
    private Long almacenId;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloNombre;
    private Long articuloMovTipoId;
    private String tipoMov;
    private String descTipoMov;
    private BigDecimal cantidadPerdida;
    private BigDecimal costoUnitario;
    private BigDecimal valorPerdida;
    private String observacion;
}
