package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CuentaBancariaRequest {
    @Size(max = 3)
    private String codBanco;

    @NotBlank
    @Size(max = 30)
    private String numeroCuenta;

    @Size(max = 30)
    private String cci;

    @NotNull
    private Long monedaId;

    @Size(max = 30)
    private String tipoCuenta;
}
