package pe.restaurant.produccion.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LaborEjecutorRequest {

    @NotNull(message = "El ejecutor es requerido")
    private Long ejecutorId;

    private Long unidadMedidaAltId;

    private Long monedaId;

    private BigDecimal factorConversion;

    private Integer nroPersonas;

    private BigDecimal ratioEstimado;

    private BigDecimal costoUnitario;

    private String flagCostoFijo;
}
