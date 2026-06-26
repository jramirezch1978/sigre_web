package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.PeriodoCts;

public interface PeriodoCtsRepository extends JpaRepository<PeriodoCts, Long>, JpaSpecificationExecutor<PeriodoCts> {
    boolean existsByCodigo(String codigo);
    java.util.List<PeriodoCts> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
