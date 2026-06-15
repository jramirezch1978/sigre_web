package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.produccion.entity.ArticuloDocTecnica;

public interface ArticuloDocTecnicaRepository extends JpaRepository<ArticuloDocTecnica, Long>,
        JpaSpecificationExecutor<ArticuloDocTecnica> {

    boolean existsByNombreDocumentoIgnoreCase(String nombreDocumento);

    boolean existsByNombreDocumentoIgnoreCaseAndIdNot(String nombreDocumento, Long id);
}
