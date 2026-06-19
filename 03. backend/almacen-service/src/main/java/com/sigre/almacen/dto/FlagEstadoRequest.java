package com.sigre.almacen.dto;

import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

/**
 * Campo común para entidades con estado binario (0 = anulado, 1 = activo).
 */
@Getter
@Setter
public abstract class FlagEstadoRequest {

    @Pattern(regexp = "[01]", message = "El estado debe ser 0 (anulado) o 1 (activo)")
    private String flagEstado;
}
