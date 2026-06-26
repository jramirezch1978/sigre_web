package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.CalculoDet;

import java.util.List;

/**
 * Repositorio JPA para la entidad {@link CalculoDet}.
 * Gestiona las líneas de detalle de cada cálculo de planilla.
 */
@Repository
public interface CalculoDetRepository extends JpaRepository<CalculoDet, Long> {

    /** Lista todos los detalles de un cálculo ordenados por trabajador. */
    List<CalculoDet> findByCalculoIdOrderByConceptoIdAscItemAsc(Long calculoId);

    /** Elimina todos los detalles asociados a un cálculo. */
    void deleteByCalculoId(Long calculoId);
}
