package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.GanDescFijoEstadoRequest;
import com.sigre.rrhh.dto.request.GanDescFijoRequest;
import com.sigre.rrhh.entity.GanDescFijo;

public interface GanDescFijoService {

    Page<GanDescFijo> listar(Long trabajadorId, Long conceptoId, String flagEstado, Pageable pageable);

    GanDescFijo obtenerPorId(Long id);

    GanDescFijo crear(GanDescFijoRequest request);

    GanDescFijo actualizar(Long id, GanDescFijoRequest request);

    GanDescFijo cambiarEstado(Long id, GanDescFijoEstadoRequest request);
}
