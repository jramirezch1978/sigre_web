package pe.restaurant.compras.dto;

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
public class CotizacionRequest {

    @NotNull
    private Long proveedorId;

    @NotNull
    private LocalDate fecha;

    private Long monedaId;

    @NotEmpty
    @Valid
    private List<CotizacionDetRequest> lineas;
}
