package com.sigre.comercializacion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PedidoMesaResponse {

    private Long id;
    private Long sucursalId;
    private String tipo;
    private Long mesaId;
    private String mesaNumero;
    private Long meseroId;
    private Long turnoId;
    private String numero;
    private Integer comensales;
    private Instant apertura;
    private Instant cierre;
    private String observaciones;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
