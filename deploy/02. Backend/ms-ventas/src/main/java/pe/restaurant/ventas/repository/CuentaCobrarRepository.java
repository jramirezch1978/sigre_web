package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import jakarta.persistence.QueryHint;
import pe.restaurant.ventas.entity.CuentaCobrar;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Repository para Cuentas por Cobrar
 */
@Repository
public interface CuentaCobrarRepository extends JpaRepository<CuentaCobrar, Long> {

    /**
     * Buscar cuenta por cobrar básica (sin movimientos)
     * Los movimientos se cargan por separado en el service
     */
    @Query("SELECT c FROM CuentaCobrar c WHERE c.id = :id AND c.flagEstado = '1'")
    Optional<CuentaCobrar> findByIdWithMovimientos(@Param("id") Long id);

    /**
     * Validar que no exista duplicidad por clave natural
     */
    boolean existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
            Long clienteId, Long docTipoId, String serie, String numero, String flagEstado);

    /**
     * Validar FK de sucursal activa
     */
    @Query(value = "SELECT CASE WHEN COUNT(s) > 0 THEN true ELSE false END FROM auth.sucursal s " +
           "WHERE s.id = :sucursalId AND s.flag_estado = '1'", nativeQuery = true)
    boolean existsSucursalActivaById(@Param("sucursalId") Long sucursalId);

    /**
     * Validar FK de cliente activo
     */
    @Query(value = "SELECT CASE WHEN COUNT(e) > 0 THEN true ELSE false END FROM core.entidad_contribuyente e " +
           "WHERE e.id = :clienteId AND e.flag_estado = '1'", nativeQuery = true)
    boolean existsClienteActivoById(@Param("clienteId") Long clienteId);

    /**
     * Validar FK de tipo de documento activo
     */
    @Query(value = "SELECT CASE WHEN COUNT(dt) > 0 THEN true ELSE false END FROM core.doc_tipo dt " +
           "WHERE dt.id = :docTipoId AND dt.flag_estado = '1'", nativeQuery = true)
    boolean existsDocTipoActivoById(@Param("docTipoId") Long docTipoId);

    /**
     * Validar FK de moneda activa
     */
    @Query(value = "SELECT CASE WHEN COUNT(m) > 0 THEN true ELSE false END FROM core.moneda m " +
           "WHERE m.id = :monedaId AND m.flag_estado = '1'", nativeQuery = true)
    boolean existsMonedaActivaById(@Param("monedaId") Long monedaId);

    /**
     * Listado paginado con filtros según contrato
     */
    @Query("SELECT c FROM CuentaCobrar c " +
           "WHERE (:sucursalId IS NULL OR c.sucursalId = :sucursalId) " +
           "AND (:clienteId IS NULL OR c.clienteId = :clienteId) " +
           "AND (:docTipoId IS NULL OR c.docTipoId = :docTipoId) " +
           "AND (:fechaVencimientoDesde IS NULL OR c.fechaVencimiento >= :fechaVencimientoDesde) " +
           "AND (:fechaVencimientoHasta IS NULL OR c.fechaVencimiento <= :fechaVencimientoHasta) " +
           "AND (:flagEstado IS NULL OR :flagEstado = '' OR c.flagEstado = :flagEstado)")
    Page<CuentaCobrar> findAllWithFilters(
            @Param("sucursalId") Long sucursalId,
            @Param("clienteId") Long clienteId,
            @Param("docTipoId") Long docTipoId,
            @Param("flagEstado") String flagEstado,
            @Param("fechaVencimientoDesde") LocalDate fechaVencimientoDesde,
            @Param("fechaVencimientoHasta") LocalDate fechaVencimientoHasta,
            Pageable pageable);

    /**
     * Buscar cuentas por cobrar con saldo pendiente para cliente
     */
    @Query("SELECT c FROM CuentaCobrar c " +
           "WHERE c.clienteId = :clienteId " +
           "AND c.saldo > 0 " +
           "AND c.flagEstado = '1' " +
           "ORDER BY c.fechaVencimiento ASC")
    List<CuentaCobrar> findPendientesByCliente(@Param("clienteId") Long clienteId);

    /**
     * Validar que el saldo no sea negativo
     */
    @Query("SELECT CASE WHEN COUNT(c) > 0 THEN true ELSE false END FROM CuentaCobrar c " +
           "WHERE c.id = :id AND c.saldo < 0")
    boolean existsSaldoNegativoById(@Param("id") Long id);

    /**
     * Obtener saldo actual de cuenta por cobrar
     */
    @Query("SELECT c.saldo FROM CuentaCobrar c WHERE c.id = :id AND c.flagEstado = '1'")
    BigDecimal findSaldoById(@Param("id") Long id);

    /**
     * Validar que la cuenta no tenga movimientos bloqueantes para anulación
     */
    @Query("SELECT CASE WHEN COUNT(cd) > 0 THEN true ELSE false END FROM CuentaCobrarDet cd " +
           "WHERE cd.cuentaCobrar.id = :id " +
           "AND cd.tipoMov = 'ABONO' " +
           "AND cd.flagEstado = '1'")
    boolean existsAbonosAplicadosById(@Param("id") Long id);

    /** Validación FK hacia finanzas.concepto_financiero (misma BD tenant). */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM finanzas.concepto_financiero cf "
            + "WHERE cf.id = :conceptoId AND cf.flag_estado = '1'", nativeQuery = true)
    boolean existsConceptoFinancieroActivoById(@Param("conceptoId") Long conceptoId);

    @Query(value = "SELECT cf.id FROM finanzas.concepto_financiero cf WHERE UPPER(cf.codigo) = UPPER(:codigo) "
            + "AND cf.flag_estado = '1' LIMIT 1", nativeQuery = true)
    Optional<Long> findConceptoFinancieroIdByCodigo(@Param("codigo") String codigo);

    /**
     * Encuentra cuentas por cobrar con saldo pendiente (saldo > 0).
     * Aplica filtros opcionales por sucursal, cliente y rango de fechas.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param clienteId ID de cliente (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de cuentas por cobrar con saldo pendiente
     */
    @Query(value = "SELECT c.* FROM ventas.cntas_cobrar c " +
           "WHERE c.saldo > 0 " +
           "AND c.flag_estado = '1' " +
           "AND (CAST(:sucursalId AS BIGINT) IS NULL OR c.sucursal_id = CAST(:sucursalId AS BIGINT)) " +
           "AND (CAST(:clienteId AS BIGINT) IS NULL OR c.cliente_id = CAST(:clienteId AS BIGINT)) " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR c.fecha_emision >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR c.fecha_emision <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY c.fecha_emision DESC", nativeQuery = true)
    List<CuentaCobrar> findPendientesPorCobrar(
            @Param("sucursalId") Long sucursalId,
            @Param("clienteId") Long clienteId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);

    @Query(value = "SELECT dt.id FROM core.doc_tipo dt WHERE UPPER(TRIM(dt.tipo_doc)) = UPPER(TRIM(:codigo)) "
            + "AND dt.flag_estado = '1' LIMIT 1", nativeQuery = true)
    Optional<Long> findDocTipoIdByCodigo(@Param("codigo") String codigo);

    @Query(value = "SELECT e.razon_social FROM core.entidad_contribuyente e WHERE e.id = :clienteId LIMIT 1",
            nativeQuery = true)
    Optional<String> findClienteRazonSocialById(@Param("clienteId") Long clienteId);

    @Query(value = "SELECT TRIM(dt.desc_tipo_doc) FROM core.doc_tipo dt WHERE dt.id = :docTipoId LIMIT 1",
            nativeQuery = true)
    Optional<String> findDocTipoNombreById(@Param("docTipoId") Long docTipoId);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM ventas.fs_factura_simpl f "
            + "WHERE f.cntas_cobrar_id = :cxcId AND f.flag_estado IN ('1', '2')", nativeQuery = true)
    boolean existsFacturaVinculada(@Param("cxcId") Long cxcId);

    @Query(value = "SELECT COALESCE(SUM(c.saldo), 0) FROM ventas.cntas_cobrar c "
            + "WHERE c.cliente_id = :clienteId AND c.saldo > 0 AND c.flag_estado IN ('1', '4') "
            + "AND ((CAST(:monedaId AS BIGINT) IS NULL AND c.moneda_id IS NULL) "
            + "OR c.moneda_id = CAST(:monedaId AS BIGINT))", nativeQuery = true)
    BigDecimal sumSaldoPendienteByCliente(@Param("clienteId") Long clienteId, @Param("monedaId") Long monedaId);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM ventas.cntas_cobrar_det d "
            + "JOIN ventas.cntas_cobrar c ON c.id = d.cntas_cobrar_id "
            + "WHERE d.referencia LIKE CONCAT('ORIGEN=DETRACCION|origenId=', CAST(:origenId AS TEXT), '%') "
            + "AND c.flag_estado <> '0'", nativeQuery = true)
    boolean existsDetraccionPorOrigen(@Param("origenId") Long origenId);

    @Query(value = "SELECT d.referencia FROM ventas.cntas_cobrar_det d "
            + "WHERE d.cntas_cobrar_id = :cxcId AND d.flag_estado = '1' "
            + "ORDER BY d.id ASC LIMIT 1", nativeQuery = true)
    Optional<String> findPrimeraReferenciaMovimiento(@Param("cxcId") Long cxcId);
}
