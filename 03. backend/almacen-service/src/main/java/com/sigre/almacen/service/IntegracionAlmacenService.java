package com.sigre.almacen.service;

import com.sigre.almacen.dto.*;

public interface IntegracionAlmacenService {

    MovimientoDetalleResponse recepcionarOrdenCompra(IntegracionRecepcionOcRequest request);

    MovimientoDetalleResponse despacharOrdenVenta(IntegracionSalidaOvRequest request);

    IntegracionTrasladoResultadoResponse ejecutarTraslado(IntegracionTrasladoEjecutarRequest request);
}
