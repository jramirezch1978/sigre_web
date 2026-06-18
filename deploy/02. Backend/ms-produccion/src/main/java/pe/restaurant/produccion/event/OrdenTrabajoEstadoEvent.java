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
public class OrdenTrabajoEstadoEvent extends BaseEvent {

    private Long ordenTrabajoId;
    private String ordenTrabajoCodigo;
    private String flagEstado;
}
