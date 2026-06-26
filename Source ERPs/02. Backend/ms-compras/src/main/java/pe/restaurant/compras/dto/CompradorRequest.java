package pe.restaurant.compras.dto;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CompradorRequest {

    private Long usuarioId;

    @Size(max = 150)
    private String nombre;

    private String flagEstado = "1";
}
