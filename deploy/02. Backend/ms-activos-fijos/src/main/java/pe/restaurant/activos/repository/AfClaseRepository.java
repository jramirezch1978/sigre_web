package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfClase;

import java.util.Optional;

public interface AfClaseRepository extends JpaRepository<AfClase, Long> {
    Optional<AfClase> findByCodigo(String codigo);

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);

    @Query("SELECT CASE WHEN COUNT(s) > 0 THEN true ELSE false END FROM AfSubClase s WHERE s.afClaseId = :afClaseId")
    boolean existsSubClasesByAfClaseId(@Param("afClaseId") Long afClaseId);
}
