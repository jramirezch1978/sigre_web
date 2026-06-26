package pe.restaurant.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.Uit;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface UitRepository extends JpaRepository<Uit, Long>, JpaSpecificationExecutor<Uit> {

    Optional<Uit> findByAnoAndFecIniVigen(Integer ano, LocalDate fecIniVigen);

    boolean existsByAnoAndFecIniVigen(Integer ano, LocalDate fecIniVigen);

    boolean existsByAnoAndFecIniVigenAndIdNot(Integer ano, LocalDate fecIniVigen, Long id);

    Optional<Uit> findFirstByFlagEstadoAndFecIniVigenLessThanEqualOrderByFecIniVigenDescAnoDesc(
            String flagEstado, LocalDate fecha);
}
