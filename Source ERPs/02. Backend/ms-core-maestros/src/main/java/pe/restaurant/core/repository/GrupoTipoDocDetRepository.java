package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.GrupoTipoDocDet;

import java.util.List;

public interface GrupoTipoDocDetRepository extends JpaRepository<GrupoTipoDocDet, Long> {

    List<GrupoTipoDocDet> findByGrupoTipoDocId(Long grupoTipoDocId);
}
