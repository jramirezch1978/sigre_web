package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.GrupoTipoDoc;

public interface GrupoTipoDocService {
    Page<GrupoTipoDoc> findAll(Pageable pageable);
    GrupoTipoDoc findById(Long id);
    GrupoTipoDoc create(GrupoTipoDoc entity);
    GrupoTipoDoc update(Long id, GrupoTipoDoc entity);
    void delete(Long id);
    GrupoTipoDoc activate(Long id);
    GrupoTipoDoc deactivate(Long id);
}
