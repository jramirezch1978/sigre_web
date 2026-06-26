package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.produccion.entity.LaborEjecutor;

import java.util.List;
import java.util.Optional;

public interface LaborEjecutorRepository extends JpaRepository<LaborEjecutor, Long> {

    List<LaborEjecutor> findByLaborIdOrderByIdAsc(Long laborId);

    Optional<LaborEjecutor> findByLaborIdAndEjecutorId(Long laborId, Long ejecutorId);

    boolean existsByLaborIdAndEjecutorId(Long laborId, Long ejecutorId);
}
