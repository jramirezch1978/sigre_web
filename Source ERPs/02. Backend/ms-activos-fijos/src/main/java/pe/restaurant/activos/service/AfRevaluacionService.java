package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfRevaluacion;

import java.util.List;

public interface AfRevaluacionService {

    Page<AfRevaluacion> findAll(Pageable pageable);

    AfRevaluacion findById(Long id);

    List<AfRevaluacion> findByMaestro(Long afMaestroId);

    AfRevaluacion create(AfRevaluacion entity);

    AfRevaluacion update(Long id, AfRevaluacion entity);

    void delete(Long id);
}
