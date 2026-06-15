package com.sigre.comercializacion.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Generación de detracción por cobrar vinculada a una CxC de factura emitida.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CuentaCobrarDetraccionRequest {

    /** Tasa de detracción (ej. 0.12 = 12 %). Por defecto 12 %. */
    private BigDecimal tasa;

    /** Serie del documento DTRC; por defecto {@code DTR}. */
    private String serie;

    /** Número del documento DTRC; por defecto correlativo según origen. */
    private String numero;

    /** Concepto financiero; por defecto FI-098. */
    private Long conceptoFinancieroId;
}
