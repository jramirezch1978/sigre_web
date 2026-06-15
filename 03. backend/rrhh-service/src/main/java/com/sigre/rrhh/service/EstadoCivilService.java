package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.EstadoCivilCreateRequest;
import com.sigre.rrhh.dto.request.EstadoCivilUpdateRequest;
import com.sigre.rrhh.dto.response.EstadoCivilResponse;

public interface EstadoCivilService {
    Page<EstadoCivilResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    EstadoCivilResponse obtenerPorId(Long id);
    EstadoCivilResponse crear(EstadoCivilCreateRequest request);
    EstadoCivilResponse actualizar(Long id, EstadoCivilUpdateRequest request);
    EstadoCivilResponse desactivar(Long id);
    EstadoCivilResponse activar(Long id);
    java.util.List<EstadoCivilResponse> listarActivos();
}
