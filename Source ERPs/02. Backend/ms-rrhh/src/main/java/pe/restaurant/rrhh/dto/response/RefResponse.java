package pe.restaurant.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RefResponse {
    private Long id;
    private String codigo;
    private String nombre;
}
