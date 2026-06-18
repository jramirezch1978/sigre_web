package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.ArticuloAlmacenConfig;

import java.util.List;
import java.util.Optional;

public interface ArticuloAlmacenConfigRepository extends JpaRepository<ArticuloAlmacenConfig, Long> {
    List<ArticuloAlmacenConfig> findByArticuloId(Long articuloId);
    Optional<ArticuloAlmacenConfig> findByArticuloIdAndAlmacenId(Long articuloId, Long almacenId);
}
