package com.sigre.comercializacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.FacturaSimplificadaPagos;

import java.util.List;

@Repository
public interface FacturaSimplificadaPagosRepository extends JpaRepository<FacturaSimplificadaPagos, Long> {

    // Buscar pagos de una factura simplificada
    @Query("SELECT fsp FROM FacturaSimplificadaPagos fsp WHERE fsp.facturaSimplificada.id = :facturaSimplificadaId AND fsp.flagEstado = '1' ORDER BY fsp.fechaPago")
    List<FacturaSimplificadaPagos> findByFacturaSimplificadaId(@Param("facturaSimplificadaId") Long facturaSimplificadaId);

    // Validación de FK: forma_pago debe existir y estar activa
    @Query(value = "SELECT EXISTS(SELECT 1 FROM core.forma_pago WHERE id = :formaPagoId AND flag_estado = '1')", nativeQuery = true)
    boolean existsFormaPagoActiva(@Param("formaPagoId") Long formaPagoId);
}
