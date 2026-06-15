package com.sigre.comercializacion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DTO de respuesta simple unificada para pendientes por cobrar.
 * Lista todos los documentos pendientes en una estructura común.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PendientesCobrarSimpleResponse {

    @Builder.Default
    private List<PendienteCobrarItem> content = new ArrayList<>();
    
    private BigDecimal totalPendiente;

    /**
     * Item genérico de documento pendiente por cobrar
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PendienteCobrarItem {
        private TipoDocumentoCobrar tipoDocumento;
        private Long id;
        private String numero;
        private LocalDate fecha;
        private String cliente;
        private BigDecimal total;
        private BigDecimal saldo;
        private String moneda;
        private String observacion;
    }

    /**
     * Enum para tipos de documentos por cobrar
     */
    public enum TipoDocumentoCobrar {
        CUENTA_COBRAR,
        DOCUMENTO_DIRECTO,
        NOTA_CREDITO,
        LIQUIDACION,
        ORDEN_GIRO,
        DETRACCION
    }
}
