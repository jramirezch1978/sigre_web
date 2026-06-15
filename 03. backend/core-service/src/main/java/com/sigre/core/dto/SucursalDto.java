package com.sigre.core.dto;

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
public class SucursalDto {
    private Long id;
    private String codigo;
    private String nombre;
    private String direccion;
    private String ciudad;
    private String pais;
    private String departamento;
    private String provincia;
    private String distrito;
}
