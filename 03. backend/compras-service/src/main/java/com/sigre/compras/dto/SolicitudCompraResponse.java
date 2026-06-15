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
public class SolicitudCompraResponse {

    private Long id;
    private String numero;
    private LocalDate fecha;
    private String prioridad;
    private String flagEstado;
    private Integer totalItems;
    private Long solicitanteId;
    private Long sucursalId;
}
