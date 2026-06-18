package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.PedidoMesa;

import java.util.Optional;

@Repository
public interface PedidoMesaRepository extends JpaRepository<PedidoMesa, Long>, JpaSpecificationExecutor<PedidoMesa> {

    boolean existsByNumeroAndFlagEstado(String numero, String flagEstado);

    boolean existsByNumeroAndFlagEstadoAndIdNot(String numero, String flagEstado, Long id);

    boolean existsByMesa_IdAndFlagEstado(Long mesaId, String flagEstado);

    boolean existsByMesa_IdAndFlagEstadoAndIdNot(Long mesaId, String flagEstado, Long id);

    @EntityGraph(attributePaths = {"mesa", "mesa.zona"})
    @Query("SELECT p FROM PedidoMesa p WHERE p.id = :id")
    Optional<PedidoMesa> findByIdWithRelations(@Param("id") Long id);

    /**
     * Redeclaración con {@link EntityGraph}: el nombre {@code findAllWithMesaGraph} rompía el arranque
     * (Spring Data lo interpretaba como query derivada: “no property findAllWithMesaGraph”).
     */
    @EntityGraph(attributePaths = {"mesa", "mesa.zona"})
    @Override
    Page<PedidoMesa> findAll(@Nullable Specification<PedidoMesa> spec, Pageable pageable);
}
