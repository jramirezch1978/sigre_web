package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.CntasPagarDet;

import java.util.List;

@Repository
public interface CntasPagarDetRepository extends JpaRepository<CntasPagarDet, Long> {
    
    List<CntasPagarDet> findByCntasPagarIdOrderByFechaMovAsc(Long cntasPagarId);
    
    void deleteByCntasPagarId(Long cntasPagarId);
    
    List<CntasPagarDet> findByReferencia(String referencia);
    
    List<CntasPagarDet> findByReferenciaAndTipoMov(String referencia, String tipoMov);
    
    List<CntasPagarDet> findByTipoMov(String tipoMov);
}
