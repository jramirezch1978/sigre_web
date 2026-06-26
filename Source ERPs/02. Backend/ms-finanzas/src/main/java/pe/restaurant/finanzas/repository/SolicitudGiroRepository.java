package pe.restaurant.finanzas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.SolicitudGiro;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface SolicitudGiroRepository extends JpaRepository<SolicitudGiro, Long>, JpaSpecificationExecutor<SolicitudGiro> {

    Optional<SolicitudGiro> findByNumero(String numero);

    @Query("SELECT COALESCE(MAX(CAST(SUBSTRING(s.numero, 14) AS int)), 0) " +
           "FROM SolicitudGiro s " +
           "WHERE s.fecha = :fecha")
    Integer findMaxSecuenciaPorFecha(@Param("fecha") LocalDate fecha);

    List<SolicitudGiro> findByTipoSolicitudAndFlagEstado(String tipoSolicitud, String flagEstado);

    Page<SolicitudGiro> findByTipoSolicitudAndFlagEstado(String tipoSolicitud, String flagEstado, Pageable pageable);

    /**
     * Encuentra órdenes de giro pendientes por pagar (NO son devolución).
     * Incluye órdenes donde flag_estado_devolucion es NULL o diferente de 'A'.
     * Aplica filtros opcionales por sucursal, solicitante y rango de fechas.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param solicitanteId ID de solicitante (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de órdenes de giro pendientes por pagar
     */
    @Query(value = "SELECT s.* FROM finanzas.solicitud_giro s " +
           "WHERE s.flag_estado = '1' " +
           "AND (s.flag_estado_devolucion IS NULL OR s.flag_estado_devolucion != 'A') " +
           "AND (CAST(:sucursalId AS BIGINT) IS NULL OR s.sucursal_id = CAST(:sucursalId AS BIGINT)) " +
           "AND (CAST(:solicitanteId AS BIGINT) IS NULL OR s.solicitante_id = CAST(:solicitanteId AS BIGINT)) " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR s.fecha >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR s.fecha <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY s.fecha DESC", nativeQuery = true)
    List<SolicitudGiro> findPendientesPorPagar(
            @Param("sucursalId") Long sucursalId,
            @Param("solicitanteId") Long solicitanteId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);

    /**
     * Encuentra órdenes de giro pendientes por cobrar (marcadas como devolución aprobada).
     * Solo incluye órdenes donde flag_estado_devolucion = 'A' (aprobada).
     * Aplica filtros opcionales por sucursal, solicitante y rango de fechas.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param solicitanteId ID de solicitante (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de órdenes de giro pendientes por cobrar
     */
    @Query(value = "SELECT s.* FROM finanzas.solicitud_giro s " +
           "WHERE s.flag_estado = '1' " +
           "AND s.flag_estado_devolucion = 'A' " +
           "AND (CAST(:sucursalId AS BIGINT) IS NULL OR s.sucursal_id = CAST(:sucursalId AS BIGINT)) " +
           "AND (CAST(:solicitanteId AS BIGINT) IS NULL OR s.solicitante_id = CAST(:solicitanteId AS BIGINT)) " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR s.fecha >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR s.fecha <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY s.fecha DESC", nativeQuery = true)
    List<SolicitudGiro> findPendientesPorCobrar(
            @Param("sucursalId") Long sucursalId,
            @Param("solicitanteId") Long solicitanteId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);
}
