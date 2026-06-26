package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.TipoTrabajador;
import java.util.List;
import java.util.Optional;

public interface TipoTrabajadorRepository extends JpaRepository<TipoTrabajador, Long>, JpaSpecificationExecutor<TipoTrabajador> {
    Optional<TipoTrabajador> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<TipoTrabajador> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
