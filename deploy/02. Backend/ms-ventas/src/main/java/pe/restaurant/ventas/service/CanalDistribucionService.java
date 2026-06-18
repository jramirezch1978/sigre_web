package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.CanalDistribucionRequest;
import pe.restaurant.ventas.dto.response.CanalDistribucionResponse;
import pe.restaurant.ventas.entity.CanalDistribucion;

public interface CanalDistribucionService {

    Page<CanalDistribucion> findAll(Pageable pageable);

    // Método con filtros según contrato: codigo, nombre, flagEstado
    Page<CanalDistribucion> findAllWithFilters(String codigo, String nombre, String flagEstado, Pageable pageable);

    CanalDistribucion findById(Long id);

    CanalDistribucion create(CanalDistribucion entity);

    CanalDistribucion update(Long id, CanalDistribucion entity);

    void delete(Long id);

    CanalDistribucion activate(Long id);

    CanalDistribucion deactivate(Long id);
}
