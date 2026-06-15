package com.sigre.produccion.event.publisher;

import com.sigre.produccion.entity.OrdenTrabajo;

public interface ProduccionEventPublisher {

    void publicarCosteoCompletado(Integer anio, Integer mes, Long sucursalId, Long almacenId,
                                  int totalOts, int creadas, int actualizadas);

    void publicarOrdenCompletada(OrdenTrabajo ordenTrabajo);

    void publicarOrdenCancelada(OrdenTrabajo ordenTrabajo);
}
