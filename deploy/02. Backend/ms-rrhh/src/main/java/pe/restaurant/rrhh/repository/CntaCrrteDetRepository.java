package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.rrhh.entity.CntaCrrteDet;
import java.util.List;

public interface CntaCrrteDetRepository extends JpaRepository<CntaCrrteDet, Long> {
    List<CntaCrrteDet> findByCntaCrrteIdOrderByFechaMovimientoDesc(Long cntaCrrteId);
}
