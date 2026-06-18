package pe.restaurant.almacen.service;

import pe.restaurant.almacen.dto.*;

public interface IntegracionAlmacenService {

    MovimientoDetalleResponse recepcionarOrdenCompra(IntegracionRecepcionOcRequest request);

    MovimientoDetalleResponse despacharOrdenVenta(IntegracionSalidaOvRequest request);

    IntegracionTrasladoResultadoResponse ejecutarTraslado(IntegracionTrasladoEjecutarRequest request);
}
