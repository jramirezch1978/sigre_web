package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.CreditoFiscal;

public interface CreditoFiscalService {
    Page<CreditoFiscal> findAll(Pageable pageable);
    CreditoFiscal findById(Long id);
    CreditoFiscal create(CreditoFiscal entity);
    CreditoFiscal update(Long id, CreditoFiscal entity);
    void delete(Long id);
    CreditoFiscal activate(Long id);
    CreditoFiscal deactivate(Long id);
}
