package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Respuesta de {@code integraciones/traslado-ejecutar}: vale de salida + vale de ingreso espejo.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class IntegracionTrasladoResultadoResponse {

    private MovimientoDetalleResponse movimientoSalida;

    private MovimientoDetalleResponse movimientoIngreso;
}
