package pe.restaurant.activos.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfMaestroDesdeCompraRequest {

    @NotNull
    private Long ordenCompraId;

    @NotNull
    private Long ordenCompraLineaId;

    @NotBlank
    @Size(max = 30)
    private String codigo;

    @Size(max = 220)
    private String nombre;

    @NotNull
    private Long afSubClaseId;

    private Long afUbicacionId;

    private LocalDate fechaAdquisicion;

    @NotNull
    @DecimalMin("0.01")
    @Digits(integer = 14, fraction = 4)
    private BigDecimal valorAdquisicion;

    @NotNull
    @DecimalMin("0.00")
    @Digits(integer = 14, fraction = 4)
    private BigDecimal valorResidual;

    private Long proveedorId;
}
