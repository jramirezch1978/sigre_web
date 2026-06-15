package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenServicioSaldoPendienteResponse {

    private Long ordenServicioId;
    private String nroOs;
    private BigDecimal montoTotal;
    private BigDecimal impProvisionadoTotal;
    private BigDecimal saldoPendiente;
    private BigDecimal porcentajeProvisionado;
    private List<LineaSaldo> lineas;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LineaSaldo {
        private Long lineaId;
        private Integer nroItem;
        private String servicioCodigo;
        private BigDecimal importe;
        private BigDecimal impProvisionado;
        private BigDecimal saldoPendiente;
        private Boolean tieneConformidad;
    }
}
