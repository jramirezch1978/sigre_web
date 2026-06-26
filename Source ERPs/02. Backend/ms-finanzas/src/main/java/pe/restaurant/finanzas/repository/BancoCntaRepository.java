package pe.restaurant.finanzas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.finanzas.entity.BancoCnta;

import java.math.BigDecimal;

public interface BancoCntaRepository extends JpaRepository<BancoCnta, Long> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);

    Page<BancoCnta> findByMonedaIdAndFlagEstado(Long monedaId, String flagEstado, Pageable pageable);

    Page<BancoCnta> findByTipoCtaBcoAndFlagEstado(String tipoCtaBco, String flagEstado, Pageable pageable);

    Page<BancoCnta> findByFlagEstado(String flagEstado, Pageable pageable);

    @Query("SELECT b.saldoContable FROM BancoCnta b WHERE b.id = :id AND b.flagEstado = '1'")
    BigDecimal findSaldoContableById(@Param("id") Long id);
}
