package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.activos.entity.AfPrimaDevengo;

import java.util.List;

public interface AfPrimaDevengoRepository extends JpaRepository<AfPrimaDevengo, Long> {

    boolean existsByAfPolizaSeguroIdAndAnioAndMes(Long afPolizaSeguroId, Integer anio, Integer mes);

    List<AfPrimaDevengo> findByAfPolizaSeguroIdOrderByAnioDescMesDesc(Long afPolizaSeguroId);
}
