package pe.restaurant.activos.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfPolizaSeguroRequest {

    @NotNull(message = "El ID de la aseguradora es requerido")
    private Long afAseguradoraId;

    @NotBlank(message = "El número de póliza es requerido")
    @Size(max = 30, message = "El número de póliza no debe exceder 30 caracteres")
    private String numeroPoliza;

    @NotNull(message = "La fecha de inicio es requerida")
    private LocalDate fechaInicio;

    private LocalDate fechaFin;

    @DecimalMin(value = "0.00", message = "La prima debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "La prima debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal prima;

    @DecimalMin(value = "0.00", message = "La cobertura debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "La cobertura debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal cobertura;
}
