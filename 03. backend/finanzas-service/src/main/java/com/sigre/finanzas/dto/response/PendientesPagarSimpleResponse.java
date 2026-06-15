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
 * DTO de respuesta simple unificada para pendientes por pagar.
 * Lista todos los documentos pendientes en una estructura común.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PendientesPagarSimpleResponse {

    @Builder.Default
    private List<PendientePagarItem> content = new ArrayList<>();
    
    private BigDecimal totalPendiente;

    /**
     * Item genérico de documento pendiente por pagar
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PendientePagarItem {
        private TipoDocumentoPagar tipoDocumento;
        private Long id;
        private String numero;
        private LocalDate fecha;
        private String proveedor;
        private BigDecimal total;
        private BigDecimal saldo;
        private String moneda;
        private String observacion;
    }

    /**
     * Enum para tipos de documentos por pagar
     */
    public enum TipoDocumentoPagar {
        CUENTA_PAGAR,
        ORDEN_GIRO,
        LIQUIDACION,
        RETENCION,
        DETRACCION
    }
}
