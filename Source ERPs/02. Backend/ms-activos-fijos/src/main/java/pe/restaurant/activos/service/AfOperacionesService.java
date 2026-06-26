package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfOperaciones;

import java.util.List;

public interface AfOperacionesService {
    Page<AfOperaciones> findAll(Pageable pageable);
    AfOperaciones findById(Long id);
    AfOperaciones create(AfOperaciones entity);
    AfOperaciones update(Long id, AfOperaciones entity);
    void delete(Long id);
    List<AfOperaciones> findByActivo(Long activoId);
    List<AfOperaciones> findProgramadas();
    AfOperaciones ejecutar(Long id);
}
