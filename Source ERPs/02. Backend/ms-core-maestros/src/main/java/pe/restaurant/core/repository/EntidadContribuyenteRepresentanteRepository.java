package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.EntidadContribuyenteRepresentante;

import java.util.List;

public interface EntidadContribuyenteRepresentanteRepository extends JpaRepository<EntidadContribuyenteRepresentante, Long> {
    List<EntidadContribuyenteRepresentante> findByEntidadContribuyenteId(Long entidadContribuyenteId);

    List<EntidadContribuyenteRepresentante> findByEntidadContribuyenteIdAndFlagEstado(Long entidadContribuyenteId, String flagEstado);
}
