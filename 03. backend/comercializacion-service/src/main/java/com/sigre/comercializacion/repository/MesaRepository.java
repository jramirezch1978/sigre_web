package com.sigre.comercializacion.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.Mesa;

import java.util.List;
import java.util.Optional;

@Repository
public interface MesaRepository extends JpaRepository<Mesa, Long> {

    boolean existsByNumeroAndFlagEstado(String numero, String flagEstado);

    boolean existsByNumeroAndFlagEstadoAndIdNot(String numero, String flagEstado, Long id);

    @EntityGraph(attributePaths = {"zona", "zona.sucursal"})
    @Query("SELECT m FROM Mesa m WHERE m.id = :id")
    Optional<Mesa> findByIdWithRelations(@Param("id") Long id);

    @EntityGraph(attributePaths = {"zona", "zona.sucursal"})
    @Query("SELECT m FROM Mesa m WHERE m.numero = :numero AND m.flagEstado = '1'")
    Optional<Mesa> findByNumeroAndActivo(@Param("numero") String numero);

    @EntityGraph(attributePaths = {"zona", "zona.sucursal"})
    @Query("SELECT m FROM Mesa m WHERE m.zona.id = :zonaId AND m.flagEstado = '1'")
    List<Mesa> findByZonaIdAndActivo(@Param("zonaId") Long zonaId);

    @Query("SELECT m FROM Mesa m WHERE m.zona.sucursal.id = :sucursalId AND m.flagEstado = '1'")
    List<Mesa> findBySucursalIdAndActivo(@Param("sucursalId") Long sucursalId);

    // Método para cargar zona completa con sus relaciones
    @EntityGraph(attributePaths = {"zona", "zona.sucursal"})
    @Query("SELECT z FROM Mesa z WHERE z.zona.id = :id AND z.flagEstado = '1'")
    List<Mesa> findMesasByZonaId(@Param("id") Long id);

    @EntityGraph(attributePaths = {"zona", "zona.sucursal"})
    @Query("SELECT m FROM Mesa m " +
           "WHERE (:zonaId IS NULL OR m.zona.id = :zonaId) " +
           "AND (:numero IS NULL OR :numero = '' OR LOWER(m.numero) LIKE LOWER(CONCAT('%', :numero, '%'))) " +
           "AND (:flagEstado IS NULL OR :flagEstado = '' OR m.flagEstado = :flagEstado)")
    Page<Mesa> findAllWithFilters(@Param("zonaId") Long zonaId,
                                  @Param("numero") String numero,
                                  @Param("flagEstado") String flagEstado,
                                  Pageable pageable);

    // Validación de que zona existe y pertenece a la sucursal
    @Query(value = "SELECT EXISTS(SELECT 1 FROM ventas.zona WHERE id = :zonaId AND sucursal_id = :sucursalId AND flag_estado = '1')", nativeQuery = true)
    boolean existsZonaByIdAndSucursalId(@Param("zonaId") Long zonaId, @Param("sucursalId") Long sucursalId);
}
