package pe.restaurant.compras.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionComprasRequest {

    @NotNull
    private Integer anio;

    @NotNull
    private Integer mes;

    @Valid
    @NotNull
    private List<ProgramacionComprasDetRequest> lineas;
}
