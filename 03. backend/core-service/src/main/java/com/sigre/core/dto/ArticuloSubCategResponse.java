package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloSubCategResponse {
    private Long id;
    private String codSubCat;
    private String descSubcateg;
    private Long articuloCategId;
    private String flagEstado;
}
