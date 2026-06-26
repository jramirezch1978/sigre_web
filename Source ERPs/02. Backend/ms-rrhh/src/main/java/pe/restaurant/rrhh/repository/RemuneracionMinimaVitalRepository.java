package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.RemuneracionMinimaVital;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface RemuneracionMinimaVitalRepository extends JpaRepository<RemuneracionMinimaVital, Long>,
        JpaSpecificationExecutor<RemuneracionMinimaVital> {

    boolean existsByTipoTrabajadorIdAndRmvAndFechaDesde(Long tipoTrabajadorId, BigDecimal rmv, LocalDate fechaDesde);

    boolean existsByTipoTrabajadorIdAndRmvAndFechaDesdeAndIdNot(
            Long tipoTrabajadorId, BigDecimal rmv, LocalDate fechaDesde, Long id);

    List<RemuneracionMinimaVital> findByFlagEstadoOrderByFechaDesdeDesc(String flagEstado);
}
