package pe.restaurant.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.contabilidad.dto.request.CntblLibroRequest;
import pe.restaurant.contabilidad.entity.CntblLibro;

public interface CntblLibroService {

    Page<CntblLibro> findAll(String q, String flagEstado, Pageable pageable);

    CntblLibro findById(Long id);

    CntblLibro findByCodigo(String codigo);

    CntblLibro create(CntblLibroRequest request);

    CntblLibro update(Long id, CntblLibroRequest request);

    void delete(Long id);
}
