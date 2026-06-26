package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.EntidadArticulo;

import java.util.List;

public interface EntidadArticuloRepository extends JpaRepository<EntidadArticulo, Long> {

    List<EntidadArticulo> findByEntidadContribuyenteId(Long entidadContribuyenteId);
}
