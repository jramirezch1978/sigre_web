package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.TipoMovAsistencia;

@Repository
public interface TipoMovAsistenciaRepository extends JpaRepository<TipoMovAsistencia, Long>, JpaSpecificationExecutor<TipoMovAsistencia> {
    boolean existsByCodigo(String codigo);
    java.util.List<TipoMovAsistencia> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
