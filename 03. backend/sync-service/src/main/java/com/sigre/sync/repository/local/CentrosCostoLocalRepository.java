package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.CentrosCostoLocal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CentrosCostoLocalRepository extends JpaRepository<CentrosCostoLocal, String> {
    
    @Query("SELECT COUNT(c) FROM CentrosCostoLocal c")
    long countTotal();
    
    List<CentrosCostoLocal> findByEstadoSyncOrEstadoSyncIsNull(String estadoSync);
}
