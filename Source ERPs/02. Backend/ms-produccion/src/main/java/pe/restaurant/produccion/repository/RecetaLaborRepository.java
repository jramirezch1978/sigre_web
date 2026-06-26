package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.produccion.entity.RecetaLabor;

import java.util.List;

public interface RecetaLaborRepository extends JpaRepository<RecetaLabor, Long> {

    List<RecetaLabor> findByRecetaIdOrderBySecuenciaAsc(Long recetaId);

    void deleteByRecetaId(Long recetaId);
}
