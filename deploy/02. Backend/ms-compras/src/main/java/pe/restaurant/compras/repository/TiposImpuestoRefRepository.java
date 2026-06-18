package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.TiposImpuestoRef;

import java.util.Optional;

public interface TiposImpuestoRefRepository extends JpaRepository<TiposImpuestoRef, Long> {
    Optional<TiposImpuestoRef> findByTipoImpuesto(String tipoImpuesto);
    boolean existsByTipoImpuesto(String tipoImpuesto);
}
