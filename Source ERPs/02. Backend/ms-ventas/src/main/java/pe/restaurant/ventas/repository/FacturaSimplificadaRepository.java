package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.EntityGraph;
import pe.restaurant.ventas.entity.FacturaSimplificada;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface FacturaSimplificadaRepository extends JpaRepository<FacturaSimplificada, Long> {

    // Validación de FK: sucursal debe existir y estar activa
    @Query(value = "SELECT EXISTS(SELECT 1 FROM auth.sucursal WHERE id = :sucursalId AND flag_estado = '1')", nativeQuery = true)
    boolean existsSucursalActiva(@Param("sucursalId") Long sucursalId);

    // Validación de FK: punto_venta debe existir y estar activo
    @Query(value = "SELECT EXISTS(SELECT 1 FROM ventas.punto_venta WHERE id = :puntoVentaId AND flag_estado = '1')", nativeQuery = true)
    boolean existsPuntoVentaActivo(@Param("puntoVentaId") Long puntoVentaId);

    // Validación de FK: cliente debe existir y estar activo
    @Query(value = "SELECT EXISTS(SELECT 1 FROM core.entidad_contribuyente WHERE id = :clienteId AND flag_estado = '1')", nativeQuery = true)
    boolean existsClienteActivo(@Param("clienteId") Long clienteId);

    // Validación de FK: doc_tipo debe existir y estar activo
    @Query(value = "SELECT EXISTS(SELECT 1 FROM core.doc_tipo WHERE id = :docTipoId AND flag_estado = '1')", nativeQuery = true)
    boolean existsDocTipoActivo(@Param("docTipoId") Long docTipoId);

    // Validación de FK: moneda debe existir y estar activa
    @Query(value = "SELECT EXISTS(SELECT 1 FROM core.moneda WHERE id = :monedaId AND flag_estado = '1')", nativeQuery = true)
    boolean existsMonedaActiva(@Param("monedaId") Long monedaId);

    // Validación de unicidad: docTipoId + serie + numero
    @Query("SELECT COUNT(f) > 0 FROM FacturaSimplificada f WHERE f.docTipoId = :docTipoId AND f.serie = :serie AND f.numero = :numero AND f.flagEstado = '1'")
    boolean existsByDocTipoIdAndSerieAndNumeroAndFlagEstado(@Param("docTipoId") Long docTipoId, 
                                                          @Param("serie") String serie, 
                                                          @Param("numero") String numero);

    // Validación de unicidad excluyendo un ID (para update)
    @Query("SELECT COUNT(f) > 0 FROM FacturaSimplificada f WHERE f.docTipoId = :docTipoId AND f.serie = :serie AND f.numero = :numero AND f.flagEstado = '1' AND f.id != :excludeId")
    boolean existsByDocTipoIdAndSerieAndNumeroAndFlagEstadoAndIdNot(@Param("docTipoId") Long docTipoId, 
                                                                   @Param("serie") String serie, 
                                                                   @Param("numero") String numero, 
                                                                   @Param("excludeId") Long excludeId);

    // Búsqueda con filtros según contrato
    @Query("SELECT f FROM FacturaSimplificada f " +
           "WHERE (:sucursalId IS NULL OR f.sucursalId = :sucursalId) " +
           "AND (:clienteId IS NULL OR f.clienteId = :clienteId) " +
           "AND (:docTipoId IS NULL OR f.docTipoId = :docTipoId) " +
           "AND (:serie IS NULL OR :serie = '' OR f.serie = :serie) " +
           "AND (:numero IS NULL OR :numero = '' OR f.numero = :numero) " +
           "AND (:fechaDesde IS NULL OR f.fechaEmision >= :fechaDesde) " +
           "AND (:fechaHasta IS NULL OR f.fechaEmision <= :fechaHasta)")
    Page<FacturaSimplificada> findAllWithFilters(@Param("sucursalId") Long sucursalId,
                                                @Param("clienteId") Long clienteId,
                                                @Param("docTipoId") Long docTipoId,
                                                @Param("serie") String serie,
                                                @Param("numero") String numero,
                                                @Param("fechaDesde") LocalDate fechaDesde,
                                                @Param("fechaHasta") LocalDate fechaHasta,
                                                Pageable pageable);

    // Para cargar con relaciones y evitar LazyInitializationException
    @EntityGraph(attributePaths = {"items", "pagos"})
    @Query("SELECT f FROM FacturaSimplificada f WHERE f.id = :id")
    Optional<FacturaSimplificada> findByIdWithRelations(@Param("id") Long id);
}
