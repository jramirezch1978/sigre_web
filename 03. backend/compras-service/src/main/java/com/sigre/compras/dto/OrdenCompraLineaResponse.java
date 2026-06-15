package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenCompraLineaResponse {

    private Long id;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloDescripcion;
    private Long unidadMedidaId;
    private String unidadMedidaCodigo;
    private BigDecimal cantProyectada;
    private LocalDate fecProyectada;
    private BigDecimal cantProcesada;
    private BigDecimal cantFacturada;
    private BigDecimal valorUnitario;
    private Long tipoImpuestoId;
    private String tipoImpuestoDescripcion;
    private BigDecimal valorImpuesto;
    private BigDecimal descuentoPorcentaje;
    private BigDecimal descuentoMonto;
    private Long tipoPercepcionId;
    private BigDecimal percepcionMonto;
    private BigDecimal subtotal;
    private Long centrosCostoId;
    private Long almacenId;
    private Long referenciaSolCompraId;
    private BigDecimal cantidadPendiente;
    private LocalDate fechaEntrega;
    private String flagEstado;
    private Long operacionesDetId;
    private Long progComprasDetId;
}
