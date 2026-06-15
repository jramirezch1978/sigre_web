package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AlmacenTipoMovResponse {

    private Long id;
    private Long almacenId;
    private Long articuloMovTipoId;
    private String tipoMov;
    private String descTipoMov;
    private String flagEstado;
}
