package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import pe.restaurant.rrhh.entity.Gratificacion;
import java.util.Optional;

public interface GratificacionRepository extends JpaRepository<Gratificacion, Long>,
        JpaSpecificationExecutor<Gratificacion> {

    /**
     * Busca una gratificación existente por su clave natural.
     * 
     * @param trabajadorId ID del trabajador
     * @param anio Año del cálculo
     * @param periodoGratificacionId ID del período de gratificación
     * @return Optional con la gratificación si existe
     */
    Optional<Gratificacion> findByTrabajadorIdAndAnioAndPeriodoGratificacionId(Long trabajadorId, Integer anio, Long periodoGratificacionId);

    @Query(value = "SELECT COALESCE(remuneracion, 0) FROM rrhh.contrato " +
           "WHERE trabajador_id = :trabajadorId AND flag_estado = '1' " +
           "ORDER BY fecha_inicio DESC LIMIT 1", nativeQuery = true)
    java.math.BigDecimal findRemuneracionByTrabajadorId(Long trabajadorId);
}
