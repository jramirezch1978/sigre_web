package pe.restaurant.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.almacen.entity.AlmacenTipo;

public interface AlmacenTipoRepository extends JpaRepository<AlmacenTipo, Long> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
