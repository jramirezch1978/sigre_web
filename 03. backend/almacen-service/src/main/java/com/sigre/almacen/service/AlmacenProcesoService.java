package com.sigre.almacen.service;

import com.sigre.almacen.dto.ProcesoAlmacenFiltroRequest;
import com.sigre.almacen.dto.ProcesoAlmacenResponse;

public interface AlmacenProcesoService {

    /** Menú: ALMACEN_PROC_RECALCULO */
    ProcesoAlmacenResponse recalcularPreciosPromedio(ProcesoAlmacenFiltroRequest filtro);

    /** Menú: ALMACEN_PROC_CUADRE_STOCK */
    ProcesoAlmacenResponse cuadrarStockVsPosiciones(ProcesoAlmacenFiltroRequest filtro);

    /** Menú: ALMACEN_PROC_ACT_AUTO — ejecuta cuadre + recálculo de costo desde kardex. */
    ProcesoAlmacenResponse actualizacionAutomatica(ProcesoAlmacenFiltroRequest filtro);
}
