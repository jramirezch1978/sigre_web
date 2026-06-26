package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfPolizaActivo;

import java.util.List;

public interface AfPolizaActivoService {
    Page<AfPolizaActivo> findAll(Pageable pageable);
    AfPolizaActivo findById(Long id);
    AfPolizaActivo create(AfPolizaActivo entity);
    AfPolizaActivo update(Long id, AfPolizaActivo entity);
    void delete(Long id);
    List<AfPolizaActivo> findByPoliza(Long polizaId);
    List<AfPolizaActivo> findByActivo(Long activoId);
}
