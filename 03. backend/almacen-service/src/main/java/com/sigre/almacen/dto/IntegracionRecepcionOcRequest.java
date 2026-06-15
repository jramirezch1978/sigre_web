package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Orquestación recepción OC → ingreso de almacén (bloque F).
 */
@Getter
@Setter
@NoArgsConstructor
public class IntegracionRecepcionOcRequest {

    @NotNull
    private Long ordenCompraId;

    /** Tipo de movimiento con {@code flag_clase_mov = 'I'} y referencia habilitada. */
    @NotNull
    private Long articuloMovTipoId;

    /** Almacén donde ingresa la mercadería; sólo se incluyen líneas OC con {@code almacen_id} nulo o igual a este valor. */
    @NotNull
    private Long almacenId;

    private LocalDate fechaMov;

    private String observaciones;

    /** Si null, usa {@code app.almacen.integracion.validar-tres-vias}. */
    private Boolean validarTresVias;

    /** Conteo físico (fila {@code inventario_conteo}) para cruzar cantidad con la recepción. */
    private Long inventarioConteoId;

    /** Tolerancia numérica; si null, usa configuración del MS. */
    private BigDecimal toleranciaTresVias;
}
