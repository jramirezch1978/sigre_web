package pe.restaurant.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.almacen.entity.UbicacionAlmacen;

import java.util.List;
import java.util.Optional;

public interface UbicacionAlmacenRepository extends JpaRepository<UbicacionAlmacen, Long> {

    List<UbicacionAlmacen> findByAlmacenId(Long almacenId);

    boolean existsByAlmacenIdAndCodigoIgnoreCase(Long almacenId, String codigo);

    boolean existsByAlmacenIdAndCodigoIgnoreCaseAndIdNot(Long almacenId, String codigo, Long id);

    Optional<UbicacionAlmacen> findByIdAndAlmacenId(Long id, Long almacenId);
}
