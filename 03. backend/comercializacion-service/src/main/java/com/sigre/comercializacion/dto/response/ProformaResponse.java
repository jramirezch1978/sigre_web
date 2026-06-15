package com.sigre.comercializacion.dto.response;

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
public class ProformaResponse {
    private Long id;
    private Long sucursalId;
    private Long clienteId;
    private String numero;
    private LocalDate fecha;
    private LocalDate fechaValidez;
    private Long monedaId;
    private BigDecimal subtotal;
    private BigDecimal igv;
    private BigDecimal total;
    private String flagEstado;
    private List<ProformaDetResponse> detalles;
}
