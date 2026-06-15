package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GenerarAsientoResponse {

    private Long asientoId;
    private String voucher;
    private String moduloOrigen;
    private String tipoOperacion;
    private Long documentoOrigenId;
    private int totalLineasDetalle;
    private AsientoContableResponse asiento;
}
