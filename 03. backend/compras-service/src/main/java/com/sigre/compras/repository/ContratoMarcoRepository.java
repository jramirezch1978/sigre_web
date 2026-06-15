package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.compras.entity.ContratoMarco;

public interface ContratoMarcoRepository extends JpaRepository<ContratoMarco, Long>,
        JpaSpecificationExecutor<ContratoMarco> {
}
