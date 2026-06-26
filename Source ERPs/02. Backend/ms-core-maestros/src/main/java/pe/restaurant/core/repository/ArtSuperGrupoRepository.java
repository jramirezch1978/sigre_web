package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.ArtSuperGrupo;

import java.util.List;
import java.util.Optional;

public interface ArtSuperGrupoRepository extends JpaRepository<ArtSuperGrupo, Long> {

    Optional<ArtSuperGrupo> findByCodigo(String codigo);

    List<ArtSuperGrupo> findByFlagEstado(String flagEstado);
}
