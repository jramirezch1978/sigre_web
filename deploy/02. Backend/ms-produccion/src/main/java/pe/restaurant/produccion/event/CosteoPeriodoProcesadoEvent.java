package pe.restaurant.produccion.event;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import pe.restaurant.common.event.BaseEvent;

@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class CosteoPeriodoProcesadoEvent extends BaseEvent {

    private Integer anio;
    private Integer mes;
    /** Sucursal del filtro del batch; null si se costeó todas las sucursales del tenant. */
    private Long sucursalFiltroId;
    /** Almacén del filtro del batch; null si se aplicó a todos los almacenes del período. */
    private Long almacenFiltroId;
    private int totalOtsProcesadas;
    private int totalCreadas;
    private int totalActualizadas;
}
