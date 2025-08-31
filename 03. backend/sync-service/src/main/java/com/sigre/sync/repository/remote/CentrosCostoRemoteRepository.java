package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.CentrosCostoRemote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CentrosCostoRemoteRepository extends JpaRepository<CentrosCostoRemote, String> {
    
    List<CentrosCostoRemote> findAllByOrderByCencos();
    List<CentrosCostoRemote> findByFlagEstado(String flagEstado);
}
