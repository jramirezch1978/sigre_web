package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.ArticuloClase;

public interface ArticuloClaseRepository extends JpaRepository<ArticuloClase, Long> {
    boolean existsByCodClaseIgnoreCase(String codClase);
    boolean existsByCodClaseIgnoreCaseAndIdNot(String codClase, Long id);
}
