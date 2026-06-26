package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.ControlSubsidio;

@Repository
public interface ControlSubsidioRepository extends JpaRepository<ControlSubsidio, Long> {
}
