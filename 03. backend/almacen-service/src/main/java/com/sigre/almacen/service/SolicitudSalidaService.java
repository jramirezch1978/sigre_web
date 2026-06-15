package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.SolSalidaRequest;
import com.sigre.almacen.dto.SolSalidaResponse;

public interface SolicitudSalidaService {

    Page<SolSalidaResponse> buscar(Long almacenId, String estado, Pageable pageable);

    SolSalidaResponse obtener(Long id);

    SolSalidaResponse crear(SolSalidaRequest request);

    SolSalidaResponse actualizar(Long id, SolSalidaRequest request);

    void eliminar(Long id);

    SolSalidaResponse cambiarEstado(Long id, String nuevoEstado);
}
