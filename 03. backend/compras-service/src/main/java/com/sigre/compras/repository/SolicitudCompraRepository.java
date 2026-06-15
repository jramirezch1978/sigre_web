package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.compras.entity.SolicitudCompra;

public interface SolicitudCompraRepository extends JpaRepository<SolicitudCompra, Long>, JpaSpecificationExecutor<SolicitudCompra> {
}
