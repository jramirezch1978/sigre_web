package com.sigre.finanzas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.finanzas.entity.ConceptoFinanciero;

import java.util.Optional;

public interface ConceptoFinancieroRepository extends JpaRepository<ConceptoFinanciero, Long> {

    Optional<ConceptoFinanciero> findByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);

    Page<ConceptoFinanciero> findByFlagEstado(String flagEstado, Pageable pageable);
}
