package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.CapacitacionCreateRequest;
import com.sigre.rrhh.dto.request.CapacitacionUpdateRequest;
import com.sigre.rrhh.dto.request.CapacitacionTrabajadorRequest;
import com.sigre.rrhh.dto.response.CapacitacionResponse;
import com.sigre.rrhh.dto.response.CapacitacionTrabajadorResponse;
import java.util.List;

public interface CapacitacionService {

    Page<CapacitacionResponse> listar(String nombre, String flagEstado, Pageable pageable);

    CapacitacionResponse obtenerPorId(Long id);

    CapacitacionResponse crear(CapacitacionCreateRequest request);

    CapacitacionResponse actualizar(Long id, CapacitacionUpdateRequest request);

    CapacitacionResponse desactivar(Long id);

    List<CapacitacionTrabajadorResponse> listarParticipantes(Long capacitacionId);

    CapacitacionTrabajadorResponse agregarParticipante(Long capacitacionId, CapacitacionTrabajadorRequest request);

    CapacitacionTrabajadorResponse actualizarParticipante(Long capacitacionId, Long trabajadorId, CapacitacionTrabajadorRequest request);

    void eliminarParticipante(Long capacitacionId, Long trabajadorId);
}
