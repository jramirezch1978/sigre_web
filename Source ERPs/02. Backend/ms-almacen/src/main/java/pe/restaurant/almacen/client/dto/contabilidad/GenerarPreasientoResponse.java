package pe.restaurant.almacen.client.dto.contabilidad;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Respuesta de ms-contabilidad al generar un pre-asiento. Coincide con
 * {@code pe.restaurant.contabilidad.dto.response.GenerarPreasientoResponse}.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GenerarPreasientoResponse {

    private Long preasientoId;
    private String voucher;
    private String moduloOrigen;
    private String tipoOperacion;
    private Long documentoOrigenId;
    private int totalLineasDetalle;
    private String estado;
}
