package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoManualRequest {

    @NotNull(message = "La fecha contable es obligatoria")
    private LocalDate fechaContable;

    @NotNull(message = "El libro contable es obligatorio")
    @Positive(message = "El libro contable debe ser un id válido")
    private Long libroId;

    @NotNull(message = "La moneda es obligatoria")
    private Long monedaId;

    @NotNull(message = "La tasa de cambio es obligatoria")
    @Positive(message = "La tasa de cambio debe ser mayor a cero")
    private BigDecimal tasaCambio;

    private String tipoOperacion;

    @NotBlank(message = "La glosa es obligatoria")
    private String glosa;

    @NotNull(message = "Los detalles del asiento son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un detalle")
    @Valid
    private List<AsientoManualDetalleRequest> detalles;
}
