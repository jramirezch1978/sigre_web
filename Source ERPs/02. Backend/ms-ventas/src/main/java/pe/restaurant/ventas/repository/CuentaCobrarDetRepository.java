package pe.restaurant.ventas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.CuentaCobrarDet;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Repository para Detalles de Cuentas por Cobrar (Movimientos)
 */
@Repository
public interface CuentaCobrarDetRepository extends JpaRepository<CuentaCobrarDet, Long> {

    /**
     * Listar movimientos de una cuenta por cobrar
     */
    List<CuentaCobrarDet> findByCuentaCobrarIdAndFlagEstadoOrderByFechaMovDesc(
            Long cuentaCobrarId, String flagEstado);

    @Query("SELECT cd FROM CuentaCobrarDet cd JOIN FETCH cd.cuentaCobrar " +
           "WHERE cd.cntasCobrarId = :cuentaCobrarId AND cd.flagEstado = :flagEstado " +
           "ORDER BY cd.fechaMov DESC")
    List<CuentaCobrarDet> findWithCuentaCobrarByCuentaCobrarIdAndFlagEstadoOrderByFechaMovDesc(
            @Param("cuentaCobrarId") Long cuentaCobrarId,
            @Param("flagEstado") String flagEstado);

    /**
     * Calcular total de cargos de una cuenta
     */
    @Query("SELECT COALESCE(SUM(cd.monto), 0) FROM CuentaCobrarDet cd " +
           "WHERE cd.cuentaCobrar.id = :cuentaCobrarId " +
           "AND cd.tipoMov = 'CARGO' " +
           "AND cd.flagEstado = '1'")
    BigDecimal sumCargosByCuentaCobrarId(@Param("cuentaCobrarId") Long cuentaCobrarId);

    /**
     * Calcular total de abonos de una cuenta
     */
    @Query("SELECT COALESCE(SUM(cd.monto), 0) FROM CuentaCobrarDet cd " +
           "WHERE cd.cuentaCobrar.id = :cuentaCobrarId " +
           "AND cd.tipoMov = 'ABONO' " +
           "AND cd.flagEstado = '1'")
    BigDecimal sumAbonosByCuentaCobrarId(@Param("cuentaCobrarId") Long cuentaCobrarId);

    /**
     * Calcular total de ajustes de una cuenta
     */
    @Query("SELECT COALESCE(SUM(cd.monto), 0) FROM CuentaCobrarDet cd " +
           "WHERE cd.cuentaCobrar.id = :cuentaCobrarId " +
           "AND cd.tipoMov = 'AJUSTE' " +
           "AND cd.flagEstado = '1'")
    BigDecimal sumAjustesByCuentaCobrarId(@Param("cuentaCobrarId") Long cuentaCobrarId);

    /**
     * Validar movimiento por ID y cuenta
     */
    boolean existsByIdAndCuentaCobrarIdAndFlagEstado(
            Long id, Long cuentaCobrarId, String flagEstado);

    /**
     * Eliminar movimientos lógicamente (baja lógica)
     */
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("UPDATE CuentaCobrarDet cd SET cd.flagEstado = '0', cd.updatedBy = :updatedBy, cd.fecModificacion = CURRENT_TIMESTAMP " +
           "WHERE cd.cuentaCobrar.id = :cuentaCobrarId AND cd.flagEstado = '1'")
    int deleteMovimientosByCuentaCobrarId(
            @Param("cuentaCobrarId") Long cuentaCobrarId,
            @Param("updatedBy") Long updatedBy);

    /**
     * Obtener resumen de movimientos por período
     */
    @Query("SELECT cd.tipoMov, COUNT(cd), SUM(cd.monto) FROM CuentaCobrarDet cd " +
           "WHERE cd.cuentaCobrar.id = :cuentaCobrarId " +
           "AND (:fechaDesde IS NULL OR cd.fechaMov >= :fechaDesde) " +
           "AND (:fechaHasta IS NULL OR cd.fechaMov <= :fechaHasta) " +
           "AND cd.flagEstado = '1' " +
           "GROUP BY cd.tipoMov " +
           "ORDER BY cd.tipoMov")
    List<Object[]> getResumenMovimientosByPeriodo(
            @Param("cuentaCobrarId") Long cuentaCobrarId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);

    /**
     * Validar que no exista movimiento duplicado
     */
    @Query("SELECT CASE WHEN COUNT(cd) > 0 THEN true ELSE false END FROM CuentaCobrarDet cd " +
           "WHERE cd.cuentaCobrar.id = :cuentaCobrarId " +
           "AND cd.fechaMov = :fechaMov " +
           "AND cd.tipoMov = :tipoMov " +
           "AND cd.monto = :monto " +
           "AND cd.flagEstado = '1'")
    boolean existsMovimientoDuplicado(
            @Param("cuentaCobrarId") Long cuentaCobrarId,
            @Param("fechaMov") LocalDate fechaMov,
            @Param("tipoMov") CuentaCobrarDet.TipoMovimiento tipoMov,
            @Param("monto") BigDecimal monto);
}
