package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.ServicioCatalogo;

public interface ServicioCatalogoRepository extends JpaRepository<ServicioCatalogo, Long> {

    boolean existsByServicioIgnoreCase(String servicio);

    boolean existsByServicioIgnoreCaseAndIdNot(String servicio, Long id);
}
