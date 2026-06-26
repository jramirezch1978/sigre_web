package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ZonaVentaRequest;
import pe.restaurant.ventas.dto.response.ZonaVentaResponse;
import pe.restaurant.ventas.entity.ZonaVenta;

public interface ZonaVentaService {

    Page<ZonaVenta> findAll(Pageable pageable);

    // Método con filtros según contrato: zonaVenta, descZonaVenta, ubigeo, flagEstado
    Page<ZonaVenta> findAllWithFilters(String zonaVenta, String descZonaVenta, String ubigeo, String flagEstado, Pageable pageable);

    ZonaVenta findById(Long id);

    ZonaVenta create(ZonaVenta entity);

    ZonaVenta update(Long id, ZonaVenta entity);

    void delete(Long id);

    ZonaVenta activate(Long id);

    ZonaVenta deactivate(Long id);
}
