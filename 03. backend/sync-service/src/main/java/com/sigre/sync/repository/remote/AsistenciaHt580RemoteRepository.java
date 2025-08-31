package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.AsistenciaHt580Remote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AsistenciaHt580RemoteRepository extends JpaRepository<AsistenciaHt580Remote, String> {
    
    /**
     * Verificar si existe por RECKEY
     */
    boolean existsByReckey(String reckey);
}
