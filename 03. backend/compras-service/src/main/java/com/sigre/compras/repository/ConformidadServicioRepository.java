package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import com.sigre.compras.entity.ConformidadServicio;

import java.util.List;

public interface ConformidadServicioRepository
        extends JpaRepository<ConformidadServicio, Long>, JpaSpecificationExecutor<ConformidadServicio> {

    List<ConformidadServicio> findByOrdenServicioIdAndFlagEstado(Long ordenServicioId, String flagEstado);

    @Query("SELECT DISTINCT cs.ordenServicioId FROM ConformidadServicio cs WHERE cs.aprobado = true AND cs.flagEstado = '1'")
    List<Long> findOrdenServicioIdsConConformidadAprobada();
}
