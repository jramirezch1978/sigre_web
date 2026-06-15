package com.sigre.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.core.entity.RelacionComercial;

public interface RelacionComercialRepository extends JpaRepository<RelacionComercial, Long>, JpaSpecificationExecutor<RelacionComercial> {
    Page<RelacionComercial> findByEsProveedorAndEsClienteAndFlagEstado(Boolean esProveedor, Boolean esCliente, String flagEstado, Pageable pageable);

    Page<RelacionComercial> findByFlagEstado(String flagEstado, Pageable pageable);

    boolean existsByNroDocumentoAndIdNot(String nroDocumento, Long id);

    boolean existsByNroDocumento(String nroDocumento);
}
