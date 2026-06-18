package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.TipoPlanilla;

@Repository
public interface TipoPlanillaRepository extends JpaRepository<TipoPlanilla, Long>, JpaSpecificationExecutor<TipoPlanilla> {
    boolean existsByCodigo(String codigo);
    java.util.List<TipoPlanilla> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
