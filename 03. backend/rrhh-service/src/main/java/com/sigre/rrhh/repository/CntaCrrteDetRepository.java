package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.rrhh.entity.CntaCrrteDet;
import java.util.List;

public interface CntaCrrteDetRepository extends JpaRepository<CntaCrrteDet, Long> {
    List<CntaCrrteDet> findByCntaCrrteIdOrderByFechaMovimientoDesc(Long cntaCrrteId);
}
