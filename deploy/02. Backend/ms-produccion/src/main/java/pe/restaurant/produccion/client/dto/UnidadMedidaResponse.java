package pe.restaurant.produccion.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UnidadMedidaResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String abreviatura;
    private String flagEstado;
}
