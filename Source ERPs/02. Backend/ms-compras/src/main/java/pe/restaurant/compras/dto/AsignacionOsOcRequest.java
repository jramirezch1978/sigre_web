package pe.restaurant.compras.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class AsignacionOsOcRequest {

    @NotNull
    private Long ordenCompraId;

    @NotEmpty
    @Valid
    private List<LineaAsignacion> lineas;

    @Getter
    @Setter
    @NoArgsConstructor
    public static class LineaAsignacion {

        @NotNull
        private Long lineaOsId;

        @NotNull
        private Long lineaOcId;

        @NotNull
        private BigDecimal monto;
    }
}
