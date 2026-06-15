package com.sigre.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.contabilidad.entity.GrupoMatrizCntbl;

@Repository
public interface GrupoMatrizCntblRepository extends JpaRepository<GrupoMatrizCntbl, Long> {
}
