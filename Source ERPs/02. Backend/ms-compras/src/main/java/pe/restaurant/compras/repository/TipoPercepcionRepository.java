package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.TipoPercepcion;

public interface TipoPercepcionRepository extends JpaRepository<TipoPercepcion, Long> {
}
