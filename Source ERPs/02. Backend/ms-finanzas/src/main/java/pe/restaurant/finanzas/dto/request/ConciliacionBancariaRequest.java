package pe.restaurant.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConciliacionBancariaRequest {

    @NotNull(message = "El ID de la cuenta bancaria es obligatorio")
    private Long bancoCntaId;

    @NotNull(message = "El año del periodo es obligatorio")
    private Integer periodoAnio;

    @NotNull(message = "El mes del periodo es obligatorio")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer periodoMes;

    @NotNull(message = "El saldo banco es obligatorio")
    private BigDecimal saldoBanco;

    @NotNull(message = "El saldo libros es obligatorio")
    private BigDecimal saldoLibros;

    @NotNull(message = "Los detalles son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un detalle")
    @Valid
    private List<ConciliacionDetRequest> detalles;
}
