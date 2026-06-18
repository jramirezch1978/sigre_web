package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CatalogoSunatDetResponse {
    private Long id;
    private Long catalogoSunatId;
    private String codigoItem;
    private String nombreItem;
    private String descripcionItem;
    private String flagEstado;
}
