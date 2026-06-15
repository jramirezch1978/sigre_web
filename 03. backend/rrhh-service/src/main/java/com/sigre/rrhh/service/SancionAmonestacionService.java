package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.SancionAmonestacionCreateRequest;
import com.sigre.rrhh.dto.request.SancionAmonestacionUpdateRequest;
import com.sigre.rrhh.dto.response.SancionAmonestacionResponse;
import java.time.LocalDate;

public interface SancionAmonestacionService {
    Page<SancionAmonestacionResponse> listar(Long trabajadorId, Long tipoSancionId, LocalDate fechaDesde,
                                             LocalDate fechaHasta, String flagEstado, Pageable pageable);
    SancionAmonestacionResponse obtenerPorId(Long id);
    SancionAmonestacionResponse crear(SancionAmonestacionCreateRequest request);
    SancionAmonestacionResponse actualizar(Long id, SancionAmonestacionUpdateRequest request);
    SancionAmonestacionResponse desactivar(Long id);
}
