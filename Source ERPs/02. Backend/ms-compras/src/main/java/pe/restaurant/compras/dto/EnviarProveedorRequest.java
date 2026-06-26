package pe.restaurant.compras.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class EnviarProveedorRequest {

    private String emailDestino;
    private String asunto;
    private String mensaje;
}
