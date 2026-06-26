package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.produccion.entity.RecetaLaborConsumible;

import java.util.List;

public interface RecetaLaborConsumibleRepository extends JpaRepository<RecetaLaborConsumible, Long> {

    List<RecetaLaborConsumible> findByRecetaPadreIdOrderByIdAsc(Long recetaPadreId);

    void deleteByRecetaPadreId(Long recetaPadreId);
}
