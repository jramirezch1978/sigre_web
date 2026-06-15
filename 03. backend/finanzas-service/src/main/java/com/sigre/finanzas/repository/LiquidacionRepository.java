package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.Liquidacion;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface LiquidacionRepository extends JpaRepository<Liquidacion, Long>, JpaSpecificationExecutor<Liquidacion> {

    Optional<Liquidacion> findByNroLiquidacion(String nroLiquidacion);

    List<Liquidacion> findBySolicitudGiroId(Long solicitudGiroId);

    @Query("SELECT COALESCE(SUM(l.importeNeto), 0) " +
           "FROM Liquidacion l " +
           "WHERE l.solicitudGiroId = :solicitudGiroId " +
           "AND l.flagEstado IN ('1', '2')")
    java.math.BigDecimal calcularMontoLiquidadoPorSolicitud(@Param("solicitudGiroId") Long solicitudGiroId);

    @Query("SELECT l FROM Liquidacion l WHERE l.flagEstado = :flagEstado")
    List<Liquidacion> findByFlagEstado(@Param("flagEstado") String flagEstado);

    @Query("SELECT COALESCE(MAX(CAST(SUBSTRING(l.nroLiquidacion, 9) AS int)), 0) " +
           "FROM Liquidacion l " +
           "WHERE l.fechaRegistro = :fecha")
    Integer findMaxSecuenciaPorFecha(@Param("fecha") LocalDate fecha);

    /**
     * Encuentra liquidaciones con saldo negativo (pendientes por pagar).
     * Aplica filtros opcionales por sucursal, proveedor y rango de fechas.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de liquidaciones con saldo negativo
     */
    @Query(value = "SELECT l.* FROM finanzas.liquidacion l " +
           "WHERE l.saldo < 0 " +
           "AND l.flag_estado = '1' " +
           "AND (CAST(:sucursalId AS BIGINT) IS NULL OR l.sucursal_id = CAST(:sucursalId AS BIGINT)) " +
           "AND (CAST(:proveedorId AS BIGINT) IS NULL OR l.proveedor_id = CAST(:proveedorId AS BIGINT)) " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR l.fecha_registro >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR l.fecha_registro <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY l.fecha_registro DESC", nativeQuery = true)
    List<Liquidacion> findPendientesPorPagar(
            @Param("sucursalId") Long sucursalId,
            @Param("proveedorId") Long proveedorId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);

    /**
     * Encuentra liquidaciones con saldo positivo (pendientes por cobrar).
     * Aplica filtros opcionales por sucursal, proveedor y rango de fechas.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de liquidaciones con saldo positivo
     */
    @Query(value = "SELECT l.* FROM finanzas.liquidacion l " +
           "WHERE l.saldo > 0 " +
           "AND l.flag_estado = '1' " +
           "AND (CAST(:sucursalId AS BIGINT) IS NULL OR l.sucursal_id = CAST(:sucursalId AS BIGINT)) " +
           "AND (CAST(:proveedorId AS BIGINT) IS NULL OR l.proveedor_id = CAST(:proveedorId AS BIGINT)) " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR l.fecha_registro >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR l.fecha_registro <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY l.fecha_registro DESC", nativeQuery = true)
    List<Liquidacion> findPendientesPorCobrar(
            @Param("sucursalId") Long sucursalId,
            @Param("proveedorId") Long proveedorId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);
}
