package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotaResponse {

    private Long id;
    private Long sucursalId;
    private Long proveedorId;
    private String proveedorRazonSocial;
    private Long docTipoId;
    private String docTipoCodigo;
    private String docTipoNombre;
    private String serie;
    private String numero;
    private LocalDateTime fechaEmision;
    private LocalDateTime fechaVencimiento;
    private Long monedaId;
    private String monedaCodigo;
    private BigDecimal total;
    private BigDecimal saldo;
    private String monedaSimbolo;
    private Integer ano;
    private Integer mes;
    private Long cntblLibroId;
    private Long cntblAsientoId;
    private String flagEstado;
    private Long createdBy;
    private LocalDateTime fecCreacion;
    private Long updatedBy;
    private LocalDateTime fecModificacion;
    private List<NotaDetalleResponse> detalles;
    private AsientoContableResponse asiento;
}
