package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ComandaEstadoRequest {

    @NotBlank
    private String flagEstado;
}
