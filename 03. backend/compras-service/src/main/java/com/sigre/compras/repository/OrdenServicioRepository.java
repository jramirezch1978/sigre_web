package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.compras.entity.OrdenServicio;

public interface OrdenServicioRepository extends JpaRepository<OrdenServicio, Long>, JpaSpecificationExecutor<OrdenServicio> {
}
