package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.Seccion;
import java.util.List;
import java.util.Optional;

public interface SeccionRepository extends JpaRepository<Seccion, Long>, JpaSpecificationExecutor<Seccion> {
    Optional<Seccion> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<Seccion> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
