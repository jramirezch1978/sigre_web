package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadArticuloRequest {

    @NotNull
    private Long entidadContribuyenteId;

    @NotNull
    private Long articuloId;

    private BigDecimal precioReferencia;

    private String flagEstado = "1";
}
