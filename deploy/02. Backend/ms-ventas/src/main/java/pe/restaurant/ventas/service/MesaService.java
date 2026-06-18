package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.MesaRequest;
import pe.restaurant.ventas.dto.response.MesaResponse;
import pe.restaurant.ventas.entity.Mesa;

import java.util.List;

public interface MesaService {

    Page<Mesa> findAll(Pageable pageable);

    Page<Mesa> findAllWithFilters(Long zonaId, String numero, String flagEstado, Pageable pageable);

    Mesa findById(Long id);

    Mesa create(Mesa entity);

    Mesa update(Long id, Mesa entity);

    void delete(Long id);

    Mesa activate(Long id);

    Mesa deactivate(Long id);

    List<Mesa> findByZonaId(Long zonaId);

    List<Mesa> findBySucursalId(Long sucursalId);
}
