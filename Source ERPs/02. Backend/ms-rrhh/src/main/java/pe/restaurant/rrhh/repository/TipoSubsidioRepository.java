package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.TipoSubsidio;

@Repository
public interface TipoSubsidioRepository extends JpaRepository<TipoSubsidio, Long>, JpaSpecificationExecutor<TipoSubsidio> {
    boolean existsByCodigo(String codigo);
    java.util.List<TipoSubsidio> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
