package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.OcImportacion;

import java.util.Optional;

public interface OcImportacionRepository extends JpaRepository<OcImportacion, Long> {

    Optional<OcImportacion> findByOrdenCompraId(Long ordenCompraId);
}
