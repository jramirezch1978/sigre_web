package com.sigre.almacen.event.publisher;

import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.entity.ValeMov;
import com.sigre.almacen.event.CosteoPeriodoProcesadoEvent;

/**
 * Publicación de pre-asientos de almacén hacia contabilidad (implementación futura en {@code contabilidad-service}).
 *
 * <p>Almacén es el único módulo que genera los asientos de inventario (ingreso/consumo). {@code ms-produccion}
 * solo costea y delega; nunca emite asientos.</p>
 */
public interface AlmacenPreAsientoPublisher {

    void publicarCosteoProduccion(CosteoPeriodoProcesadoEvent evento, int costeosEnPeriodo, int lineasValeActualizadas);

    /**
     * Emite el pre-asiento de un movimiento de inventario confirmado que contabiliza:
     * ingreso (clases {@code I}, {@code P}) o consumo (clase {@code C}).
     * Para otras clases o movimientos que no contabilizan no se publica nada.
     */
    void publicarMovimientoConfirmado(ValeMov mov, ArticuloMovTipo tipo);
}
