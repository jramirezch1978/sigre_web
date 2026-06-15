package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.GanDescVariableImportarRequest;
import com.sigre.rrhh.dto.request.GanDescVariableRequest;
import com.sigre.rrhh.dto.response.GanDescVariableResponse;

import java.util.List;

public interface GanDescVariableService {

    Page<GanDescVariableResponse> listar(Long trabajadorId, Long conceptoId, Integer anio,
                                          Integer mes, Long tipoPlanillaId, Pageable pageable);

    GanDescVariableResponse obtenerPorId(Long id);

    GanDescVariableResponse crear(GanDescVariableRequest request);

    GanDescVariableResponse actualizar(Long id, GanDescVariableRequest request);

    void eliminar(Long id);

    List<GanDescVariableResponse> importar(GanDescVariableImportarRequest request);
}
