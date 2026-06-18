package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.Proforma;

import java.util.Optional;

@Repository
public interface ProformaRepository extends JpaRepository<Proforma, Long> {

    boolean existsByNumero(String numero);

    @EntityGraph(attributePaths = "detalles")
    @Query("SELECT p FROM Proforma p WHERE p.id = :id")
    Optional<Proforma> findByIdWithDetalles(@Param("id") Long id);

    /** Sin EntityGraph aquí: el listado no necesita líneas y evita problemas de paginación + fetch de colección. */
    @Query("SELECT p FROM Proforma p WHERE " +
            "(:sucursalId IS NULL OR p.sucursalId = :sucursalId) AND " +
            "(:clienteId IS NULL OR p.clienteId = :clienteId) AND " +
            "(:numero IS NULL OR :numero = '' OR LOWER(p.numero) LIKE LOWER(CONCAT('%', :numero, '%')))")
    Page<Proforma> findWithFilters(
            @Param("sucursalId") Long sucursalId,
            @Param("clienteId") Long clienteId,
            @Param("numero") String numero,
            Pageable pageable);
}
