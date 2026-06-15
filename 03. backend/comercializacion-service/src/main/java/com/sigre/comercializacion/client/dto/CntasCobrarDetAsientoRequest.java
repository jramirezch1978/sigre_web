package com.sigre.comercializacion.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.sigre.comercializacion.dto.request.DetImpuestoRequest;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CntasCobrarDetAsientoRequest {

    private Long id;
    private Long conceptoFinancieroId;
    private LocalDate fechaMov;
    private String tipoMov;
    private BigDecimal monto;
    private List<DetImpuestoRequest> impuestos;
    private String referencia;
    private String glosa;
}
