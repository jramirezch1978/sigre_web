package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SolSalidaResponse {
    private Long id;
    private Long almacenId;
    private String numero;
    private LocalDate fecha;
    private Long solicitanteId;
    private String flagEstado;
    private String observacion;
    private List<SolSalidaLineaResponse> lineas;
}
