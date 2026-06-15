package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.AlmacenTipoMovResponse;

public interface AlmacenTipoMovService {

    Page<AlmacenTipoMovResponse> listarPorAlmacen(Long almacenId, Pageable pageable, String flagEstado, String tipoMov);

    AlmacenTipoMovResponse asignar(Long almacenId, Long articuloMovTipoId);

    void desasignar(Long almacenId, Long articuloMovTipoId);
}
