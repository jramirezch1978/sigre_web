package com.sigre.almacen.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Filtros opcionales para procesos masivos (cuadre / recálculo). */
@Getter
@Setter
@NoArgsConstructor
public class ProcesoAlmacenFiltroRequest {
    private Long almacenId;
}
