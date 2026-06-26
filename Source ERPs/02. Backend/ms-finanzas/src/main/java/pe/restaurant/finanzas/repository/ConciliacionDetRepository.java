package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.ConciliacionDet;

import java.util.List;

@Repository
public interface ConciliacionDetRepository extends JpaRepository<ConciliacionDet, Long> {

    List<ConciliacionDet> findByConciliacionIdAndIdIn(Long conciliacionId, List<Long> ids);
}
