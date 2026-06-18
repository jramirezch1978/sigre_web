package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfSubClase;

import java.util.Optional;

public interface AfSubClaseRepository extends JpaRepository<AfSubClase, Long> {

    Optional<AfSubClase> findByAfClaseIdAndCodigoIgnoreCase(Long afClaseId, String codigo);

    boolean existsByAfClaseIdAndCodigoIgnoreCase(Long afClaseId, String codigo);

    boolean existsByAfClaseIdAndCodigoIgnoreCaseAndIdNot(Long afClaseId, String codigo, Long id);

    @Query("SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM AfSubClase a WHERE a.afClase.id = :afClaseId")
    boolean existsByAfClaseId(@Param("afClaseId") Long afClaseId);
}
