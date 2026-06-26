package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.LiquidacionDet;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface LiquidacionDetRepository extends JpaRepository<LiquidacionDet, Long> {

    List<LiquidacionDet> findByLiquidacionIdAndFlagEstado(Long liquidacionId, String flagEstado);

    @Query("SELECT SUM(ld.importe * ld.factorSigno) " +
           "FROM LiquidacionDet ld " +
           "WHERE ld.liquidacion.id = :liquidacionId AND ld.flagEstado = '1'")
    BigDecimal calcularSumaImportes(@Param("liquidacionId") Long liquidacionId);

    void deleteByLiquidacionId(Long liquidacionId);

    @Query("SELECT ld FROM LiquidacionDet ld " +
           "WHERE ld.liquidacion.id = :liquidacionId " +
           "AND ld.cntasPagarId IS NOT NULL " +
           "AND ld.flagEstado = '1'")
    List<LiquidacionDet> findByLiquidacionIdAndCntasPagarIdIsNotNull(@Param("liquidacionId") Long liquidacionId);
}
