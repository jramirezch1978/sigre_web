package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

/**
 * Orquestación despacho OV → salida de almacén (bloque F).
 */
@Getter
@Setter
@NoArgsConstructor
public class IntegracionSalidaOvRequest {

    @NotNull
    private Long ordenVentaId;

    /** Tipo de movimiento con {@code flag_clase_mov = 'V'} y referencia habilitada. */
    @NotNull
    private Long articuloMovTipoId;

    /** Almacén desde el que sale stock; líneas OV con otro {@code almacen_id} se excluyen. */
    @NotNull
    private Long almacenId;

    private LocalDate fechaMov;

    private String observaciones;
}
