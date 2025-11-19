package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.Origen;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrigenRepository extends JpaRepository<Origen, String> {
    
    /**
     * Obtener todos los orígenes activos ordenados por código
     */
    @Query("SELECT o FROM Origen o WHERE o.flagEstado = '1' ORDER BY o.codOrigen")
    List<Origen> findAllActivos();
}

