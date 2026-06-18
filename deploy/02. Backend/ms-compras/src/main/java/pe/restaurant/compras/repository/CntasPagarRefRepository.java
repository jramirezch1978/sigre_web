package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.CntasPagarRef;

import java.util.List;

public interface CntasPagarRefRepository extends JpaRepository<CntasPagarRef, Long> {

    List<CntasPagarRef> findByOrdenServicioIdAndFlagEstadoOrderByFechaDesc(Long ordenServicioId, String flagEstado);
}
