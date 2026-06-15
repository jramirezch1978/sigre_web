package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.SolicitarGoceRequest;
import com.sigre.rrhh.dto.request.VacacionCreateRequest;
import com.sigre.rrhh.dto.request.VacacionObservarRequest;
import com.sigre.rrhh.dto.request.VacacionUpdateRequest;
import com.sigre.rrhh.dto.response.SaldoVacacionDto;
import com.sigre.rrhh.dto.response.VacacionResponse;

import java.util.List;

public interface VacacionService {
    Page<VacacionResponse> listar(Long trabajadorId, Integer periodoAnio, String flagEstado, Pageable pageable);
    VacacionResponse obtenerPorId(Long id);
    VacacionResponse crear(VacacionCreateRequest request);
    VacacionResponse actualizar(Long id, VacacionUpdateRequest request);
    VacacionResponse solicitarGoce(Long id, SolicitarGoceRequest request);
    VacacionResponse aprobar(Long id);
    VacacionResponse rechazar(Long id);
    VacacionResponse reprogramar(Long id, SolicitarGoceRequest request);
    VacacionResponse desactivar(Long id);
    VacacionResponse observar(Long id, VacacionObservarRequest request);
    VacacionResponse anular(Long id);
    VacacionResponse cerrar(Long id);

    Page<VacacionResponse> bandejaAprobacion(Integer periodoAnio, Pageable pageable);
    List<SaldoVacacionDto> consultarSaldos(Integer periodoAnio);
    VacacionResponse procesar(Integer periodoAnio);
}
