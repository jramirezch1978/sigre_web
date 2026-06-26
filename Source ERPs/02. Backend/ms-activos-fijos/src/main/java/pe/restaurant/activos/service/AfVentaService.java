package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfVenta;

import java.util.List;

public interface AfVentaService {
    Page<AfVenta> findAll(Pageable pageable);
    AfVenta findById(Long id);
    AfVenta create(AfVenta entity);
    AfVenta update(Long id, AfVenta entity);
    void delete(Long id);
    List<AfVenta> findByActivo(Long activoId);
    List<AfVenta> findByAnio(Integer anio);
}
