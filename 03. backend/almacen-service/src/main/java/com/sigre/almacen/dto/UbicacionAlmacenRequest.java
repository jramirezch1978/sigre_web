package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UbicacionAlmacenRequest {

    @NotBlank
    @Size(max = 20)
    private String codigo;

    @NotBlank
    @Size(max = 120)
    private String nombre;

    @Size(max = 30)
    private String pasillo;

    @Size(max = 30)
    private String estante;

    @Size(max = 30)
    private String nivel;
}
