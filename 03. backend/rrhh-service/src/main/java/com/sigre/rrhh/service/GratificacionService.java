package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.GratificacionProcesarRequest;
import com.sigre.rrhh.dto.response.GratificacionResponse;
import java.util.List;

public interface GratificacionService {
    List<GratificacionResponse> procesar(GratificacionProcesarRequest request);
    Page<GratificacionResponse> listar(Long trabajadorId, Integer anio, Long periodoGratificacionId, Pageable pageable);
    GratificacionResponse obtenerPorId(Long id);
}
