package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.SunatCubso;

import java.util.Optional;

public interface SunatCubsoRepository extends JpaRepository<SunatCubso, Long> {

    Optional<SunatCubso> findByCodCubso(String codCubso);
}
