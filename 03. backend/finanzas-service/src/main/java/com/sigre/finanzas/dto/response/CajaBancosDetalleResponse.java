package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CajaBancosDetalleResponse {

    private Long id;
    private Long sucursalId;
    private String nroRegistro;
    private String flagTipoTransaccion;
    private Long bancoCntaId;
    private String bancoCntaCodigo;
    private Long bancoCntaRefId;
    private String bancoCntaRefCodigo;
    private LocalDate fechaEmision;
    private LocalDate fechaProgramada;
    private LocalDate fechaEjecucion;
    private String flagPago;
    private Long monedaId;
    private String monedaCodigo;
    private Long entidadContribuyenteId;
    private String entidadRazonSocial;
    private BigDecimal impTotal;
    private BigDecimal impAsignado;
    private Long conceptoFinancieroId;
    private String conceptoFinancieroNombre;
    private Integer ano;
    private Integer mes;
    private Long cntblLibroId;
    private Long docTipoId;
    private String nroDoc;
    private String observacion;
    private BigDecimal tasaCambio;
    private Long medioPagoId;
    private Long cntblAsientoId;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
    private List<CajaBancosDetResponse> detalles;
}
