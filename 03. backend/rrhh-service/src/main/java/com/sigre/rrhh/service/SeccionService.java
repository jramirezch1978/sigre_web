package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.SeccionCreateRequest;
import com.sigre.rrhh.dto.request.SeccionUpdateRequest;
import com.sigre.rrhh.dto.response.SeccionResponse;
import java.util.List;

public interface SeccionService {
    Page<SeccionResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    SeccionResponse obtenerPorId(Long id);
    SeccionResponse crear(SeccionCreateRequest request);
    SeccionResponse actualizar(Long id, SeccionUpdateRequest request);
    SeccionResponse desactivar(Long id);
    SeccionResponse activar(Long id);
    List<SeccionResponse> listarActivos();
}
