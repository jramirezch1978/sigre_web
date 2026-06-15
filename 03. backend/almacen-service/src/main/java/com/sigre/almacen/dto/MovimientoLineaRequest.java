package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class MovimientoLineaRequest {

    private Long id;

    @NotNull
    private Long articuloId;

    @NotNull
    @Positive
    private BigDecimal cantProcesada;

    private BigDecimal costoUnitario;

    private Long matrizContableId;

    private Long lotePalletId;

    private Long ubicacionAlmacenId;

    private Long centrosCostoId;

    private Long monedaId;

    private BigDecimal pesoNetoTm;

    private Long ocDetId;

    /** FK a almacen.orden_traslado_det. Aplica cuando tipoReferenciaOrigen = 'T'. */
    private Long ordenTrasladoDetId;

    /** FK a ventas.orden_venta_det. Aplica cuando tipoReferenciaOrigen = 'V'. */
    private Long ordenVentaDetId;

    /** FK a produccion.operaciones_det. Aplica cuando tipoReferenciaOrigen = 'P'. */
    private Long operacionesDetId;
}
