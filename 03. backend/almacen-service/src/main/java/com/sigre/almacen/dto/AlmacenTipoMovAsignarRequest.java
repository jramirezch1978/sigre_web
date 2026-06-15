package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AlmacenTipoMovAsignarRequest {

    @NotNull(message = "articuloMovTipoId es obligatorio")
    private Long articuloMovTipoId;
}
