package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.finanzas.entity.CntasPagarDetImp;

import java.util.List;

public interface CntasPagarDetImpRepository extends JpaRepository<CntasPagarDetImp, Long> {

    List<CntasPagarDetImp> findByCntasPagarDetId(Long cntasPagarDetId);

    List<CntasPagarDetImp> findByCntasPagarDetIdIn(List<Long> cntasPagarDetIds);

    @Modifying
    @Query(value = """
        DELETE FROM finanzas.cntas_pagar_det_imp dpi
         WHERE dpi.cntas_pagar_det_id IN (
               SELECT dpd.id FROM finanzas.cntas_pagar_det dpd
              WHERE dpd.cntas_pagar_id = :cxpId
        )
    """, nativeQuery = true)
    void deleteByCntasPagarId(@Param("cxpId") Long cxpId);
}
