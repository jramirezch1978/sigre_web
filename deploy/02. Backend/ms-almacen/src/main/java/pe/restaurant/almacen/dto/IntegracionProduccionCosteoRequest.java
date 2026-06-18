package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Integración HTTP ms-produccion → ms-almacen tras costeo batch.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class IntegracionProduccionCosteoRequest {

    @NotNull
    @Min(2000)
    private Integer anio;

    @NotNull
    @Min(1)
    @Max(12)
    private Integer mes;

    /** Sucursal del filtro del batch; null si se costeó todo el tenant. */
    private Long sucursalFiltroId;

    /** Almacén del filtro del batch; null si se aplicó a todos los almacenes del período. */
    private Long almacenFiltroId;

    private int totalOtsProcesadas;
    private int totalCreadas;
    private int totalActualizadas;
}
