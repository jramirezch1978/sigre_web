package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.DescuentoPromocionRequest;
import pe.restaurant.ventas.entity.DescuentoPromocion;

public interface DescuentoPromocionService {

    Page<DescuentoPromocion> findAll(String nombre, String tipo, String flagEstado, Pageable pageable);

    DescuentoPromocion findById(Long id);

    DescuentoPromocion create(DescuentoPromocionRequest request);

    DescuentoPromocion update(Long id, DescuentoPromocionRequest request);

    void delete(Long id);

    DescuentoPromocion activar(Long id);

    DescuentoPromocion desactivar(Long id);
}
