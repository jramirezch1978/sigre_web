package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.CntasPagarDet;

import java.util.List;

@Repository
public interface CntasPagarDetRepository extends JpaRepository<CntasPagarDet, Long> {
    
    List<CntasPagarDet> findByCntasPagarIdOrderByFechaMovAsc(Long cntasPagarId);
    
    void deleteByCntasPagarId(Long cntasPagarId);
    
    List<CntasPagarDet> findByReferencia(String referencia);
    
    List<CntasPagarDet> findByReferenciaAndTipoMov(String referencia, String tipoMov);
    
    List<CntasPagarDet> findByTipoMov(String tipoMov);
}
