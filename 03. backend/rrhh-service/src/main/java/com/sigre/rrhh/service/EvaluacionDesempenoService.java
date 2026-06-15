package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.EvaluacionDesempenoCreateRequest;
import com.sigre.rrhh.dto.request.EvaluacionDesempenoUpdateRequest;
import com.sigre.rrhh.dto.response.EvaluacionDesempenoResponse;

public interface EvaluacionDesempenoService {
    Page<EvaluacionDesempenoResponse> listar(Long trabajadorId, Integer periodoAnio, Integer periodoSemestre, Pageable pageable);
    EvaluacionDesempenoResponse obtenerPorId(Long id);
    EvaluacionDesempenoResponse crear(EvaluacionDesempenoCreateRequest request);
    EvaluacionDesempenoResponse actualizar(Long id, EvaluacionDesempenoUpdateRequest request);
    void eliminar(Long id);
}
