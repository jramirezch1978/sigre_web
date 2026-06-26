package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.GrupoTipoDocDet;

public interface GrupoTipoDocDetService {
    Page<GrupoTipoDocDet> findAll(Pageable pageable);
    GrupoTipoDocDet findById(Long id);
    GrupoTipoDocDet create(GrupoTipoDocDet entity);
    GrupoTipoDocDet update(Long id, GrupoTipoDocDet entity);
    void delete(Long id);
    GrupoTipoDocDet activate(Long id);
    GrupoTipoDocDet deactivate(Long id);
}
