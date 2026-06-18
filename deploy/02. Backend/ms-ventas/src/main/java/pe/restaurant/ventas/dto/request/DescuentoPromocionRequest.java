package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DescuentoPromocionRequest {

    @NotBlank
    private String nombre;

    @NotNull
    private String tipo;

    private BigDecimal valor;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String diasAplicacion;
    private LocalTime horaInicio;
    private LocalTime horaFin;
    private BigDecimal montoMinimo;
}
