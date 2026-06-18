package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CodigoFlujoCajaRequest {

    @NotBlank
    @Size(max = 20)
    private String codigo;

    @NotBlank
    @Size(max = 150)
    private String nombre;

    @NotBlank
    @Size(max = 20)
    private String tipo;

    // Relación al grupo (finanzas.grupo_codigo_flujo_caja). Opcional: la columna/FK es nullable.
    private Long grupoCodigoFlujoCajaId;

    @Size(max = 1)
    private String flagEstado;
}
