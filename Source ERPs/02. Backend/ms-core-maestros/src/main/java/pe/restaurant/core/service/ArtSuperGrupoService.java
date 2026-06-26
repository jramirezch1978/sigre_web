package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.ArtSuperGrupo;

public interface ArtSuperGrupoService {
    Page<ArtSuperGrupo> findAll(Pageable pageable);
    ArtSuperGrupo findById(Long id);
    ArtSuperGrupo create(ArtSuperGrupo entity);
    ArtSuperGrupo update(Long id, ArtSuperGrupo entity);
    void delete(Long id);
    ArtSuperGrupo activate(Long id);
    ArtSuperGrupo deactivate(Long id);
}
