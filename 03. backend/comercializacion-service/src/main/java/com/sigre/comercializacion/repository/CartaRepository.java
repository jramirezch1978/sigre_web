package com.sigre.comercializacion.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.Carta;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartaRepository extends JpaRepository<Carta, Long> {

    @EntityGraph(attributePaths = {"detalles", "detalles.articulo"})
    @Query("SELECT c FROM Carta c WHERE c.sucursalId = :sucursalId AND c.flagEstado = '1'")
    List<Carta> findBySucursalIdAndActivo(@Param("sucursalId") Long sucursalId);

    @EntityGraph(attributePaths = {"detalles", "detalles.articulo"})
    @Query("SELECT c FROM Carta c WHERE c.id = :id AND c.flagEstado = '1'")
    Optional<Carta> findByIdAndActivo(@Param("id") Long id);

    boolean existsByNombreAndSucursalIdAndFlagEstado(String nombre, Long sucursalId, String flagEstado);

    boolean existsByNombreAndSucursalIdAndFlagEstadoAndIdNot(String nombre, Long sucursalId, String flagEstado, Long id);

    // Búsqueda con filtros según contrato
    @EntityGraph(attributePaths = {"detalles", "detalles.articulo"})
    @Query("SELECT c FROM Carta c " +
           "WHERE (:sucursalId IS NULL OR c.sucursalId = :sucursalId) " +
           "AND (:nombre IS NULL OR :nombre = '' OR LOWER(c.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))) " +
           "AND (:flagEstado IS NULL OR c.flagEstado = :flagEstado)")
    Page<Carta> findAllWithFilters(@Param("sucursalId") Long sucursalId,
                                     @Param("nombre") String nombre,
                                     @Param("flagEstado") String flagEstado,
                                     Pageable pageable);
}
