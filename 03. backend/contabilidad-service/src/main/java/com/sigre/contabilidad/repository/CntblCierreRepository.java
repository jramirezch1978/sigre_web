package com.sigre.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.contabilidad.entity.CntblCierre;

import java.util.Optional;

public interface CntblCierreRepository extends JpaRepository<CntblCierre, CntblCierre.CntblCierreId> {

    Optional<CntblCierre> findByAnoAndMes(Integer ano, Integer mes);
}
