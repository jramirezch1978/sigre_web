package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloProveedorResponse {
    private Long id;
    private Long articuloId;
    private Long proveedorId;
    private String proveedorRazonSocial;
}
