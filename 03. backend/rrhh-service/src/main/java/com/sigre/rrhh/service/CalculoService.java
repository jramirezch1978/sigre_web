package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.response.CalculoDetalleResponse;
import com.sigre.rrhh.dto.response.CalculoResponse;

public interface CalculoService {

    Page<CalculoResponse> listar(Integer anio, Integer mes, Long tipoPlanillaId, Pageable pageable);

    CalculoDetalleResponse obtenerDetalle(Long id);

    CalculoDetalleResponse procesar(Integer anio, Integer mes, Long tipoPlanillaId);

    void eliminar(Long id);

}
