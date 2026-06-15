package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.PermisoLicenciaCreateRequest;
import com.sigre.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import com.sigre.rrhh.dto.response.PermisoLicenciaResponse;
import java.time.LocalDate;
import java.util.List;

public interface PermisoLicenciaService {

    Page<PermisoLicenciaResponse> listar(Long trabajadorId, LocalDate fechaDesde, LocalDate fechaHasta,
                                         String flagEstado, Pageable pageable);

    PermisoLicenciaResponse obtenerPorId(Long id);

    PermisoLicenciaResponse crear(PermisoLicenciaCreateRequest request);

    PermisoLicenciaResponse actualizar(Long id, PermisoLicenciaUpdateRequest request);

    PermisoLicenciaResponse aprobar(Long id);

    PermisoLicenciaResponse rechazar(Long id);

    PermisoLicenciaResponse desactivar(Long id);

    List<PermisoLicenciaResponse> listarBandeja();

    PermisoLicenciaResponse observar(Long id);

    PermisoLicenciaResponse anular(Long id);

    PermisoLicenciaResponse cerrar(Long id);

    PermisoLicenciaResponse procesar(Long id);

    void procesarBatch();

    PermisoLicenciaResponse enviarPlanilla(Long id);

    PermisoLicenciaResponse reflejarBoleta(Long id);
}
