package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DTO de respuesta agrupada para pendientes por cobrar.
 * Agrupa los documentos pendientes por tipo con totales calculados.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PendientesCobrarResponse {

    @Builder.Default
    private List<CuentaCobrarItem> cuentasCobrar = new ArrayList<>();

    @Builder.Default
    private List<CuentaCobrarItem> documentosDirecto = new ArrayList<>();

    @Builder.Default
    private List<NotaCreditoItem> notasCreditoCobrar = new ArrayList<>();
    
    @Builder.Default
    private List<LiquidacionItem> liquidaciones = new ArrayList<>();
    
    @Builder.Default
    private List<OrdenGiroItem> ordenesGiro = new ArrayList<>();
    
    @Builder.Default
    private List<DetraccionItem> detraccionesCobrar = new ArrayList<>();
    
    private Totales totales;

    /**
     * Item de Cuenta por Cobrar pendiente
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CuentaCobrarItem {
        private Long id;
        private Long clienteId;
        private String clienteRazonSocial;
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
     * Item de Liquidación pendiente (saldo positivo)
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
     * Item de Orden de Giro pendiente (devolución aprobada)
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
     * Item de Detracción por cobrar (doc_tipo DTRC)
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DetraccionItem {
        private Long id;
        private Long cuentaCobrarOrigenId;
        private String nroDetraccion;
        private LocalDate fechaRegistro;
        private Long clienteId;
        private String clienteRazonSocial;
        private BigDecimal importe;
        private BigDecimal tasa;
    }

    /**
     * Nota de crédito por cobrar pendiente (doc_tipo NCC)
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class NotaCreditoItem {
        private Long id;
        private Long cuentaCobrarOrigenId;
        private Long clienteId;
        private String clienteRazonSocial;
        private String serie;
        private String numero;
        private LocalDate fechaEmision;
        private String monedaCodigo;
        private BigDecimal total;
        private BigDecimal saldo;
        private String motivo;
    }

    /**
     * Totales calculados por tipo de documento
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Totales {
        private BigDecimal cuentasCobrar;
        private BigDecimal documentosDirecto;
        private BigDecimal notasCreditoCobrar;
        private BigDecimal liquidaciones;
        private BigDecimal ordenesGiro;
        private BigDecimal detraccionesCobrar;
        private BigDecimal totalGeneral;
    }
}
