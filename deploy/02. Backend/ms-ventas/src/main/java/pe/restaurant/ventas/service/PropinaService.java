package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.PropinaRequest;
import pe.restaurant.ventas.entity.Propina;

public interface PropinaService {

    Page<Propina> findAll(Long fsFacturaSimplId, Long trabajadorId, java.time.LocalDate fechaDesde,
                         java.time.LocalDate fechaHasta, String flagEstado, Pageable pageable);

    Propina findById(Long id);

    Propina create(PropinaRequest request);

    Propina update(Long id, PropinaRequest request);

    Propina activar(Long id);

    Propina desactivar(Long id);
}
