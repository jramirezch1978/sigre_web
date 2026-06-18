package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.EntidadTienda;

import java.util.List;

public interface EntidadTiendaRepository extends JpaRepository<EntidadTienda, Long> {
    List<EntidadTienda> findByEntidadContribuyenteId(Long entidadContribuyenteId);
}
