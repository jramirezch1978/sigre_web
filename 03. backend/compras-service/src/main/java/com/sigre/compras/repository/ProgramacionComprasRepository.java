package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.compras.entity.ProgramacionCompras;

public interface ProgramacionComprasRepository extends JpaRepository<ProgramacionCompras, Long>,
        JpaSpecificationExecutor<ProgramacionCompras> {
}
