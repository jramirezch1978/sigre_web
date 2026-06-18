package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.TipoEntidadContribuyente;

public interface TipoEntidadContribuyenteRepository extends JpaRepository<TipoEntidadContribuyente, Long> {

    boolean existsByTipoIgnoreCase(String tipo);

    boolean existsByTipoIgnoreCaseAndIdNot(String tipo, Long id);
}
