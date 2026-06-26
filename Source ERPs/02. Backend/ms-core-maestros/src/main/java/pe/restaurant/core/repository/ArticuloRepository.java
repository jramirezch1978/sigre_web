package pe.restaurant.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Articulo;

public interface ArticuloRepository extends JpaRepository<Articulo, Long> {
    Page<Articulo> findByCodigoContainingIgnoreCaseAndNombreContainingIgnoreCase(String codigo, String nombre, Pageable pageable);
    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
    boolean existsByCodigoIgnoreCase(String codigo);
}
