package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import pe.restaurant.rrhh.entity.Capacitacion;

public interface CapacitacionRepository extends JpaRepository<Capacitacion, Long>,
        JpaSpecificationExecutor<Capacitacion> {

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END " +
           "FROM rrhh.capacitacion_trabajador WHERE capacitacion_id = :capacitacionId", nativeQuery = true)
    boolean existsParticipantesByCapacitacionId(Long capacitacionId);
}
