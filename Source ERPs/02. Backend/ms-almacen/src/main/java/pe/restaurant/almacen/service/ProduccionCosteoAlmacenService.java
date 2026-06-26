package pe.restaurant.almacen.service;

import pe.restaurant.almacen.dto.ProcesoCosteoAlmacenResponse;
import pe.restaurant.almacen.event.CosteoPeriodoProcesadoEvent;

public interface ProduccionCosteoAlmacenService {

    /**
     * Aplica el costo unitario del costeo mensual a ingresos por producción (vales tipo P confirmados)
     * y al costo promedio en {@code articulo_almacen}.
     */
    ProcesoCosteoAlmacenResponse aplicarCosteoEnAlmacen(CosteoPeriodoProcesadoEvent evento);
}
