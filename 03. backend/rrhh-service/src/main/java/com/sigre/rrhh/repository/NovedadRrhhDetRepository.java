package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.rrhh.entity.NovedadRrhhDet;
import java.util.List;

public interface NovedadRrhhDetRepository extends JpaRepository<NovedadRrhhDet, Long> {
    List<NovedadRrhhDet> findByNovedadRrhhId(Long novedadRrhhId);
    void deleteByNovedadRrhhId(Long novedadRrhhId);
}
