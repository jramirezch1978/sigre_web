package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.EvaluacionDesempeno;
import java.util.List;

@Repository
public interface EvaluacionDesempenoRepository extends JpaRepository<EvaluacionDesempeno, Long> {
    List<EvaluacionDesempeno> findByTrabajadorId(Long trabajadorId);
    List<EvaluacionDesempeno> findByPeriodoAnio(Integer periodoAnio);
    List<EvaluacionDesempeno> findByTrabajadorIdAndPeriodoAnio(Long trabajadorId, Integer periodoAnio);
}
