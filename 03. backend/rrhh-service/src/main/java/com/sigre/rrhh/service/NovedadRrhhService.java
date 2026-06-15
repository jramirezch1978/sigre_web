package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.NovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhDetRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.NovedadRrhhDetResponse;
import com.sigre.rrhh.dto.response.NovedadRrhhResponse;
import java.time.LocalDate;
import java.util.List;

public interface NovedadRrhhService {
    Page<NovedadRrhhResponse> listar(Long trabajadorId, Long tipoNovedadRrhhId, LocalDate fechaDesde,
                                      LocalDate fechaHasta, String flagEstado, Pageable pageable);
    NovedadRrhhResponse obtenerPorId(Long id);
    NovedadRrhhResponse crear(NovedadRrhhCreateRequest request);
    NovedadRrhhResponse actualizar(Long id, NovedadRrhhUpdateRequest request);
    NovedadRrhhResponse desactivar(Long id);
    List<NovedadRrhhDetResponse> listarDetalles(Long novedadId);
    NovedadRrhhDetResponse crearDetalle(Long novedadId, NovedadRrhhDetRequest request);
    void eliminarDetalle(Long novedadId, Long detalleId);
}
