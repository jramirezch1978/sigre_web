package pe.restaurant.core.client.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PlanContableDetResponse {
    private Long id;
    private String cntaCtbl;
    private String nombre;
    private String flagEstado;
}
