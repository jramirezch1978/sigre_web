package com.sigre.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.contabilidad.entity.CntblLibro;

import java.util.Optional;

@Repository
public interface CntblLibroRepository extends JpaRepository<CntblLibro, Long>, JpaSpecificationExecutor<CntblLibro> {

    Optional<CntblLibro> findByCodigo(String codigo);

    boolean existsByCodigoAndIdNot(String codigo, Long id);
}
