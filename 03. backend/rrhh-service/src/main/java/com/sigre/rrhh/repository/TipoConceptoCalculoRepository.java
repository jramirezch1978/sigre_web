package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.TipoConceptoCalculo;

@Repository
public interface TipoConceptoCalculoRepository extends JpaRepository<TipoConceptoCalculo, Long>, JpaSpecificationExecutor<TipoConceptoCalculo> {
    boolean existsByCodigo(String codigo);
    java.util.List<TipoConceptoCalculo> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
