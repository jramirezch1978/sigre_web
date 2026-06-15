package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenCompraDetalleResponse {

    private Long id;
    private Long sucursalId;
    private Long proveedorId;
    private String proveedorRazonSocial;
    private String proveedorRuc;
    private String nroOrdenCompra;
    private LocalDate fechaEmision;
    private LocalDate fechaEntrega;
    private Long monedaId;
    private String monedaCodigo;
    private Long formaPagoId;
    private Long entidadBancoCntaId;
    private String lugarEntrega;
    private String observaciones;
    private BigDecimal tipoCambio;
    private String flagImportacion;
    private String flagSolicitaDua;
    private Long bancoId;
    private String nroCuenta;
    private String centroBeneficio;
    private BigDecimal subtotal;
    private BigDecimal descuentoTotal;
    private BigDecimal igvTotal;
    private BigDecimal percepcionTotal;
    private BigDecimal total;
    private String flagEstado;
    private Long compradorId;
    private String compradorNombre;
    private Long aprobadorId;
    private String aprobadorNombre;
    private OffsetDateTime fechaAprobacion;
    private String motivoAnulacion;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
    private List<OrdenCompraLineaResponse> lineas;
    private OcImportacionDto importacion;
}
