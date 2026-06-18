package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import pe.restaurant.rrhh.entity.TipoSuspensionLaboral;

public interface TipoSuspensionLaboralRepository extends JpaRepository<TipoSuspensionLaboral, Long>,
        JpaSpecificationExecutor<TipoSuspensionLaboral> {

    boolean existsByCodigo(String codigo);

    boolean existsByCodigoAndIdNot(String codigo, Long id);

    java.util.List<TipoSuspensionLaboral> findByFlagEstadoOrderByNombreAsc(String flagEstado);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END " +
           "FROM rrhh.permiso_licencia WHERE tipo_suspension_laboral_id = :id AND flag_estado = '1'", nativeQuery = true)
    boolean existsPermisosActivosByTipoSuspensionId(Long id);
}
