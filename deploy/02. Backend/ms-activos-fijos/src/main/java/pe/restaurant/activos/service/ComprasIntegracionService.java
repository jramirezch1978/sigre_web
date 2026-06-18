package pe.restaurant.activos.service;

import pe.restaurant.activos.dto.AfMaestroDesdeCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeFacturaCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeRecepcionRequest;
import pe.restaurant.activos.entity.AfMaestro;

public interface ComprasIntegracionService {

    AfMaestro crearMaestroDesdeOrdenCompra(AfMaestroDesdeCompraRequest request);

    AfMaestro crearMaestroDesdeRecepcion(AfMaestroDesdeRecepcionRequest request);

    AfMaestro crearMaestroDesdeFacturaCompra(AfMaestroDesdeFacturaCompraRequest request);
}
