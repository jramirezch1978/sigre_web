package com.sigre.almacen.service;

import com.sigre.almacen.dto.ProcesoCosteoAlmacenResponse;
import com.sigre.almacen.event.CosteoPeriodoProcesadoEvent;

public interface ProduccionCosteoAlmacenService {

    /**
     * Aplica el costo unitario del costeo mensual a ingresos por producción (vales tipo P confirmados)
     * y al costo promedio en {@code articulo_almacen}.
     */
    ProcesoCosteoAlmacenResponse aplicarCosteoEnAlmacen(CosteoPeriodoProcesadoEvent evento);
}
