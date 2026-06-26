package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.PeriodoGratificacion;

public interface PeriodoGratificacionRepository extends JpaRepository<PeriodoGratificacion, Long>, JpaSpecificationExecutor<PeriodoGratificacion> {
    boolean existsByCodigo(String codigo);
    java.util.List<PeriodoGratificacion> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
