package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.DocTipoRef;

import java.util.Optional;

public interface DocTipoRefRepository extends JpaRepository<DocTipoRef, Long> {
    Optional<DocTipoRef> findFirstByCodigoAndFlagEstado(String codigo, String flagEstado);
}
