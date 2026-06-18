package pe.restaurant.ventas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.ventas.entity.CntasCobrarDetImp;

import java.util.List;

public interface CntasCobrarDetImpRepository extends JpaRepository<CntasCobrarDetImp, Long> {

    List<CntasCobrarDetImp> findByCntasCobrarDetId(Long cntasCobrarDetId);

    List<CntasCobrarDetImp> findByCntasCobrarDetIdIn(List<Long> cntasCobrarDetIds);
}
