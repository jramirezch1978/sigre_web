package com.sigre.comercializacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.Propina;

import java.util.List;

@Repository
public interface PropinaRepository extends JpaRepository<Propina, Long>, JpaSpecificationExecutor<Propina> {

    List<Propina> findByFsFacturaSimplIdAndFlagEstado(Long fsFacturaSimplId, String flagEstado);
}
