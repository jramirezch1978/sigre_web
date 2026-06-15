package com.sigre.comercializacion.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.Vendedor;

import java.util.Optional;

@Repository
public interface VendedorRepository extends JpaRepository<Vendedor, Long> {

    @EntityGraph(attributePaths = {"usuario"})
    @Query("SELECT v FROM Vendedor v WHERE v.usuario.id = :usuarioId AND v.flagEstado = '1'")
    Optional<Vendedor> findByUsuarioIdAndActivo(@Param("usuarioId") Long usuarioId);

    @EntityGraph(attributePaths = {"usuario"})
    @Query("SELECT v FROM Vendedor v WHERE v.id = :id")
    Optional<Vendedor> findByIdWithRelations(@Param("id") Long id);

    boolean existsByUsuarioIdAndFlagEstado(Long usuarioId, String flagEstado);

    boolean existsByUsuarioIdAndFlagEstadoAndIdNot(Long usuarioId, String flagEstado, Long id);

    // Validación de FK: usuario debe existir y estar activo
    @Query(value = "SELECT EXISTS(SELECT 1 FROM auth.usuario WHERE id = :usuarioId AND flag_estado = '1')", nativeQuery = true)
    boolean existsUsuarioActivo(@Param("usuarioId") Long usuarioId);

    // Búsqueda con filtros según contrato: usuarioId, nombre, flagEstado
    @EntityGraph(attributePaths = {"usuario"})
    @Query("SELECT v FROM Vendedor v " +
           "WHERE (:usuarioId IS NULL OR v.usuario.id = :usuarioId) " +
           "AND (:nombre IS NULL OR :nombre = '' OR LOWER(v.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))) " +
           "AND (:flagEstado IS NULL OR v.flagEstado = :flagEstado)")
    Page<Vendedor> findAllWithFilters(@Param("usuarioId") Long usuarioId,
                                      @Param("nombre") String nombre,
                                      @Param("flagEstado") String flagEstado,
                                      Pageable pageable);
}
