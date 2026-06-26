package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BatchResultItem {

    private Long id;
    private boolean exito;
    private String mensaje;
}
