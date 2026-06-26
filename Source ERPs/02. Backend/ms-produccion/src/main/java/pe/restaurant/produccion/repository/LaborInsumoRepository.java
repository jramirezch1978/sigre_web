package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.produccion.entity.LaborInsumo;

import java.util.List;
import java.util.Optional;

public interface LaborInsumoRepository extends JpaRepository<LaborInsumo, Long> {

    List<LaborInsumo> findByLaborIdOrderByIdAsc(Long laborId);

    boolean existsByLaborIdAndArticuloId(Long laborId, Long articuloId);

    Optional<LaborInsumo> findByLaborIdAndArticuloId(Long laborId, Long articuloId);
}
