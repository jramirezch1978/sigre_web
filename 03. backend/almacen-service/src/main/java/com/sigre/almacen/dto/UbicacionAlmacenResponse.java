package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UbicacionAlmacenResponse {

    private Long id;
    private Long almacenId;
    private String codigo;
    private String nombre;
    private String pasillo;
    private String estante;
    private String nivel;
}
