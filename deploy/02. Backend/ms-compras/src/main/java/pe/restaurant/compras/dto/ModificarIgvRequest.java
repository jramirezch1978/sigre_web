package pe.restaurant.compras.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class ModificarIgvRequest {

    @NotEmpty
    @Valid
    private List<LineaIgv> lineas;

    @Getter
    @Setter
    @NoArgsConstructor
    public static class LineaIgv {

        @NotNull
        private Long lineaId;

        @NotNull
        private Long tipoImpuestoId;
    }
}
