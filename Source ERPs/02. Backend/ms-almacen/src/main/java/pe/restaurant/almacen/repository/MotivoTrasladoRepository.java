package pe.restaurant.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.almacen.entity.MotivoTraslado;

public interface MotivoTrasladoRepository extends JpaRepository<MotivoTraslado, Long> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
