package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ZonaRepartoRequest;
import pe.restaurant.ventas.dto.response.ZonaRepartoResponse;
import pe.restaurant.ventas.entity.ZonaReparto;

public interface ZonaRepartoService {

    Page<ZonaReparto> findAll(Pageable pageable);

    // Método con filtros según contrato: zonaReparto, descZonaReparto, ubigeo, flagEstado
    Page<ZonaReparto> findAllWithFilters(String zonaReparto, String descZonaReparto, String ubigeo, String flagEstado, Pageable pageable);

    ZonaReparto findById(Long id);

    ZonaReparto create(ZonaReparto entity);

    ZonaReparto update(Long id, ZonaReparto entity);

    void delete(Long id);

    ZonaReparto activate(Long id);

    ZonaReparto deactivate(Long id);
}
