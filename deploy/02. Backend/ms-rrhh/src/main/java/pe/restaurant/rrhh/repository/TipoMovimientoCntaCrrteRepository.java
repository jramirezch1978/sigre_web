package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.TipoMovimientoCntaCrrte;

@Repository
public interface TipoMovimientoCntaCrrteRepository extends JpaRepository<TipoMovimientoCntaCrrte, Long>, JpaSpecificationExecutor<TipoMovimientoCntaCrrte> {
    boolean existsByCodigo(String codigo);
    java.util.List<TipoMovimientoCntaCrrte> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
