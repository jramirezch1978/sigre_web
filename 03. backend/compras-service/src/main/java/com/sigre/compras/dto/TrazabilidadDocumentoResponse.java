package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrazabilidadDocumentoResponse {
    private String tipoDocumento;
    private Long documentoId;
    private String numero;
    private LocalDate fecha;
    private String flagEstado;
}
