package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.CreditoFiscal;

import java.util.List;
import java.util.Optional;

public interface CreditoFiscalRepository extends JpaRepository<CreditoFiscal, Long> {

    Optional<CreditoFiscal> findByCodigo(String codigo);

    List<CreditoFiscal> findByFlagEstado(String flagEstado);
}
