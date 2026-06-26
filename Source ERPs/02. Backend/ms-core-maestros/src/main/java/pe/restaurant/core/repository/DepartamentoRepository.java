package pe.restaurant.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Departamento;

public interface DepartamentoRepository extends JpaRepository<Departamento, Long> {
    Page<Departamento> findByPaisId(Long paisId, Pageable pageable);
    boolean existsByCodigoIgnoreCase(String codigo);
    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
