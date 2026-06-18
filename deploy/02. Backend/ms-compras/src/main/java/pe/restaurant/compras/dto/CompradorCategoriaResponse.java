package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CompradorCategoriaResponse {
    private Long id;
    private Long compradorId;
    private Long articuloCategId;
}
