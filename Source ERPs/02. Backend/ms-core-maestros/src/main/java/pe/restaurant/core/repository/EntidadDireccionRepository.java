package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.EntidadDireccion;

import java.util.List;

public interface EntidadDireccionRepository extends JpaRepository<EntidadDireccion, Long> {

    List<EntidadDireccion> findByEntidadContribuyenteId(Long entidadContribuyenteId);
}
