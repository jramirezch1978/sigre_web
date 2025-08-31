package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.RrhhAsignaTrjtRelojRemote;
import com.sigre.sync.entity.remote.RrhhAsignaTrjtRelojRemoteId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RrhhAsignaTrjtRelojRemoteRepository extends JpaRepository<RrhhAsignaTrjtRelojRemote, RrhhAsignaTrjtRelojRemoteId> {
    
    List<RrhhAsignaTrjtRelojRemote> findByFlagEstado(String flagEstado);
    
    List<RrhhAsignaTrjtRelojRemote> findByCodTrabajador(String codTrabajador);
}