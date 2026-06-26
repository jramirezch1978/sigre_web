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
import pe.restaurant.activos.entity.AfValuacion;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfValuacionRepository;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.AfValuacionService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfValuacionServiceImpl implements AfValuacionService {

    private static final String ESTADO_EN_PROCESO     = "EN_PROCESO";
    private static final String ESTADO_VALIDADO       = "VALIDADO";
    private static final String ESTADO_APROBADO       = "APROBADO";
    private static final String ESTADO_CONTABILIZADO  = "CONTABILIZADO";
    private static final String ESTADO_ANULADO        = "ANULADO";

    private final AfValuacionRepository repository;
    private final AfMaestroRepository maestroRepository;
    private final AfHistorialService historialService;
    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ContabilidadAutoContabilizador contabilidadAutoContabilizador;

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "findAll"})
    @Override
    public Page<AfValuacion> findAll(Pageable pageable) {
        log.info("Listando valuaciones - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "findById"})
    @Override
    public AfValuacion findById(Long id) {
        log.info("Buscando valuación con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Valuación", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "create"})
    @Override
    @Transactional
    public AfValuacion create(AfValuacion entity) {
        log.info("Creando valuación para activo: {}", entity.getAfMaestroId());

        validarActivoParaRevaluacion(entity.getAfMaestroId());
        validarNoExisteEnProceso(entity.getAfMaestroId());

        entity.setEstado(ESTADO_EN_PROCESO);
        entity.setCreatedBy(TenantContext.getUsuarioId());

        AfValuacion saved = repository.save(entity);

        registrarHistorial(entity.getAfMaestroId(), "VALUACION_CREADA",
                "Valuación registrada — método: " + entity.getMetodoValuacion() +
                        ", valor anterior: " + entity.getValorAnterior() + ", valor nuevo: " + entity.getValorNuevo(),
                entity.getValorAnterior().toPlainString(), entity.getValorNuevo().toPlainString());

        log.info("Valuación creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "update"})
    @Override
    @Transactional
    public AfValuacion update(Long id, AfValuacion entity) {
        log.info("Actualizando valuación con id: {}", id);
        AfValuacion existing = findById(id);

        if (!ESTADO_EN_PROCESO.equals(existing.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden modificar valuaciones en estado EN_PROCESO (actual: " + existing.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        existing.setFechaValuacion(entity.getFechaValuacion());
        existing.setValorAnterior(entity.getValorAnterior());
        existing.setValorNuevo(entity.getValorNuevo());
        existing.setMetodoValuacion(entity.getMetodoValuacion());
        existing.setObservaciones(entity.getObservaciones());
        existing.setTipoRevaluacion(entity.getTipoRevaluacion());
        existing.setFuenteRevaluacion(entity.getFuenteRevaluacion());
        existing.setFactorRevaluacion(entity.getFactorRevaluacion());
        existing.setDocumentoSoporte(entity.getDocumentoSoporte());
        existing.setNuevaVidaUtil(entity.getNuevaVidaUtil());
        existing.setValorResidual(entity.getValorResidual());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        AfValuacion updated = repository.save(existing);
        log.info("Valuación actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando valuación con id: {}", id);
        AfValuacion existing = findById(id);

        if (!ESTADO_EN_PROCESO.equals(existing.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden eliminar valuaciones en estado EN_PROCESO",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        repository.delete(existing);
        log.info("Valuación eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "findByActivo"})
    @Override
    public List<AfValuacion> findByActivo(Long activoId) {
        log.info("Listando valuaciones del activo: {}", activoId);
        return repository.findByAfMaestroIdOrderByFechaValuacionDesc(activoId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "findByPeriodo"})
    @Override
    public List<AfValuacion> findByPeriodo(LocalDate fechaInicio, LocalDate fechaFin) {
        log.info("Listando valuaciones entre {} y {}", fechaInicio, fechaFin);
        return repository.findByPeriodo(fechaInicio, fechaFin);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "validar"})
    @Override
    @Transactional
    public AfValuacion validar(Long id) {
        log.info("Validando valuación con id: {}", id);
        AfValuacion valuacion = findById(id);

        if (!ESTADO_EN_PROCESO.equals(valuacion.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden validar valuaciones en estado EN_PROCESO (actual: " + valuacion.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        valuacion.setEstado(ESTADO_VALIDADO);
        valuacion.setUpdatedBy(TenantContext.getUsuarioId());
        AfValuacion validada = repository.save(valuacion);

        registrarHistorial(valuacion.getAfMaestroId(), "VALUACION_VALIDADA",
                "Valuación validada", ESTADO_EN_PROCESO, ESTADO_VALIDADO);

        log.info("Valuación validada exitosamente con id: {}", id);
        return validada;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "aprobar"})
    @Override
    @Transactional
    public AfValuacion aprobar(Long id) {
        log.info("Aprobando valuación con id: {}", id);
        AfValuacion valuacion = findById(id);

        if (!ESTADO_VALIDADO.equals(valuacion.getEstado()) && !ESTADO_EN_PROCESO.equals(valuacion.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden aprobar valuaciones en estado VALIDADO o EN_PROCESO (actual: " + valuacion.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        AfMaestro activo = maestroRepository.findById(valuacion.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", valuacion.getAfMaestroId()));

        BigDecimal valorAnterior = activo.getValorAdquisicion();
        activo.setValorAdquisicion(valuacion.getValorNuevo());

        if (valuacion.getValorResidual() != null) {
            activo.setValorResidual(valuacion.getValorResidual());
        }

        maestroRepository.save(activo);

        valuacion.setEstado(ESTADO_APROBADO);
        valuacion.setFechaAprobacion(LocalDate.now());
        valuacion.setAprobadorId(TenantContext.getUsuarioId());
        valuacion.setUpdatedBy(TenantContext.getUsuarioId());
        AfValuacion aprobada = repository.save(valuacion);

        registrarHistorial(valuacion.getAfMaestroId(), "VALUACION_APROBADA",
                "Valuación aprobada — valor del activo actualizado de " + valorAnterior + " a " + valuacion.getValorNuevo(),
                valorAnterior.toPlainString(), valuacion.getValorNuevo().toPlainString());

        log.info("Valuación aprobada. Activo {} — valor actualizado: {} → {}", activo.getId(), valorAnterior, valuacion.getValorNuevo());
        BigDecimal delta = valuacion.getValorNuevo().subtract(valuacion.getValorAnterior());
        if (delta.compareTo(BigDecimal.ZERO) != 0) {
            contabilidadAutoContabilizador.ejecutarSiAutomatico(
                    "valuacion",
                    () -> {
                        contabilidadIntegracionService.contabilizarValuacion(aprobada.getId());
                        aprobada.setEstado(ESTADO_CONTABILIZADO);
                        repository.save(aprobada);
                    });
        }
        return aprobada;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_valuacion", "operation", "anular"})
    @Override
    @Transactional
    public AfValuacion anular(Long id) {
        log.info("Anulando valuación con id: {}", id);
        AfValuacion valuacion = findById(id);

        if (ESTADO_CONTABILIZADO.equals(valuacion.getEstado())) {
            throw new BusinessException(
                    "No se puede anular una valuación contabilizada",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        String estadoAnterior = valuacion.getEstado();
        valuacion.setEstado(ESTADO_ANULADO);
        valuacion.setUpdatedBy(TenantContext.getUsuarioId());
        AfValuacion anulada = repository.save(valuacion);

        registrarHistorial(valuacion.getAfMaestroId(), "VALUACION_ANULADA",
                "Valuación anulada", estadoAnterior, ESTADO_ANULADO);

        log.info("Valuación anulada exitosamente con id: {}", id);
        return anulada;
    }

    private void validarActivoParaRevaluacion(Long afMaestroId) {
        AfMaestro activo = maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new BusinessException(
                        "El activo con ID " + afMaestroId + " no existe en el sistema",
                        HttpStatus.NOT_FOUND, ActivosErrorCodes.MAESTRO_NO_ENCONTRADO));

        if (!"1".equals(activo.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden revaluar activos con flag_estado = '1'",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }
    }

    private void validarNoExisteEnProceso(Long afMaestroId) {
        List<AfValuacion> enProceso = repository.findByAfMaestroIdOrderByFechaValuacionDesc(afMaestroId);
        boolean tieneEnProceso = enProceso.stream()
                .anyMatch(v -> ESTADO_EN_PROCESO.equals(v.getEstado()) || ESTADO_VALIDADO.equals(v.getEstado()));
        if (tieneEnProceso) {
            throw new BusinessException(
                    "Ya existe una valuación en proceso para el activo " + afMaestroId,
                    HttpStatus.CONFLICT, ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
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
        historial.setModulo("VALUACIONES");
        historialService.create(historial);
    }
}
