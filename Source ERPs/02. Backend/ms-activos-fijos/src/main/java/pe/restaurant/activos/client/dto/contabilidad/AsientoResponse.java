package pe.restaurant.activos.client.dto.contabilidad;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoResponse {

    private Long id;
    private String voucher;
    private Long libroId;
    private LocalDate fecha;
    private String glosa;
    private String tipo;
    private String moduloOrigen;
    private Long documentoOrigenId;
    private String flagEstado;
}
