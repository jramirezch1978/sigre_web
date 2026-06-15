package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloCategArbolResponse {
    private Long id;
    private String catArt;
    private String descCateg;
    private String flagEstado;
    private List<ArticuloSubCategResponse> subCategorias;
}
