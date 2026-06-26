package pe.restaurant.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Distrito;

public interface DistritoRepository extends JpaRepository<Distrito, Long> {
    Page<Distrito> findByProvinciaId(Long provinciaId, Pageable pageable);
    boolean existsByCodigoIgnoreCase(String codigo);
    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
