package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.HttpStatus;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.PermisoLicenciaCreateRequest;
import com.sigre.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import com.sigre.rrhh.dto.response.PermisoLicenciaResponse;
import com.sigre.rrhh.entity.PermisoLicencia;
import com.sigre.rrhh.mapper.PermisoLicenciaMapper;
import com.sigre.rrhh.repository.PermisoLicenciaRepository;
import com.sigre.rrhh.service.PermisoLicenciaService;
import com.sigre.rrhh.specification.PermisoLicenciaSpecification;
import com.sigre.rrhh.util.RrhhFlagEstadoLegacyNormalizer;
import com.sigre.rrhh.validation.PermisoLicenciaValidator;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

import static com.sigre.rrhh.constants.PermisoLicenciaConstants.*;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PermisoLicenciaServiceImpl implements PermisoLicenciaService {

    private final PermisoLicenciaRepository repository;
    private final PermisoLicenciaMapper mapper;
    private final PermisoLicenciaValidator validator;

    @Override
    @Timed(value = "rrhh.permisoLicencia.listar", description = "Tiempo listado permisos")
    public Page<PermisoLicenciaResponse> listar(Long trabajadorId, LocalDate fechaDesde, LocalDate fechaHasta,
                                                 String flagEstado, Pageable pageable) {
        log.info("Listando permisos/licencias - trabajadorId: {}, fechas: {} -> {}, flagEstado: {}",
                trabajadorId, fechaDesde, fechaHasta, flagEstado);
        var spec = PermisoLicenciaSpecification.filtros(trabajadorId, fechaDesde, fechaHasta, flagEstado);
        return repository.findAll(spec, pageable)
                .map(e -> mapper.toResponse(RrhhFlagEstadoLegacyNormalizer.normalizePermiso(e)));
    }

    @Override
    @Timed(value = "rrhh.permisoLicencia.obtener", description = "Tiempo obtener permiso")
    public PermisoLicenciaResponse obtenerPorId(Long id) {
        log.info("Obteniendo permiso/licencia por id: {}", id);
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.crear", description = "Tiempo crear permiso")
    public PermisoLicenciaResponse crear(PermisoLicenciaCreateRequest request) {
        log.info("Creando permiso/licencia para trabajador: {}", request.getTrabajadorId());
        validator.validarTrabajador(request.getTrabajadorId());
        validator.validarTipoSuspension(request.getTipoSuspensionLaboralId());
        validator.validarFechas(request.getFechaInicio(), request.getFechaFin());
        validator.validarSinSolapamiento(request.getTrabajadorId(), request.getFechaInicio(),
                request.getFechaFin(), null);
        var entity = mapper.toEntity(request);
        entity.setFlagEstado(ESTADO_SOLICITADO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.actualizar", description = "Tiempo actualizar permiso")
    public PermisoLicenciaResponse actualizar(Long id, PermisoLicenciaUpdateRequest request) {
        log.info("Actualizando permiso/licencia id: {}", id);
        var existing = buscarOrThrow(id);
        validarEstadoModificable(existing);
        if (request.getTipoSuspensionLaboralId() != null) {
            validator.validarTipoSuspension(request.getTipoSuspensionLaboralId());
        }
        LocalDate fechaInicio = request.getFechaInicio() != null ? request.getFechaInicio() : existing.getFechaInicio();
        LocalDate fechaFin = request.getFechaFin() != null ? request.getFechaFin() : existing.getFechaFin();
        validator.validarFechas(fechaInicio, fechaFin);
        if (request.getFechaInicio() != null || request.getFechaFin() != null) {
            validator.validarSinSolapamiento(existing.getTrabajadorId(), fechaInicio, fechaFin, id);
        }
        mapper.updateEntity(existing, request);
        if (request.getFlagEstado() != null) {
            existing.setFlagEstado(RrhhFlagEstadoLegacyNormalizer.normalizePermisoFlag(request.getFlagEstado()));
        }
        RrhhFlagEstadoLegacyNormalizer.normalizePermiso(existing);
        return mapper.toResponse(repository.save(existing));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.aprobar", description = "Tiempo aprobar permiso")
    public PermisoLicenciaResponse aprobar(Long id) {
        var entity = buscarOrThrow(id);
        validarEstadoModificable(entity);
        entity.setFlagEstado(ESTADO_APROBADO);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(java.time.Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.rechazar", description = "Tiempo rechazar permiso")
    public PermisoLicenciaResponse rechazar(Long id) {
        var entity = buscarOrThrow(id);
        validarEstadoModificable(entity);
        entity.setFlagEstado(ESTADO_RECHAZADO);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(java.time.Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.desactivar", description = "Tiempo desactivar permiso")
    public PermisoLicenciaResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado(ESTADO_RECHAZADO);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Timed(value = "rrhh.permisoLicencia.bandeja", description = "Tiempo listar bandeja")
    public List<PermisoLicenciaResponse> listarBandeja() {
        log.info("Listando bandeja de permisos pendientes");
        var pendientes = repository.findByFlagEstadoIn(
                RrhhFlagEstadoLegacyNormalizer.permisoFlagEstadosParaFiltro(ESTADO_SOLICITADO));
        pendientes.forEach(RrhhFlagEstadoLegacyNormalizer::normalizePermiso);
        return mapper.toResponseList(pendientes);
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.observar", description = "Tiempo observar permiso")
    public PermisoLicenciaResponse observar(Long id) {
        var entity = buscarOrThrow(id);
        validarEstadoPendiente(entity);
        entity.setFlagEstado(ESTADO_OBSERVADO);
        log.info("Permiso {} observado", id);
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.anular", description = "Tiempo anular permiso")
    public PermisoLicenciaResponse anular(Long id) {
        var entity = buscarOrThrow(id);
        validarEstadoPendiente(entity);
        entity.setFlagEstado(ESTADO_ANULADO);
        log.info("Permiso {} anulado", id);
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.cerrar", description = "Tiempo cerrar permiso")
    public PermisoLicenciaResponse cerrar(Long id) {
        var entity = buscarOrThrow(id);
        if (!ESTADO_APROBADO.equals(entity.getFlagEstado())) {
            throw new BusinessException("Solo se puede cerrar un permiso aprobado.",
                    HttpStatus.CONFLICT, ERROR_TRANSICION_INVALIDA);
        }
        entity.setFlagEstado(ESTADO_CERRADO);
        log.info("Permiso {} cerrado", id);
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.procesar", description = "Tiempo procesar permiso")
    public PermisoLicenciaResponse procesar(Long id) {
        var entity = buscarOrThrow(id);
        if (!ESTADO_APROBADO.equals(entity.getFlagEstado())) {
            throw new BusinessException("Solo se puede procesar un permiso aprobado.",
                    HttpStatus.CONFLICT, ERROR_TRANSICION_INVALIDA);
        }
        entity.setFlagEstado(ESTADO_PROCESADO);
        log.info("Permiso {} procesado para planilla", id);
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.enviarPlanilla", description = "Tiempo enviar a planilla")
    public PermisoLicenciaResponse enviarPlanilla(Long id) {
        var entity = buscarOrThrow(id);
        if (!ESTADO_PROCESADO.equals(entity.getFlagEstado())) {
            throw new BusinessException("El permiso debe estar procesado antes de enviar a planilla.",
                    HttpStatus.CONFLICT, ERROR_TRANSICION_INVALIDA);
        }
        entity.setFlagEstado(ESTADO_EN_PLANILLA);
        log.info("Permiso {} enviado a planilla", id);
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.procesarBatch", description = "Tiempo procesar batch permisos")
    public void procesarBatch() {
        var estadosBatch = new java.util.ArrayList<>(RrhhFlagEstadoLegacyNormalizer.permisoFlagEstadosParaFiltro(ESTADO_APROBADO));
        estadosBatch.addAll(RrhhFlagEstadoLegacyNormalizer.permisoFlagEstadosParaFiltro(ESTADO_SOLICITADO));
        List<PermisoLicencia> aprobados = repository.findByFlagEstadoIn(estadosBatch.stream().distinct().toList());
        for (PermisoLicencia p : aprobados) {
            RrhhFlagEstadoLegacyNormalizer.normalizePermiso(p);
            p.setFlagEstado(ESTADO_PROCESADO);
            p.setUpdatedBy(TenantContext.getUsuarioId());
            p.setFecModificacion(Instant.now());
        }
        repository.saveAll(aprobados);
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.permisoLicencia.reflejarBoleta", description = "Tiempo reflejar en boleta")
    public PermisoLicenciaResponse reflejarBoleta(Long id) {
        var entity = buscarOrThrow(id);
        if (!ESTADO_EN_PLANILLA.equals(entity.getFlagEstado())) {
            throw new BusinessException("El permiso debe estar en planilla antes de reflejar en boleta.",
                    HttpStatus.CONFLICT, ERROR_TRANSICION_INVALIDA);
        }
        entity.setFlagEstado(ESTADO_REF_BOLETA);
        log.info("Permiso {} reflejado en boleta", id);
        return mapper.toResponse(repository.save(entity));
    }

    private PermisoLicencia buscarOrThrow(Long id) {
        return repository.findById(id)
                .map(RrhhFlagEstadoLegacyNormalizer::normalizePermiso)
                .orElseThrow(() -> {
                    log.warn("Permiso/Licencia no encontrado: {}", id);
                    return new ResourceNotFoundException("PermisoLicencia", id);
                });
    }

    private void validarEstadoModificable(PermisoLicencia entity) {
        if (ESTADO_APROBADO.equals(entity.getFlagEstado()) || ESTADO_RECHAZADO.equals(entity.getFlagEstado())) {
            log.warn("Permiso {} ya está aprobado o rechazado (flagEstado={})", entity.getId(), entity.getFlagEstado());
            throw new BusinessException(MSG_YA_APROBADO_RECHAZADO,
                    HttpStatus.CONFLICT, ERROR_YA_APROBADO_RECHAZADO);
        }
    }

    private void validarEstadoPendiente(PermisoLicencia entity) {
        if (!ESTADO_SOLICITADO.equals(entity.getFlagEstado())) {
            log.warn("Permiso {} no está pendiente (flagEstado={})", entity.getId(), entity.getFlagEstado());
            throw new BusinessException("El permiso no está en estado pendiente.",
                    HttpStatus.CONFLICT, ERROR_TRANSICION_INVALIDA);
        }
    }
}
