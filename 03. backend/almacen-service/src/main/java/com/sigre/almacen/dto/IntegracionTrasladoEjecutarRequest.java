package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

/**
 * Ejecuta el saldo pendiente de una orden de traslado:
 * un vale de salida en almacén origen + vale espejo de ingreso (si {@code flag_mov_entre_alm = '1'}).
 */
@Getter
@Setter
@NoArgsConstructor
public class IntegracionTrasladoEjecutarRequest {

    @NotNull
    private Long ordenTrasladoId;

    /**
     * Tipo de movimiento de salida: {@code flag_clase_mov = 'T'}, {@code flag_mov_entre_alm = '1'}.
     */
    @NotNull
    private Long articuloMovTipoId;

    private LocalDate fechaMov;

    private String observaciones;
}
