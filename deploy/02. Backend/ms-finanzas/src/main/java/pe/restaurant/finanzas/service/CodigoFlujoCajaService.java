package pe.restaurant.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.finanzas.entity.CodigoFlujoCaja;

public interface CodigoFlujoCajaService {

    Page<CodigoFlujoCaja> findAll(Pageable pageable);

    CodigoFlujoCaja findById(Long id);

    CodigoFlujoCaja create(CodigoFlujoCaja entity);

    CodigoFlujoCaja update(Long id, CodigoFlujoCaja entity);

    CodigoFlujoCaja activate(Long id);

    CodigoFlujoCaja deactivate(Long id);

    void delete(Long id);
}
