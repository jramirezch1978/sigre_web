package com.sigre.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.dto.response.LaborEjecutorResponse;
import com.sigre.produccion.entity.Labor;
import com.sigre.produccion.entity.LaborEjecutor;
import com.sigre.produccion.entity.LaborInsumo;
import com.sigre.produccion.entity.LaborProduccion;

import java.util.List;

public interface LaborService {

    Page<Labor> findAll(String codigo, String nombre, String flagEstado, Pageable pageable);

    Labor findById(Long id);

    Labor create(Labor entity);

    Labor update(Long id, Labor entity);

    Labor activate(Long id);

    Labor deactivate(Long id);

    void delete(Long id);

    // Sub-recurso insumos

    List<LaborInsumo> findInsumos(Long laborId);

    LaborInsumo asignarInsumo(Long laborId, Long articuloId);

    void desasignarInsumo(Long laborId, Long articuloId);

    // Sub-recurso producidos

    List<LaborProduccion> findProducidos(Long laborId);

    LaborProduccion asignarProducido(Long laborId, Long articuloId);

    void desasignarProducido(Long laborId, Long articuloId);

    // Sub-recurso ejecutores

    List<LaborEjecutor> findEjecutores(Long laborId);

    LaborEjecutor asignarEjecutor(Long laborId, Long ejecutorId, LaborEjecutor data);

    LaborEjecutor actualizarEjecutor(Long laborId, Long ejecutorId, LaborEjecutor data);

    void desasignarEjecutor(Long laborId, Long ejecutorId);

    void enrichEjecutores(List<LaborEjecutorResponse> responses);
}
