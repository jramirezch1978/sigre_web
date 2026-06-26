package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.CalendarioFeriado;

import java.time.LocalDate;
import java.util.List;

public interface CalendarioFeriadoRepository extends JpaRepository<CalendarioFeriado, Long> {

    List<CalendarioFeriado> findByFecha(LocalDate fecha);

    List<CalendarioFeriado> findBySucursalId(Long sucursalId);
}
