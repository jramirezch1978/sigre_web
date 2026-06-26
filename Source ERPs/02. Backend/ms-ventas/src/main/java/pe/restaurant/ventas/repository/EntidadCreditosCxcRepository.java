package pe.restaurant.ventas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.EntidadCreditosCxc;

import java.util.Optional;

@Repository
public interface EntidadCreditosCxcRepository extends JpaRepository<EntidadCreditosCxc, Long>, JpaSpecificationExecutor<EntidadCreditosCxc> {

    @Query("SELECT e FROM EntidadCreditosCxc e WHERE e.entidadContribuyenteId = :entId AND e.flagEstado = '1' "
            + "AND ((:monedaId IS NULL AND e.monedaId IS NULL) OR e.monedaId = :monedaId)")
    Optional<EntidadCreditosCxc> findActiveByEntidadAndMoneda(
            @Param("entId") Long entidadContribuyenteId,
            @Param("monedaId") Long monedaId);

    @Query("SELECT CASE WHEN COUNT(e) > 0 THEN true ELSE false END FROM EntidadCreditosCxc e "
            + "WHERE e.entidadContribuyenteId = :entId AND e.flagEstado = '1' "
            + "AND ((:monedaId IS NULL AND e.monedaId IS NULL) OR e.monedaId = :monedaId) "
            + "AND (:excludeId IS NULL OR e.id <> :excludeId)")
    boolean existsActiveDuplicate(
            @Param("entId") Long entidadContribuyenteId,
            @Param("monedaId") Long monedaId,
            @Param("excludeId") Long excludeId);
}
