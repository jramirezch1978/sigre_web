package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.Retencion;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface RetencionRepository extends JpaRepository<Retencion, Long>, JpaSpecificationExecutor<Retencion> {

    boolean existsByNroCertificadoAndFlagEstado(String nroCertificado, String flagEstado);

    /**
     * Encuentra retenciones pendientes (activas).
     * Aplica filtros opcionales por sucursal, proveedor y rango de fechas.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de retenciones pendientes
     */
    @Query(value = "SELECT r.* FROM finanzas.retencion r " +
           "WHERE r.flag_estado = '1' " +
           "AND (CAST(:sucursalId AS BIGINT) IS NULL OR r.sucursal_id = CAST(:sucursalId AS BIGINT)) " +
           "AND (CAST(:proveedorId AS BIGINT) IS NULL OR r.proveedor_id = CAST(:proveedorId AS BIGINT)) " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR r.fecha_emision >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR r.fecha_emision <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY r.fecha_emision DESC", nativeQuery = true)
    List<Retencion> findPendientes(
            @Param("sucursalId") Long sucursalId,
            @Param("proveedorId") Long proveedorId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);
}
