package com.sigre.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.contabilidad.entity.ConceptoFinanciero;

@Repository
public interface ConceptoFinancieroRepository extends JpaRepository<ConceptoFinanciero, Long> {
}
