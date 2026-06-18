package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.rrhh.entity.PermisoLicencia;
import java.time.LocalDate;
import java.util.List;

public interface PermisoLicenciaRepository extends JpaRepository<PermisoLicencia, Long>,
        JpaSpecificationExecutor<PermisoLicencia> {

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.permiso_licencia " +
           "WHERE trabajador_id = :trabajadorId AND flag_estado = '1' " +
           "AND :fechaInicio <= COALESCE(fecha_fin, :fechaInicio) " +
           "AND :fechaFin >= fecha_inicio " +
           "AND (:excluirId IS NULL OR id != :excluirId)", nativeQuery = true)
    boolean existsSolapamiento(@Param("trabajadorId") Long trabajadorId,
                               @Param("fechaInicio") LocalDate fechaInicio,
                               @Param("fechaFin") LocalDate fechaFin,
                               @Param("excluirId") Long excluirId);

    List<PermisoLicencia> findByFlagEstado(String flagEstado);

    List<PermisoLicencia> findByFlagEstadoIn(List<String> estados);
}
