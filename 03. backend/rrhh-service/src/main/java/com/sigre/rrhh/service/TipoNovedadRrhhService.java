package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.TipoNovedadRrhhResponse;

public interface TipoNovedadRrhhService {

    Page<TipoNovedadRrhhResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);

    TipoNovedadRrhhResponse obtenerPorId(Long id);

    TipoNovedadRrhhResponse crear(TipoNovedadRrhhCreateRequest request);

    TipoNovedadRrhhResponse actualizar(Long id, TipoNovedadRrhhUpdateRequest request);

    TipoNovedadRrhhResponse desactivar(Long id);
}
