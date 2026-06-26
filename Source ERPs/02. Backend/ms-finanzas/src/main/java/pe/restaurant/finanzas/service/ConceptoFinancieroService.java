package pe.restaurant.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.finanzas.entity.ConceptoFinanciero;

public interface ConceptoFinancieroService {

    Page<ConceptoFinanciero> findAll(Pageable pageable);

    ConceptoFinanciero findById(Long id);

    ConceptoFinanciero create(ConceptoFinanciero entity);

    ConceptoFinanciero update(Long id, ConceptoFinanciero entity);

    ConceptoFinanciero activate(Long id);

    ConceptoFinanciero deactivate(Long id);

    void delete(Long id);
}
