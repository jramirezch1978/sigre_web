package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import pe.restaurant.rrhh.entity.TipoSancion;

public interface TipoSancionRepository extends JpaRepository<TipoSancion, Long>,
        JpaSpecificationExecutor<TipoSancion> {

    boolean existsByCodigo(String codigo);
    boolean existsByCodigoAndIdNot(String codigo, Long id);

    java.util.List<TipoSancion> findByFlagEstadoOrderByNombreAsc(String flagEstado);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END " +
           "FROM rrhh.sancion_amonestacion WHERE tipo_sancion_id = :id AND flag_estado = '1'", nativeQuery = true)
    boolean existsSancionesActivasByTipoSancionId(Long id);
}
