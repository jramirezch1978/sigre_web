package pe.restaurant.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.ConceptoFinanciero;

@Repository
public interface ConceptoFinancieroRepository extends JpaRepository<ConceptoFinanciero, Long> {
}
