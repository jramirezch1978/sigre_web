package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class IntegracionContabilidadResult {

    private Long asientoId;
    private String moduloOrigen;
    private Long documentoOrigenId;
    private String correlacion;
    private boolean yaExistia;
}
