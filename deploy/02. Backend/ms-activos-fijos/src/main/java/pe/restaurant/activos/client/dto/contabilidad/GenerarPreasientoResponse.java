package pe.restaurant.activos.client.dto.contabilidad;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

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
