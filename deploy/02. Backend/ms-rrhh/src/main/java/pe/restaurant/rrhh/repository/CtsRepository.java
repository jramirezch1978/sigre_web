package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import pe.restaurant.rrhh.entity.Cts;
import java.math.BigDecimal;
import java.util.Optional;

public interface CtsRepository extends JpaRepository<Cts, Long>, JpaSpecificationExecutor<Cts> {

    /**
     * Busca un registro CTS existente por su clave natural.
     * 
     * @param trabajadorId ID del trabajador
     * @param anio Año del cálculo
     * @param periodoCtsId ID del período CTS
     * @return Optional con el CTS si existe
     */
    Optional<Cts> findByTrabajadorIdAndAnioAndPeriodoCtsId(Long trabajadorId, Integer anio, Long periodoCtsId);

    @Query(value = "SELECT COALESCE(remuneracion, 0) FROM rrhh.contrato " +
           "WHERE trabajador_id = :trabajadorId AND flag_estado = '1' " +
           "ORDER BY fecha_inicio DESC LIMIT 1", nativeQuery = true)
    BigDecimal findRemuneracionByTrabajadorId(Long trabajadorId);
}
