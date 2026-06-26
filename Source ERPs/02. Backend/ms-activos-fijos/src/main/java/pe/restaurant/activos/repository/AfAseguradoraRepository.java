package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfAseguradora;

import java.util.Optional;

public interface AfAseguradoraRepository extends JpaRepository<AfAseguradora, Long> {

    Optional<AfAseguradora> findByRucIgnoreCase(String ruc);

    boolean existsByRucIgnoreCase(String ruc);

    boolean existsByRucIgnoreCaseAndIdNot(String ruc, Long id);

    @Query("SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM AfAseguradora a WHERE LOWER(a.nombre) = LOWER(:nombre)")
    boolean existsByNombreIgnoreCase(@Param("nombre") String nombre);

    @Query("SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM AfAseguradora a WHERE LOWER(a.nombre) = LOWER(:nombre) AND a.id != :id")
    boolean existsByNombreIgnoreCaseAndIdNot(@Param("nombre") String nombre, @Param("id") Long id);
}
