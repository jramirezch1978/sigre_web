package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.TipoDocIdentidadRef;

import java.util.Optional;

public interface TipoDocIdentidadRefRepository extends JpaRepository<TipoDocIdentidadRef, Long> {

    Optional<TipoDocIdentidadRef> findFirstByCodigoAndFlagEstado(String codigo, String flagEstado);
}
