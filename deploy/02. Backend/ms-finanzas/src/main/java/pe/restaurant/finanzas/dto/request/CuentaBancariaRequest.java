package pe.restaurant.finanzas.dto.request;

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
public class CuentaBancariaRequest {

    @NotBlank
    @Size(max = 30)
    private String codigo;

    @NotNull
    private Long planContableDetId;

    @NotNull
    private Long bancoId;

    @Size(max = 1)
    private String tipoCtaBco;

    @Size(max = 200)
    private String descripcion;

    private Integer correlativoCheque;

    private Long monedaId;

    @NotNull
    private BigDecimal saldoContable;

    @Size(max = 30)
    private String nroCci;

    @Size(max = 30)
    private String nroCuenta;

    // Sucursal asociada (finanzas.banco_cnta.sucursal_id). Opcional: la columna es nullable.
    private Long sucursalId;
}
