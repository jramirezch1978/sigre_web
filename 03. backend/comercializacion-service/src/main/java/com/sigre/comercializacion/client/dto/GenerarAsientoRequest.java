package com.sigre.comercializacion.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GenerarAsientoRequest {
    private Long documentoId;
    private LocalDate fecha;
    private Long sucursalId;
    private Long monedaId;
    private BigDecimal tipoCambio;
    private BigDecimal total;
    private BigDecimal saldo;
    private Long proveedorId;
    private Long clienteId;
    private Long docTipoId;
    private String serie;
    private String numero;
    private Long bancoCntaId;
    private Long bancoCntaRefId;
    private Long solicitudGiroId;
    private String glosa;
    private List<DocumentoDetalleRequest> detalles;
}

