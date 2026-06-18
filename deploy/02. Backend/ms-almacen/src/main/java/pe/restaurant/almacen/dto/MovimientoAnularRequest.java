package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class MovimientoAnularRequest {

    @NotNull
    private Long id;

    @NotBlank
    private String motivo;
}
