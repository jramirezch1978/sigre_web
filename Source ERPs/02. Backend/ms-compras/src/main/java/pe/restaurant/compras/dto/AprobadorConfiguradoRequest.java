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
public class AprobadorConfiguradoRequest {

    @NotNull
    private Long docTipoId;

    @NotNull
    private Integer nivel;

    @NotNull
    private Long aprobadorId;

    private BigDecimal montoMinimo;

    private BigDecimal montoMaximo;
}
