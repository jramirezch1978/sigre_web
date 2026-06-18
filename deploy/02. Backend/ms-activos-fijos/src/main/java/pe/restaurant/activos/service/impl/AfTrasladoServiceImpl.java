package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfTraslado;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfTrasladoRepository;
import pe.restaurant.activos.repository.AfUbicacionRepository;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.AfNumeracionService;
import pe.restaurant.activos.service.AfTrasladoService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfTrasladoServiceImpl implements AfTrasladoService {

    private static final String ESTADO_SOLICITUD  = "SOLICITUD";
    private static final String ESTADO_APROBADO   = "APROBADO";
    private static final String ESTADO_EJECUTADO  = "EJECUTADO";
    private static final String ESTADO_RECHAZADO  = "RECHAZADO";
    private static final String ESTADO_ANULADO    = "ANULADO";

    private final AfTrasladoRepository repository;
    private final AfMaestroRepository maestroRepository;
    private final AfUbicacionRepository ubicacionRepository;
    private final AfHistorialService historialService;
    private final AfNumeracionService numeracionService;
    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ContabilidadAutoContabilizador contabilidadAutoContabilizador;

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "findAll"})
    @Override
    public Page<AfTraslado> findAll(Pageable pageable) {
        log.info("Listando traslados - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfTraslado> page = repository.findAll(pageable);
        log.info("Traslados encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "findById"})
    @Override
    public AfTraslado findById(Long id) {
        log.info("Buscando traslado con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Traslado no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Traslado", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "create"})
    @Override
    @Transactional
    public AfTraslado create(AfTraslado entity) {
        log.info("Creando solicitud de traslado para activo: {}", entity.getAfMaestroId());

        AfMaestro activo = validarActivoParaTraslado(entity.getAfMaestroId());
        validarUbicaciones(entity.getUbicacionOrigenId(), entity.getUbicacionDestinoId());

        if (entity.getUbicacionOrigenId() == null) {
            entity.setUbicacionOrigenId(activo.getAfUbicacionId());
        }

        if (entity.getNumeroDocumento() == null || entity.getNumeroDocumento().isBlank()) {
            entity.setNumeroDocumento(numeracionService.generarSiguienteCodigo("TRASLADO").getCodigo());
        }

        entity.setEstado(ESTADO_SOLICITUD);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfTraslado saved = repository.save(entity);

        registrarHistorial(entity.getAfMaestroId(), "TRASLADO_SOLICITUD",
                "Solicitud de traslado creada", null, ESTADO_SOLICITUD);

        log.info("Solicitud de traslado creada con id: {} — estado: {}", saved.getId(), saved.getEstado());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "update"})
    @Override
    @Transactional
    public AfTraslado update(Long id, AfTraslado entity) {
        log.info("Actualizando traslado con id: {}", id);
        AfTraslado existing = findById(id);

        validarEstadoModificable(existing);
        validarUbicaciones(entity.getUbicacionOrigenId(), entity.getUbicacionDestinoId());

        existing.setUbicacionOrigenId(entity.getUbicacionOrigenId());
        existing.setUbicacionDestinoId(entity.getUbicacionDestinoId());
        existing.setFechaSolicitud(entity.getFechaSolicitud());
        existing.setFechaProgramada(entity.getFechaProgramada());
        existing.setMotivo(entity.getMotivo());
        existing.setCentroCostoOrigenId(entity.getCentroCostoOrigenId());
        existing.setCentroCostoDestinoId(entity.getCentroCostoDestinoId());
        existing.setNumeroDocumento(entity.getNumeroDocumento());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        AfTraslado updated = repository.save(existing);
        log.info("Traslado actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando traslado con id: {}", id);
        AfTraslado existing = findById(id);
        validarEstadoModificable(existing);
        repository.delete(existing);
        log.info("Traslado eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "findByActivo"})
    @Override
    public List<AfTraslado> findByActivo(Long activoId) {
        log.info("Listando traslados del activo: {}", activoId);
        List<AfTraslado> traslados = repository.findByAfMaestroId(activoId);
        log.info("Traslados encontrados para activo {}: {}", activoId, traslados.size());
        return traslados;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "aprobar"})
    @Override
    @Transactional
    public AfTraslado aprobar(Long id) {
        log.info("Aprobando traslado con id: {}", id);
        AfTraslado traslado = findById(id);

        if (!ESTADO_SOLICITUD.equals(traslado.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden aprobar traslados en estado SOLICITUD (actual: " + traslado.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.TRASLADO_ESTADO_INVALIDO);
        }

        traslado.setEstado(ESTADO_APROBADO);
        traslado.setAprobadorId(TenantContext.getUsuarioId());
        traslado.setFechaAprobacion(LocalDate.now());
        traslado.setUpdatedBy(TenantContext.getUsuarioId());
        AfTraslado aprobado = repository.save(traslado);

        registrarHistorial(traslado.getAfMaestroId(), "TRASLADO_APROBADO",
                "Traslado aprobado", ESTADO_SOLICITUD, ESTADO_APROBADO);

        log.info("Traslado aprobado exitosamente con id: {}", id);
        return aprobado;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "rechazar"})
    @Override
    @Transactional
    public AfTraslado rechazar(Long id, String comentario) {
        log.info("Rechazando traslado con id: {}", id);
        AfTraslado traslado = findById(id);

        if (!ESTADO_SOLICITUD.equals(traslado.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden rechazar traslados en estado SOLICITUD (actual: " + traslado.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.TRASLADO_ESTADO_INVALIDO);
        }

        traslado.setEstado(ESTADO_RECHAZADO);
        traslado.setComentarioRechazo(comentario);
        traslado.setAprobadorId(TenantContext.getUsuarioId());
        traslado.setFechaAprobacion(LocalDate.now());
        traslado.setUpdatedBy(TenantContext.getUsuarioId());
        AfTraslado rechazado = repository.save(traslado);

        registrarHistorial(traslado.getAfMaestroId(), "TRASLADO_RECHAZADO",
                "Traslado rechazado: " + (comentario != null ? comentario : ""), ESTADO_SOLICITUD, ESTADO_RECHAZADO);

        log.info("Traslado rechazado exitosamente con id: {}", id);
        return rechazado;
    }

    @Override
    @Transactional
    public AfTraslado rechazar(Long id) {
        return rechazar(id, null);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "ejecutar"})
    @Override
    @Transactional
    public AfTraslado ejecutar(Long id) {
        log.info("Ejecutando traslado con id: {}", id);
        AfTraslado traslado = findById(id);

        if (!ESTADO_APROBADO.equals(traslado.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden ejecutar traslados en estado APROBADO (actual: " + traslado.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.TRASLADO_NO_APROBADO);
        }

        AfMaestro activo = maestroRepository.findById(traslado.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", traslado.getAfMaestroId()));

        String ubicacionAnterior = String.valueOf(activo.getAfUbicacionId());
        activo.setAfUbicacionId(traslado.getUbicacionDestinoId());
        maestroRepository.save(activo);

        traslado.setEstado(ESTADO_EJECUTADO);
        traslado.setFechaEjecucion(LocalDate.now());
        traslado.setUpdatedBy(TenantContext.getUsuarioId());
        AfTraslado ejecutado = repository.save(traslado);

        registrarHistorial(traslado.getAfMaestroId(), "TRASLADO_EJECUTADO",
                "Traslado ejecutado — ubicación actualizada en maestro",
                ubicacionAnterior, String.valueOf(traslado.getUbicacionDestinoId()));

        log.info("Traslado ejecutado. Activo {} movido a ubicación: {}", traslado.getAfMaestroId(), traslado.getUbicacionDestinoId());
        contabilidadAutoContabilizador.ejecutarTrasladoSiAutomatico(
                "traslado",
                () -> contabilidadIntegracionService.contabilizarTraslado(ejecutado.getId()));
        return ejecutado;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "anular"})
    @Override
    @Transactional
    public AfTraslado anular(Long id) {
        log.info("Anulando traslado con id: {}", id);
        AfTraslado traslado = findById(id);

        if (ESTADO_EJECUTADO.equals(traslado.getEstado()) || ESTADO_ANULADO.equals(traslado.getEstado())) {
            throw new BusinessException(
                    "No se puede anular un traslado en estado " + traslado.getEstado(),
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.TRASLADO_ESTADO_INVALIDO);
        }

        String estadoAnterior = traslado.getEstado();
        traslado.setEstado(ESTADO_ANULADO);
        traslado.setUpdatedBy(TenantContext.getUsuarioId());
        AfTraslado anulado = repository.save(traslado);

        registrarHistorial(traslado.getAfMaestroId(), "TRASLADO_ANULADO",
                "Traslado anulado", estadoAnterior, ESTADO_ANULADO);

        log.info("Traslado anulado exitosamente con id: {}", id);
        return anulado;
    }

    private AfMaestro validarActivoParaTraslado(Long afMaestroId) {
        AfMaestro activo = maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new BusinessException(
                        "El activo con ID " + afMaestroId + " no existe en el sistema",
                        HttpStatus.NOT_FOUND, ActivosErrorCodes.MAESTRO_NO_ENCONTRADO));

        if (!"1".equals(activo.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden trasladar activos con flag_estado = '1' (actual: " + activo.getFlagEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.TRASLADO_ESTADO_INVALIDO);
        }
        return activo;
    }

    private void validarEstadoModificable(AfTraslado traslado) {
        if (ESTADO_EJECUTADO.equals(traslado.getEstado()) || ESTADO_ANULADO.equals(traslado.getEstado())) {
            throw new BusinessException(
                    "No se puede modificar un traslado en estado " + traslado.getEstado(),
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.TRASLADO_ESTADO_INVALIDO);
        }
    }

    private void validarUbicaciones(Long origenId, Long destinoId) {
        if (origenId != null && destinoId != null && origenId.equals(destinoId)) {
            throw new BusinessException(
                    "La ubicación de origen y destino no pueden ser la misma",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.UBICACIONES_IGUALES);
        }
        if (origenId != null) {
            ubicacionRepository.findById(origenId)
                    .orElseThrow(() -> new BusinessException(
                            "La ubicación de origen con ID " + origenId + " no existe",
                            HttpStatus.NOT_FOUND, ActivosErrorCodes.UBICACION_NO_ENCONTRADA));
        }
        if (destinoId != null) {
            ubicacionRepository.findById(destinoId)
                    .orElseThrow(() -> new BusinessException(
                            "La ubicación de destino con ID " + destinoId + " no existe",
                            HttpStatus.NOT_FOUND, ActivosErrorCodes.UBICACION_NO_ENCONTRADA));
        }
    }

    private void registrarHistorial(Long afMaestroId, String tipoEvento, String descripcion,
                                    String valorAnterior, String valorNuevo) {
        AfHistorial historial = new AfHistorial();
        historial.setAfMaestroId(afMaestroId);
        historial.setTipoEvento(tipoEvento);
        historial.setDescripcion(descripcion);
        historial.setValorAnterior(valorAnterior);
        historial.setValorNuevo(valorNuevo);
        historial.setUsuarioId(TenantContext.getUsuarioId());
        historial.setFechaEvento(LocalDateTime.now());
        historial.setModulo("TRASLADOS");
        historialService.create(historial);
    }
}
