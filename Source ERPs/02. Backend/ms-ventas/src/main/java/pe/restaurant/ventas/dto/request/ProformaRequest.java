package pe.restaurant.ventas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProformaRequest {

    private Long sucursalId;
    private Long clienteId;

    private String numero;

    @NotNull
    private LocalDate fecha;

    private LocalDate fechaValidez;
    private Long monedaId;

    @Valid
    private List<ProformaDetLineRequest> detalles;
}
