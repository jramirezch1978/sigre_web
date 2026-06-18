package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.repository.AfAdaptacionRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.AfAdaptacionService;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
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
public class AfAdaptacionServiceImpl implements AfAdaptacionService {

    private static final String ESTADO_REGISTRADO   = "REGISTRADO";
    private static final String ESTADO_VALIDADO     = "VALIDADO";
    private static final String ESTADO_CAPITALIZADO = "CAPITALIZADO";
    private static final String ESTADO_ANULADO      = "ANULADO";

    private final AfAdaptacionRepository repository;
    private final AfMaestroRepository maestroRepository;
    private final AfHistorialService historialService;
    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ContabilidadAutoContabilizador contabilidadAutoContabilizador;

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "findAll"})
    @Override
    public Page<AfAdaptacion> findAll(Pageable pageable) {
        log.info("Listando adaptaciones - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfAdaptacion> page = repository.findAll(pageable);
        log.info("Adaptaciones encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "findById"})
    @Override
    public AfAdaptacion findById(Long id) {
        log.info("Buscando adaptación con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Adaptación no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Adaptación", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "create"})
    @Override
    @Transactional
    public AfAdaptacion create(AfAdaptacion entity) {
        log.info("Creando adaptación para activo: {}", entity.getAfMaestroId());

        validarActivoExistente(entity.getAfMaestroId());

        entity.setEstado(ESTADO_REGISTRADO);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());

        AfAdaptacion saved = repository.save(entity);

        registrarHistorial(entity.getAfMaestroId(), "ADAPTACION_REGISTRADA",
                "Adaptación registrada por " + entity.getMontoTotal(), null, ESTADO_REGISTRADO);

        log.info("Adaptación creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "update"})
    @Override
    @Transactional
    public AfAdaptacion update(Long id, AfAdaptacion entity) {
        log.info("Actualizando adaptación con id: {}", id);
        AfAdaptacion existing = findById(id);

        if (ESTADO_CAPITALIZADO.equals(existing.getEstado())) {
            throw new BusinessException(
                    "No se puede modificar una adaptación capitalizada",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.ADAPTACION_CAPITALIZADA);
        }

        if (!existing.getAfMaestroId().equals(entity.getAfMaestroId())) {
            validarActivoExistente(entity.getAfMaestroId());
        }

        existing.setAfMaestroId(entity.getAfMaestroId());
        existing.setFecha(entity.getFecha());
        existing.setDescripcion(entity.getDescripcion());
        existing.setMontoTotal(entity.getMontoTotal());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        AfAdaptacion updated = repository.save(existing);
        log.info("Adaptación actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando adaptación con id: {}", id);
        AfAdaptacion existing = findById(id);
        if (ESTADO_CAPITALIZADO.equals(existing.getEstado())) {
            throw new BusinessException(
                    "No se puede eliminar una adaptación capitalizada",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.ADAPTACION_CAPITALIZADA);
        }
        repository.delete(existing);
        log.info("Adaptación eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "findByActivo"})
    @Override
    public List<AfAdaptacion> findByActivo(Long activoId) {
        log.info("Listando adaptaciones del activo: {}", activoId);
        List<AfAdaptacion> adaptaciones = repository.findByAfMaestroId(activoId);
        log.info("Adaptaciones encontradas para activo {}: {}", activoId, adaptaciones.size());
        return adaptaciones;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "findByFechaRange"})
    @Override
    public List<AfAdaptacion> findByFechaRange(LocalDate fechaInicio, LocalDate fechaFin) {
        log.info("Listando adaptaciones entre {} y {}", fechaInicio, fechaFin);
        List<AfAdaptacion> adaptaciones = repository.findByFechaRange(fechaInicio, fechaFin);
        log.info("Adaptaciones encontradas en rango: {}", adaptaciones.size());
        return adaptaciones;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "validar"})
    @Override
    @Transactional
    public AfAdaptacion validar(Long id) {
        log.info("Validando adaptación con id: {}", id);
        AfAdaptacion adaptacion = findById(id);

        if (!ESTADO_REGISTRADO.equals(adaptacion.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden validar adaptaciones en estado REGISTRADO (actual: " + adaptacion.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.ADAPTACION_CAPITALIZADA);
        }

        adaptacion.setEstado(ESTADO_VALIDADO);
        adaptacion.setUpdatedBy(TenantContext.getUsuarioId());
        AfAdaptacion validada = repository.save(adaptacion);

        registrarHistorial(adaptacion.getAfMaestroId(), "ADAPTACION_VALIDADA",
                "Adaptación validada", ESTADO_REGISTRADO, ESTADO_VALIDADO);

        log.info("Adaptación validada exitosamente con id: {}", id);
        return validada;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "capitalizar"})
    @Override
    @Transactional
    public AfAdaptacion capitalizar(Long id) {
        log.info("Capitalizando adaptación con id: {}", id);
        AfAdaptacion adaptacion = findById(id);

        if (ESTADO_CAPITALIZADO.equals(adaptacion.getEstado())) {
            throw new BusinessException("La adaptación ya fue capitalizada",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.ADAPTACION_YA_CAPITALIZADA);
        }

        if (adaptacion.getMontoTotal() == null || adaptacion.getMontoTotal().compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("El monto total debe ser mayor a cero para capitalizar",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.MONTO_INVALIDO_CAPITALIZACION);
        }

        AfMaestro activo = maestroRepository.findById(adaptacion.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", adaptacion.getAfMaestroId()));

        BigDecimal valorAnterior = activo.getValorAdquisicion();
        BigDecimal nuevoValor = valorAnterior.add(adaptacion.getMontoTotal());
        activo.setValorAdquisicion(nuevoValor);
        maestroRepository.save(activo);

        adaptacion.setEstado(ESTADO_CAPITALIZADO);
        adaptacion.setUpdatedBy(TenantContext.getUsuarioId());
        AfAdaptacion capitalizada = repository.save(adaptacion);

        registrarHistorial(adaptacion.getAfMaestroId(), "ADAPTACION_CAPITALIZADA",
                "Adaptación capitalizada — base depreciable actualizada de " + valorAnterior + " a " + nuevoValor,
                valorAnterior.toPlainString(), nuevoValor.toPlainString());

        log.info("Adaptación capitalizada. Activo {} — valor anterior: {}, nuevo: {}", activo.getId(), valorAnterior, nuevoValor);
        contabilidadAutoContabilizador.ejecutarSiAutomatico(
                "adaptacion",
                () -> contabilidadIntegracionService.contabilizarAdaptacion(capitalizada.getId()));
        return capitalizada;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion", "operation", "obtenerTotalCapitalizado"})
    @Override
    public BigDecimal obtenerTotalCapitalizado(Long activoId) {
        log.info("Obteniendo total capitalizado para activo: {}", activoId);
        BigDecimal total = repository.obtenerTotalCapitalizado(activoId);
        BigDecimal resultado = (total != null) ? total : BigDecimal.ZERO;
        log.info("Total capitalizado para activo {}: {}", activoId, resultado);
        return resultado;
    }

    private void validarActivoExistente(Long afMaestroId) {
        AfMaestro activo = maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new BusinessException(
                        "El activo con ID " + afMaestroId + " no existe en el sistema",
                        HttpStatus.NOT_FOUND, ActivosErrorCodes.MAESTRO_NO_ENCONTRADO));

        if (!"1".equals(activo.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden registrar adaptaciones en activos con flag_estado = '1'",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.ACTIVO_INACTIVO_ADAPTACION);
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
        historial.setModulo("ADAPTACIONES");
        historialService.create(historial);
    }
}
