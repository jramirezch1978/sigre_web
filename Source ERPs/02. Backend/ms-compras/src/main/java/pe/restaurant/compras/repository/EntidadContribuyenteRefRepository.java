package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.EntidadContribuyenteRef;

import java.util.Optional;

public interface EntidadContribuyenteRefRepository extends JpaRepository<EntidadContribuyenteRef, Long> {
    Optional<EntidadContribuyenteRef> findFirstByFlagEstadoOrderByIdAsc(String flagEstado);
}
