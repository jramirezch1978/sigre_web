package com.sigre.comercializacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.comercializacion.entity.CntasCobrarDetImp;

import java.util.List;

public interface CntasCobrarDetImpRepository extends JpaRepository<CntasCobrarDetImp, Long> {

    List<CntasCobrarDetImp> findByCntasCobrarDetId(Long cntasCobrarDetId);

    List<CntasCobrarDetImp> findByCntasCobrarDetIdIn(List<Long> cntasCobrarDetIds);
}
