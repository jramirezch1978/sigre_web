package com.sigre.contabilidad.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentoDetalleRequest {

    private Long id;
    private Integer item;
    private String tipoMov;
    private BigDecimal monto;
    private BigDecimal importeRetenido;
    private String referencia;
    private Long monedaId;

    @NotNull(message = "El concepto financiero es obligatorio en cada detalle")
    private Long conceptoFinancieroId;
    private Long cntasPagarId;
    private Long cntasCobrarId;
    private Long centrosCostoId;
    private String codFlujoFaja;
    private String glosa;
}
