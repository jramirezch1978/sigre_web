package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.produccion.entity.Receta;

public interface RecetaRepository extends JpaRepository<Receta, Long>, JpaSpecificationExecutor<Receta> {

    boolean existsByNroRecetaIgnoreCase(String nroReceta);

    boolean existsByNroRecetaIgnoreCaseAndIdNot(String nroReceta, Long id);
}
