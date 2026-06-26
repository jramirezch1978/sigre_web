package pe.restaurant.almacen.service;

import pe.restaurant.almacen.dto.ProcesoAlmacenFiltroRequest;
import pe.restaurant.almacen.dto.ProcesoAlmacenResponse;

public interface AlmacenProcesoService {

    /** Menú: ALMACEN_PROC_RECALCULO */
    ProcesoAlmacenResponse recalcularPreciosPromedio(ProcesoAlmacenFiltroRequest filtro);

    /** Menú: ALMACEN_PROC_CUADRE_STOCK */
    ProcesoAlmacenResponse cuadrarStockVsPosiciones(ProcesoAlmacenFiltroRequest filtro);

    /** Menú: ALMACEN_PROC_ACT_AUTO — ejecuta cuadre + recálculo de costo desde kardex. */
    ProcesoAlmacenResponse actualizacionAutomatica(ProcesoAlmacenFiltroRequest filtro);
}
