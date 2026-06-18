package pe.restaurant.finanzas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.CntasPagar;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface CntasPagarRepository extends JpaRepository<CntasPagar, Long>, JpaSpecificationExecutor<CntasPagar> {
    
    @Query("SELECT c FROM CntasPagar c LEFT JOIN FETCH c.detalles WHERE c.id = :id")
    Optional<CntasPagar> findByIdWithDetalles(@Param("id") Long id);
    
    @Query("SELECT DISTINCT c FROM CntasPagar c LEFT JOIN FETCH c.detalles")
    List<CntasPagar> findAllWithDetalles();
    
    Page<CntasPagar> findByProveedorId(Long proveedorId, Pageable pageable);
    
    Page<CntasPagar> findByFlagEstado(String flagEstado, Pageable pageable);
    
    Page<CntasPagar> findByFechaEmisionBetween(LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable);
    
    Page<CntasPagar> findByFechaVencimientoBetween(LocalDate fechaVencimientoDesde, LocalDate fechaVencimientoHasta, Pageable pageable);
    
    Optional<CntasPagar> findByProveedorIdAndDocTipoIdAndSerieAndNumero(
        Long proveedorId, Long docTipoId, String serie, String numero);
    
    boolean existsByProveedorIdAndDocTipoIdAndSerieAndNumero(
        Long proveedorId, Long docTipoId, String serie, String numero);
    
    @Query("SELECT DISTINCT cp FROM CntasPagar cp JOIN cp.detalles d WHERE d.referencia = :referencia")
    List<CntasPagar> findByDetalles_Referencia(@Param("referencia") String referencia);
    
    @Query("SELECT DISTINCT cp FROM CntasPagar cp " +
           "JOIN cp.detalles d " +
           "WHERE d.referencia = :referencia AND d.tipoMov = 'CANJE_ORIGEN'")
    List<CntasPagar> findOrigenesCanjeByReferencia(@Param("referencia") String referencia);
    
    @Query("SELECT DISTINCT cp FROM CntasPagar cp " +
           "JOIN cp.detalles d " +
           "WHERE d.referencia = :referencia AND d.tipoMov = 'CANJE_DESTINO'")
    List<CntasPagar> findDestinosCanjeByReferencia(@Param("referencia") String referencia);
    
    boolean existsByDetalles_Referencia(String referencia);
    
    // Métodos específicos para documentos directos
    @Query("SELECT c FROM CntasPagar c LEFT JOIN FETCH c.detalles d WHERE d.tipoMov = 'DIRECTO'")
    Page<CntasPagar> findDocumentosDirectos(Pageable pageable);
    
    @Query("SELECT c FROM CntasPagar c LEFT JOIN FETCH c.detalles d WHERE d.tipoMov = 'DIRECTO' AND c.id = :id")
    Optional<CntasPagar> findDocumentoDirectoById(@Param("id") Long id);
    
    // Métodos específicos para notas débito/crédito
    @Query("SELECT c FROM CntasPagar c LEFT JOIN FETCH c.detalles d WHERE d.tipoMov IN ('NOTA_DEBITO', 'NOTA_CREDITO')")
    Page<CntasPagar> findNotas(Pageable pageable);
    
    @Query("SELECT c FROM CntasPagar c LEFT JOIN FETCH c.detalles d WHERE d.tipoMov IN ('NOTA_DEBITO', 'NOTA_CREDITO') AND c.id = :id")
    Optional<CntasPagar> findNotaById(@Param("id") Long id);

    /**
     * Encuentra cuentas por pagar con saldo pendiente (saldo > 0).
     * Incluye tanto provisiones como documentos directos.
     * Aplica filtros opcionales por sucursal, proveedor y rango de fechas.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de cuentas por pagar con saldo pendiente
     */
    @Query(value = "SELECT DISTINCT c.* FROM finanzas.cntas_pagar c " +
           "LEFT JOIN finanzas.cntas_pagar_det d ON c.id = d.cntas_pagar_id " +
           "WHERE c.saldo > 0 " +
           "AND c.flag_estado = '1' " +
           "AND (CAST(:sucursalId AS BIGINT) IS NULL OR c.sucursal_id = CAST(:sucursalId AS BIGINT)) " +
           "AND (CAST(:proveedorId AS BIGINT) IS NULL OR c.proveedor_id = CAST(:proveedorId AS BIGINT)) " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR c.fecha_emision >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR c.fecha_emision <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY c.fecha_emision DESC", nativeQuery = true)
    List<CntasPagar> findPendientesPorPagar(
            @Param("sucursalId") Long sucursalId,
            @Param("proveedorId") Long proveedorId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);

    /**
     * Encuentra cuentas por pagar directas (sin documento vinculado) con saldo pendiente.
     * Identifica documentos directos mediante tipo_mov = 'DIRECTO' en los detalles.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de documentos directos con saldo pendiente
     */
    @Query(value = "SELECT DISTINCT c.* FROM finanzas.cntas_pagar c " +
           "JOIN finanzas.cntas_pagar_det d ON c.id = d.cntas_pagar_id " +
           "WHERE c.saldo > 0 " +
           "AND c.flag_estado = '1' " +
           "AND d.tipo_mov = 'DIRECTO' " +
           "AND (CAST(:sucursalId AS BIGINT) IS NULL OR c.sucursal_id = CAST(:sucursalId AS BIGINT)) " +
           "AND (CAST(:proveedorId AS BIGINT) IS NULL OR c.proveedor_id = CAST(:proveedorId AS BIGINT)) " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR c.fecha_emision >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR c.fecha_emision <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY c.fecha_emision DESC", nativeQuery = true)
    List<CntasPagar> findDocumentosDirectosPendientes(
            @Param("sucursalId") Long sucursalId,
            @Param("proveedorId") Long proveedorId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);
}
