package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfMatrizSubClase;

import java.util.Optional;

public interface AfMatrizSubClaseService {

    Page<AfMatrizSubClase> findAll(Pageable pageable);

    AfMatrizSubClase findById(Long id);

    Optional<AfMatrizSubClase> findBySubClaseId(Long afSubClaseId);

    AfMatrizSubClase create(AfMatrizSubClase entity);

    AfMatrizSubClase update(Long id, AfMatrizSubClase entity);

    void delete(Long id);
}
