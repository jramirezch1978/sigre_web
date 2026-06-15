package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.AsistenciaImportarRequest;
import com.sigre.rrhh.dto.request.AsistenciaRegularizarRequest;
import com.sigre.rrhh.dto.response.AsistenciaResponse;
import com.sigre.rrhh.entity.Asistencia;

import java.time.LocalDate;
import java.util.List;

public interface AsistenciaService {

    Page<Asistencia> listar(Long trabajadorId, LocalDate fechaDesde, LocalDate fechaHasta,
                            Long tipoMovAsistenciaId, Pageable pageable);

    Asistencia obtenerPorId(Long id);

    Asistencia crear(Asistencia asistencia);

    Asistencia actualizar(Long id, Asistencia datos);

    void anular(Long id);

    Asistencia aprobar(Long id);

    Asistencia rechazar(Long id);

    Asistencia regularizar(Long id, AsistenciaRegularizarRequest request);

    AsistenciaResponse desactivar(Long id);

    void procesarPeriodo(LocalDate fechaDesde, LocalDate fechaHasta);

    List<AsistenciaResponse> importar(AsistenciaImportarRequest request);

    byte[] exportarExcel(LocalDate fechaDesde, LocalDate fechaHasta);
}
