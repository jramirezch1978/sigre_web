package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.request.DetraccionRequest;
import com.sigre.finanzas.dto.response.DetraccionResponse;

public interface DetraccionService {

    Page<DetraccionResponse> listar(String nroDetraccion, Long cntasPagarId, String flagEstado, Pageable pageable);

    DetraccionResponse obtenerPorId(Long id);

    DetraccionResponse crear(DetraccionRequest request);

    DetraccionResponse actualizar(Long id, DetraccionRequest request);

    DetraccionResponse activar(Long id);

    DetraccionResponse desactivar(Long id);
}
