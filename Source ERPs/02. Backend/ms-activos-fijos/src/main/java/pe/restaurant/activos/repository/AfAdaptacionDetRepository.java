package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfAdaptacionDet;

import java.math.BigDecimal;
import java.util.List;

public interface AfAdaptacionDetRepository extends JpaRepository<AfAdaptacionDet, Long> {

    List<AfAdaptacionDet> findByAfAdaptacionId(Long afAdaptacionId);

    @Query("SELECT SUM(d.monto) FROM AfAdaptacionDet d WHERE d.afAdaptacionId = :adaptacionId")
    BigDecimal calcularTotalDetalles(@Param("adaptacionId") Long adaptacionId);

    void deleteByAfAdaptacionId(Long afAdaptacionId);
}
