package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Uit;

import java.util.List;
import java.util.Optional;

public interface UitRepository extends JpaRepository<Uit, Long> {

    List<Uit> findByAno(Integer ano);

    Optional<Uit> findByAnoAndFecIniVigen(Integer ano, java.time.LocalDate fecIniVigen);
}
