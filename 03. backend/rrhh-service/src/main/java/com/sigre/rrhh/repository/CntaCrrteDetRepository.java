package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.rrhh.entity.CntaCrrteDet;

import java.util.List;

public interface CntaCrrteDetRepository extends JpaRepository<CntaCrrteDet, Long> {
    List<CntaCrrteDet> findByCntaCrrteIdOrderByFechaMovimientoDesc(Long cntaCrrteId);

    @Query("SELECT COALESCE(MAX(d.nroDscto), 0) FROM CntaCrrteDet d WHERE d.cntaCrrteId = :cntaCrrteId")
    Short findMaxNroDsctoByCntaCrrteId(@Param("cntaCrrteId") Long cntaCrrteId);
}
