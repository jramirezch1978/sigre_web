package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TiposImpuestoRequest {

    @NotBlank
    @Size(max = 10)
    private String tipoImpuesto;

    private Long planContableDetId;

    @NotBlank
    @Size(max = 200)
    private String descImpuesto;

    @NotNull
    private BigDecimal tasaImpuesto;

    @Size(max = 1)
    private String signo = "+";

    @Size(max = 1)
    private String flagDhCxp = "D";

    @Size(max = 1)
    private String flagIgv = "0";

    /** 1=PORCENTAJE, 2=MONTO_FIJO, 3=BASE_AFFECTING. */
    @NotNull
    private Integer tipoCalculo = 1;
}
