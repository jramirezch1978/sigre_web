package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AlmacenUsuarioAsignarRequest {

    @NotNull(message = "usuarioId es obligatorio")
    private Long usuarioId;
}
