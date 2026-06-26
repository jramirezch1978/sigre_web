package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CatalogoSunatResponse {
    private Long id;
    private String codigoCatalogo;
    private String nombreCatalogo;
    private String descripcionCatalogo;
    private String flagEstado;
}
