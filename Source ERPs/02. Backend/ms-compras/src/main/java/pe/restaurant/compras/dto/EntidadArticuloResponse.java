package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadArticuloResponse {
    private Long id;
    private Long entidadContribuyenteId;
    private Long articuloId;
    private BigDecimal precioReferencia;
    private String flagEstado;
}
