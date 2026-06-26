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
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.AfTrasladoService;
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

    private final AfTrasladoRepository repository;
    private final AfMaestroRepository maestroRepository;
    private final AfUbicacionRepository ubicacionRepository;
    private final AfHistorialService historialService;

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

        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfTraslado saved = repository.save(entity);

        registrarHistorial(entity.getAfMaestroId(), "TRASLADO_SOLICITUD",
                "Solicitud de traslado creada", null, null);

        log.info("Solicitud de traslado creada con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "update"})
    @Override
    @Transactional
    public AfTraslado update(Long id, AfTraslado entity) {
        log.info("Actualizando traslado con id: {}", id);
        AfTraslado existing = findById(id);

        validarUbicaciones(entity.getUbicacionOrigenId(), entity.getUbicacionDestinoId());

        existing.setUbicacionOrigenId(entity.getUbicacionOrigenId());
        existing.setUbicacionDestinoId(entity.getUbicacionDestinoId());
        existing.setFechaSolicitud(entity.getFechaSolicitud());
        existing.setMotivo(entity.getMotivo());
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

    @Timed(value = "app.db.query", extraTags = {"table", "af_traslado", "operation", "ejecutar"})
    @Override
    @Transactional
    public AfTraslado ejecutar(Long id) {
        log.info("Ejecutando traslado con id: {}", id);
        AfTraslado traslado = findById(id);

        AfMaestro activo = maestroRepository.findById(traslado.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", traslado.getAfMaestroId()));

        String ubicacionAnterior = String.valueOf(activo.getAfUbicacionId());
        activo.setAfUbicacionId(traslado.getUbicacionDestinoId());
        maestroRepository.save(activo);

        traslado.setFechaEjecucion(LocalDate.now());
        traslado.setUpdatedBy(TenantContext.getUsuarioId());
        AfTraslado ejecutado = repository.save(traslado);

        registrarHistorial(traslado.getAfMaestroId(), "TRASLADO_EJECUTADO",
                "Traslado ejecutado — ubicación actualizada en maestro",
                ubicacionAnterior, String.valueOf(traslado.getUbicacionDestinoId()));

        log.info("Traslado ejecutado. Activo {} movido a ubicación: {}", traslado.getAfMaestroId(), traslado.getUbicacionDestinoId());
        return ejecutado;
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
