package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.CntaCrrte;

public interface CntaCrrteRepository extends JpaRepository<CntaCrrte, Long>,
        JpaSpecificationExecutor<CntaCrrte> {

    boolean existsByTrabajadorIdAndDocTipoIdAndNroDoc(Long trabajadorId, Long docTipoId, String nroDoc);
}
