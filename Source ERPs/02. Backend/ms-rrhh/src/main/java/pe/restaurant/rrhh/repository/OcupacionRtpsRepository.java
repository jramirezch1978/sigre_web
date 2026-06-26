package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.OcupacionRtps;
import java.util.List;
import java.util.Optional;

public interface OcupacionRtpsRepository extends JpaRepository<OcupacionRtps, Long>, JpaSpecificationExecutor<OcupacionRtps> {
    Optional<OcupacionRtps> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<OcupacionRtps> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
