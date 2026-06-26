package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.rrhh.entity.Inasistencia;

import java.time.LocalDate;

public interface InasistenciaRepository extends JpaRepository<Inasistencia, Long>,
        JpaSpecificationExecutor<Inasistencia> {

    boolean existsByTrabajadorIdAndFechaDesdeAndFlagEstadoNotAndIdNot(
            Long trabajadorId, LocalDate fechaDesde, String flagEstado, Long id);

    boolean existsByTrabajadorIdAndFechaDesdeAndFlagEstadoNot(
            Long trabajadorId, LocalDate fechaDesde, String flagEstado);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.trabajador WHERE id = :id",
            nativeQuery = true)
    boolean existsTrabajadorById(@Param("id") Long id);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END "
            + "FROM rrhh.trabajador WHERE id = :id AND flag_estado = '1' AND fecha_cese IS NULL",
            nativeQuery = true)
    boolean existsTrabajadorVigenteById(@Param("id") Long id);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.concepto_planilla WHERE id = :id",
            nativeQuery = true)
    boolean existsConceptoPlanillaById(@Param("id") Long id);

    @Query(value = "SELECT CONCAT(nombres, ' ', COALESCE(apellido_paterno, ''), ' ', COALESCE(apellido_materno, '')) "
            + "FROM rrhh.trabajador WHERE id = :id", nativeQuery = true)
    String findTrabajadorNombresById(@Param("id") Long id);

    @Query(value = "SELECT codigo FROM rrhh.concepto_planilla WHERE id = :id", nativeQuery = true)
    String findConceptoPlanillaCodigoById(@Param("id") Long id);

    @Query(value = "SELECT nombre FROM rrhh.concepto_planilla WHERE id = :id", nativeQuery = true)
    String findConceptoPlanillaNombreById(@Param("id") Long id);

    @Query(value = "SELECT username FROM auth.usuario WHERE id = :id", nativeQuery = true)
    String findUsuarioLoginById(@Param("id") Long id);
}
