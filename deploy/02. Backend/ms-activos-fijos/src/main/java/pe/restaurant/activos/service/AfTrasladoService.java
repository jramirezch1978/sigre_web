package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfTraslado;

import java.util.List;

public interface AfTrasladoService {
    Page<AfTraslado> findAll(Pageable pageable);
    AfTraslado findById(Long id);
    AfTraslado create(AfTraslado entity);
    AfTraslado update(Long id, AfTraslado entity);
    void delete(Long id);
    List<AfTraslado> findByActivo(Long activoId);
    AfTraslado aprobar(Long id);
    AfTraslado rechazar(Long id);
    AfTraslado rechazar(Long id, String comentario);
    AfTraslado ejecutar(Long id);
    AfTraslado anular(Long id);
}
