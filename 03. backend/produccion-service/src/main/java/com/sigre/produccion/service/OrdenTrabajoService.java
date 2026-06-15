package com.sigre.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.dto.response.OrdenTrabajoResponse;
import com.sigre.produccion.entity.OrdenTrabajo;

import java.time.LocalDate;

public interface OrdenTrabajoService {

    Page<OrdenTrabajo> findAll(String codigo, Long sucursalId, Long otTipoId, Long otAdministracionId,
                                LocalDate fechaInicio, LocalDate fechaFin,
                               String flagEstado, Pageable pageable);

    OrdenTrabajo findById(Long id);

    OrdenTrabajo create(OrdenTrabajo entity);

    OrdenTrabajo update(Long id, OrdenTrabajo entity);

    OrdenTrabajo activate(Long id);

    OrdenTrabajo deactivate(Long id);

    OrdenTrabajo cerrar(Long id);

    OrdenTrabajo anular(Long id);

    void delete(Long id);

    void enrich(OrdenTrabajoResponse response);

    void enrichDetail(OrdenTrabajoResponse response);
}
