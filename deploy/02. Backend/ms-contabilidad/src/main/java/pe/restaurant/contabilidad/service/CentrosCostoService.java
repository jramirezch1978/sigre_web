package pe.restaurant.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.contabilidad.dto.request.CentrosCostoRequest;
import pe.restaurant.contabilidad.entity.CentrosCosto;

public interface CentrosCostoService {

    Page<CentrosCosto> findAll(String q, String flagEstado, Pageable pageable);

    CentrosCosto findById(Long id);

    CentrosCosto create(CentrosCostoRequest request);

    CentrosCosto update(Long id, CentrosCostoRequest request);

    void delete(Long id);
}
