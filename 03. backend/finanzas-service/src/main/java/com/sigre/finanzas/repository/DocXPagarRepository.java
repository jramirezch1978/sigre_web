package com.sigre.finanzas.repository;

import com.sigre.finanzas.model.entity.DocXPagar;
import com.sigre.finanzas.model.entity.DocXPagarId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface DocXPagarRepository extends JpaRepository<DocXPagar, DocXPagarId> {

    @Query("SELECT d FROM DocXPagar d WHERE d.id.empresa = :empresa " +
           "AND d.flagEstado = 'P' AND d.fechaVencimiento <= :fecha " +
           "ORDER BY d.fechaVencimiento")
    List<DocXPagar> findPendientesPorVencer(
        @Param("empresa") String empresa,
        @Param("fecha") LocalDate fecha
    );

    @Query("SELECT d FROM DocXPagar d WHERE d.id.empresa = :empresa " +
           "AND d.proveedor = :proveedor AND d.flagEstado = 'P'")
    List<DocXPagar> findPendientesByProveedor(
        @Param("empresa") String empresa,
        @Param("proveedor") String proveedor
    );
}

