package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.ImpuestoRentaTramo;

import java.time.LocalDate;
import java.util.List;

public interface ImpuestoRentaTramoRepository extends JpaRepository<ImpuestoRentaTramo, Long>,
        JpaSpecificationExecutor<ImpuestoRentaTramo> {

    boolean existsByFechaVigIniAndSecuencia(LocalDate fechaVigIni, Integer secuencia);

    boolean existsByFechaVigIniAndSecuenciaAndIdNot(LocalDate fechaVigIni, Integer secuencia, Long id);

    List<ImpuestoRentaTramo> findByFlagEstadoOrderByFechaVigIniDescSecuenciaAsc(String flagEstado);
}
