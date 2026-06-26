package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.DespachoOvRequest;
import pe.restaurant.ventas.dto.request.OrdenVentaRequest;
import pe.restaurant.ventas.dto.response.DespachoOvResponse;
import pe.restaurant.ventas.entity.OrdenVenta;

public interface OrdenVentaService {

    Page<OrdenVenta> findAll(Long sucursalId, Long clienteId, String nro, Pageable pageable);

    OrdenVenta findById(Long id);

    OrdenVenta create(OrdenVentaRequest request);

    OrdenVenta update(Long id, OrdenVentaRequest request);

    OrdenVenta confirmar(Long id);

    OrdenVenta anular(Long id);

    OrdenVenta cerrar(Long id);

    DespachoOvResponse despacharEnAlmacen(Long id, DespachoOvRequest request);
}
