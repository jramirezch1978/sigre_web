package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.PuntoVenta;

import java.util.Optional;

@Repository
public interface PuntoVentaRepository extends JpaRepository<PuntoVenta, Long> {

    @EntityGraph(attributePaths = {"sucursal", "almacen"})
    @Query("SELECT pv FROM PuntoVenta pv WHERE pv.id = :id")
    Optional<PuntoVenta> findByIdWithRelations(@Param("id") Long id);

    boolean existsBySucursalIdAndCodigoAndFlagEstado(Long sucursalId, String codigo, String flagEstado);

    boolean existsBySucursalIdAndCodigoAndFlagEstadoAndIdNot(Long sucursalId, String codigo, String flagEstado, Long id);

    // Validaciones de series duplicadas
    boolean existsBySucursalIdAndSerieBoletaAndFlagEstado(Long sucursalId, String serieBoleta, String flagEstado);

    boolean existsBySucursalIdAndSerieBoletaAndFlagEstadoAndIdNot(Long sucursalId, String serieBoleta, String flagEstado, Long id);

    boolean existsBySucursalIdAndSerieFacturaAndFlagEstado(Long sucursalId, String serieFactura, String flagEstado);

    boolean existsBySucursalIdAndSerieFacturaAndFlagEstadoAndIdNot(Long sucursalId, String serieFactura, String flagEstado, Long id);

    @EntityGraph(attributePaths = {"sucursal", "almacen"})
    @Query("SELECT pv FROM PuntoVenta pv WHERE pv.sucursal.id = :sucursalId AND pv.codigo = :codigo AND pv.flagEstado = '1'")
    Optional<PuntoVenta> findBySucursalIdAndCodigoAndActivo(@Param("sucursalId") Long sucursalId, @Param("codigo") String codigo);

    @EntityGraph(attributePaths = {"sucursal", "almacen"})
    @Query("SELECT pv FROM PuntoVenta pv WHERE pv.sucursal.id = :sucursalId AND pv.flagEstado = '1'")
    java.util.List<PuntoVenta> findBySucursalIdAndActivo(@Param("sucursalId") Long sucursalId);

    // Búsqueda con filtros según contrato: sucursalId, codigo, nombre, flagEstado
    @EntityGraph(attributePaths = {"sucursal", "almacen"})
    @Query("SELECT pv FROM PuntoVenta pv " +
           "WHERE (:sucursalId IS NULL OR pv.sucursalId = :sucursalId) " +
           "AND (:codigo IS NULL OR :codigo = '' OR LOWER(pv.codigo) LIKE LOWER(CONCAT('%', :codigo, '%'))) " +
           "AND (:nombre IS NULL OR :nombre = '' OR LOWER(pv.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))) " +
           "AND (:flagEstado IS NULL OR pv.flagEstado = :flagEstado)")
    Page<PuntoVenta> findAllWithFilters(@Param("sucursalId") Long sucursalId,
                                        @Param("codigo") String codigo,
                                        @Param("nombre") String nombre,
                                        @Param("flagEstado") String flagEstado,
                                        Pageable pageable);

    // Validación de FK almacén
    @Query(value = "SELECT EXISTS(SELECT 1 FROM almacen.almacen WHERE id = :almacenId AND flag_estado = '1')", nativeQuery = true)
    boolean existsAlmacenActivo(@Param("almacenId") Long almacenId);

    // Validación de que almacén pertenece a la sucursal
    @Query(value = "SELECT EXISTS(SELECT 1 FROM almacen.almacen WHERE id = :almacenId AND sucursal_id = :sucursalId AND flag_estado = '1')", nativeQuery = true)
    boolean existsAlmacenByIdAndSucursalId(@Param("almacenId") Long almacenId, @Param("sucursalId") Long sucursalId);
}
