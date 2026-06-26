package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class SolicitudCompraDetRequest {

    @NotNull
    private Long articuloId;

    private Long almacenId;

    @NotNull
    @Positive
    private BigDecimal cantidad;

    private String especificaciones;
}
