package com.sigre.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloRequest {
    @NotBlank
    @Size(max = 30)
    private String codigo;

    @NotBlank
    @Size(max = 200)
    private String nombre;

    @NotBlank
    @Size(max = 20)
    private String tipo;

    @Size(max = 500)
    private String descripcion;

    @NotNull
    private Long unidadMedidaId;

    private Long articuloCategId;
    private Long articuloSubCategId;
    private Long articuloClaseId;
    private Long naturalezaContableId;
    private Long marcaId;
    private Long colorId;
    private String flagEstado = "1";
}
