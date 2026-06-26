package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.EntidadDetraccion;

import java.util.List;

public interface EntidadDetraccionRepository extends JpaRepository<EntidadDetraccion, Long> {

    List<EntidadDetraccion> findByEntidadContribuyenteId(Long entidadContribuyenteId);
}
