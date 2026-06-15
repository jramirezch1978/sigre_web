package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DTO de respuesta agrupada para pendientes por pagar.
 * Agrupa los documentos pendientes por tipo con totales calculados.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PendientesPagarResponse {

    @Builder.Default
    private List<CuentaPagarItem> cuentasPagar = new ArrayList<>();
    
    @Builder.Default
    private List<OrdenGiroItem> ordenesGiro = new ArrayList<>();
    
    @Builder.Default
    private List<LiquidacionItem> liquidaciones = new ArrayList<>();
    
    @Builder.Default
    private List<RetencionItem> retenciones = new ArrayList<>();
    
    @Builder.Default
    private List<DetraccionItem> detracciones = new ArrayList<>();
    
    private Totales totales;

    /**
     * Item de Cuenta por Pagar pendiente
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CuentaPagarItem {
        private Long id;
        private Long proveedorId;
        private String proveedorRazonSocial;
        private Long docTipoId;
        private String docTipoNombre;
        private String serie;
        private String numero;
        private LocalDate fechaEmision;
        private LocalDate fechaVencimiento;
        private String monedaCodigo;
        private BigDecimal total;
        private BigDecimal saldo;
        private Boolean esDirecto;
    }

    /**
     * Item de Orden de Giro pendiente
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrdenGiroItem {
        private Long id;
        private String numero;
        private LocalDate fecha;
        private Long solicitanteId;
        private String solicitanteNombre;
        private BigDecimal monto;
        private String motivo;
        private String tipoSolicitud;
    }

    /**
     * Item de Liquidación pendiente (saldo negativo)
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LiquidacionItem {
        private Long id;
        private String nroLiquidacion;
        private LocalDate fechaRegistro;
        private Long proveedorId;
        private String proveedorRazonSocial;
        private String monedaCodigo;
        private BigDecimal importeNeto;
        private BigDecimal saldo;
    }

    /**
     * Item de Retención pendiente
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RetencionItem {
        private Long id;
        private String nroCertificado;
        private LocalDate fechaEmision;
        private Long proveedorId;
        private String proveedorRazonSocial;
        private BigDecimal saldoSol;
        private BigDecimal saldoDol;
        private BigDecimal importeDoc;
    }

    /**
     * Item de Detracción pendiente
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DetraccionItem {
        private Long id;
        private String nroDetraccion;
        private LocalDate fechaRegistro;
        private String nroDeposito;
        private LocalDate fechaDeposito;
        private BigDecimal importe;
    }

    /**
     * Totales calculados por tipo de documento
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Totales {
        private BigDecimal cuentasPagar;
        private BigDecimal ordenesGiro;
        private BigDecimal liquidaciones;
        private BigDecimal retenciones;
        private BigDecimal detracciones;
        private BigDecimal totalGeneral;
    }
}
