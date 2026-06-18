package pe.restaurant.core.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class ArticuloDetalleResponse extends ArticuloResponse {
    private String unidadMedidaNombre;
    private String articuloCategDescCateg;
    private String articuloSubCategDescSubcateg;
    private List<ArticuloImpuestoResponse> impuestos;
}
