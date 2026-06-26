package pe.restaurant.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Provincia;

public interface ProvinciaRepository extends JpaRepository<Provincia, Long> {
    Page<Provincia> findByDepartamentoId(Long departamentoId, Pageable pageable);
    boolean existsByCodigoIgnoreCase(String codigo);
    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
