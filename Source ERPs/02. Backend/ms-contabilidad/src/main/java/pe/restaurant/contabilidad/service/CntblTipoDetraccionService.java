package pe.restaurant.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.contabilidad.dto.request.CntblTipoDetraccionRequest;
import pe.restaurant.contabilidad.entity.CntblTipoDetraccion;

public interface CntblTipoDetraccionService {

    Page<CntblTipoDetraccion> findAll(String q, String flagEstado, Pageable pageable);

    CntblTipoDetraccion findById(Long id);

    CntblTipoDetraccion create(CntblTipoDetraccionRequest request);

    CntblTipoDetraccion update(Long id, CntblTipoDetraccionRequest request);

    void delete(Long id);
}
