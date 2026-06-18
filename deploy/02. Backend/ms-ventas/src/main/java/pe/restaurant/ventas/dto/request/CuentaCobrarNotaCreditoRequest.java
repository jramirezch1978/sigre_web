package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Emisión de nota de crédito por cobrar (doc_tipo NCC) contra una CxC origen.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CuentaCobrarNotaCreditoRequest {

    @NotNull
    private Long cuentaCobrarOrigenId;

    @NotBlank
    private String serie;

    @NotBlank
    private String numero;

    @NotNull
    private LocalDate fechaEmision;

    @NotNull
    @DecimalMin(value = "0.0001")
    private BigDecimal monto;

    @NotBlank
    private String motivo;

    /** Concepto financiero del cargo NC; obligatorio en catálogo tenant. */
    @NotNull
    private Long conceptoFinancieroId;
}
