package pe.restaurant.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.MatrizContableDet;

import java.util.List;
import java.util.Optional;

@Repository
public interface MatrizContableDetRepository extends JpaRepository<MatrizContableDet, Long> {

    List<MatrizContableDet> findByMatrizContableIdOrderBySecuenciaAsc(Long matrizContableId);

    Optional<MatrizContableDet> findByMatrizContableIdAndSecuencia(Long matrizContableId, Integer secuencia);

    Optional<MatrizContableDet> findByIdAndMatrizContableId(Long id, Long matrizContableId);

    Optional<MatrizContableDet> findTopByMatrizContableIdOrderBySecuenciaDesc(Long matrizContableId);
}
