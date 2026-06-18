package pe.restaurant.almacen.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class SolSalidaRequest {
    @NotNull
    private Long almacenId;
    @NotNull
    private LocalDate fecha;
    private Long solicitanteId;
    private String observacion;
    @NotEmpty
    @Valid
    private List<SolSalidaLineaRequest> lineas;
}
