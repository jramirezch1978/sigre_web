package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class MovimientoConfirmarRequest {

    @NotNull
    private Long id;

    private String observacion;
}
