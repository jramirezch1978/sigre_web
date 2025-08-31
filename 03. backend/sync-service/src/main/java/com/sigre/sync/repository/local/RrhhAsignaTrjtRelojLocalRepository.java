package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.RrhhAsignaTrjtRelojLocal;
import com.sigre.sync.entity.local.RrhhAsignaTrjtRelojLocalId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RrhhAsignaTrjtRelojLocalRepository extends JpaRepository<RrhhAsignaTrjtRelojLocal, RrhhAsignaTrjtRelojLocalId> {
    
    List<RrhhAsignaTrjtRelojLocal> findByEstadoSync(String estadoSync);
    
    List<RrhhAsignaTrjtRelojLocal> findByCodTrabajador(String codTrabajador);
}