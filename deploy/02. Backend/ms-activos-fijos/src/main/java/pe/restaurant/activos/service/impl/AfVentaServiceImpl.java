package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfVenta;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfVentaRepository;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.AfVentaService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfVentaServiceImpl implements AfVentaService {

    private static final String ESTADO_EN_PROCESO     = "EN_PROCESO";
    private static final String ESTADO_CONTABILIZADO  = "CONTABILIZADO";
    private static final String ESTADO_CERRADO        = "CERRADO";
    private static final String ESTADO_ANULADO        = "ANULADO";

    private final AfVentaRepository repository;
    private final AfMaestroRepository maestroRepository;
    private final AfCalculoCntblRepository calculoRepository;
    private final AfHistorialService historialService;
    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ContabilidadAutoContabilizador contabilidadAutoContabilizador;

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "findAll"})
    @Override
    public Page<AfVenta> findAll(Pageable pageable) {
        log.info("Listando ventas - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfVenta> page = repository.findAll(pageable);
        log.info("Ventas encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "findById"})
    @Override
    public AfVenta findById(Long id) {
        log.info("Buscando venta con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Venta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Venta", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "create"})
    @Override
    @Transactional
    public AfVenta create(AfVenta entity) {
        log.info("Creando baja para activo: {} — tipo: {}", entity.getAfMaestroId(), entity.getTipoBaja());

        AfMaestro activo = validarActivoParaBaja(entity.getAfMaestroId());
        validarActivoNoBajado(entity.getAfMaestroId());

        BigDecimal depAcumulada = obtenerDepreciacionAcumulada(entity.getAfMaestroId());
        BigDecimal valorNeto = activo.getValorAdquisicion().subtract(depAcumulada);

        entity.setDepreciacionAcumulada(depAcumulada);
        entity.setValorNetoContable(valorNeto);

        BigDecimal ingresoVenta = entity.getValorVenta() != null ? entity.getValorVenta() : BigDecimal.ZERO;
        if ("SINIESTRO".equals(entity.getTipoBaja()) || "OBSOLESCENCIA".equals(entity.getTipoBaja())) {
            BigDecimal indemnizacion = entity.getMontoIndemnizacion() != null ? entity.getMontoIndemnizacion() : BigDecimal.ZERO;
            entity.setResultadoBaja(indemnizacion.subtract(valorNeto));
        } else {
            entity.setResultadoBaja(ingresoVenta.subtract(valorNeto));
        }

        entity.setEstado(ESTADO_EN_PROCESO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfVenta saved = repository.save(entity);

        registrarHistorial(entity.getAfMaestroId(), "BAJA_REGISTRADA",
                "Baja registrada — tipo: " + entity.getTipoBaja() +
                        ", valor neto: " + valorNeto + ", resultado: " + entity.getResultadoBaja(),
                activo.getFlagEstado(), ESTADO_EN_PROCESO);

        log.info("Baja creada con id: {} — resultado: {}", saved.getId(), entity.getResultadoBaja());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "update"})
    @Override
    @Transactional
    public AfVenta update(Long id, AfVenta entity) {
        log.info("Actualizando venta con id: {}", id);
        AfVenta existing = findById(id);

        if (!ESTADO_EN_PROCESO.equals(existing.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden modificar bajas en estado EN_PROCESO (actual: " + existing.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VENTA_ESTADO_INVALIDO);
        }

        existing.setFechaBaja(entity.getFechaBaja());
        existing.setMotivo(entity.getMotivo());
        existing.setValorVenta(entity.getValorVenta());
        existing.setComprador(entity.getComprador());
        existing.setTipoBaja(entity.getTipoBaja());
        existing.setTipoDocumentoVenta(entity.getTipoDocumentoVenta());
        existing.setNumeroDocumento(entity.getNumeroDocumento());
        existing.setTipoSiniestro(entity.getTipoSiniestro());
        existing.setMontoIndemnizacion(entity.getMontoIndemnizacion());
        existing.setMotivoObsolescencia(entity.getMotivoObsolescencia());
        existing.setDescripcionDetalle(entity.getDescripcionDetalle());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        AfVenta updated = repository.save(existing);
        log.info("Venta actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando venta con id: {}", id);
        AfVenta existing = findById(id);

        if (!ESTADO_EN_PROCESO.equals(existing.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden eliminar bajas en estado EN_PROCESO",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VENTA_ESTADO_INVALIDO);
        }

        repository.delete(existing);
        log.info("Venta eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "findByActivo"})
    @Override
    public List<AfVenta> findByActivo(Long activoId) {
        log.info("Listando ventas del activo: {}", activoId);
        List<AfVenta> ventas = repository.findByAfMaestroId(activoId);
        log.info("Ventas encontradas para activo {}: {}", activoId, ventas.size());
        return ventas;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "findByAnio"})
    @Override
    public List<AfVenta> findByAnio(Integer anio) {
        log.info("Listando ventas del año: {}", anio);
        List<AfVenta> ventas = repository.findByAnio(anio);
        log.info("Ventas encontradas para año {}: {}", anio, ventas.size());
        return ventas;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "aprobar"})
    @Override
    @Transactional
    public AfVenta aprobar(Long id) {
        log.info("Aprobando baja con id: {}", id);
        AfVenta venta = findById(id);

        if (!ESTADO_EN_PROCESO.equals(venta.getEstado())) {
            throw new BusinessException(
                    "Solo se pueden aprobar bajas en estado EN_PROCESO (actual: " + venta.getEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VENTA_ESTADO_INVALIDO);
        }

        AfMaestro activo = maestroRepository.findById(venta.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", venta.getAfMaestroId()));

        String estadoAnterior = activo.getFlagEstado();
        String nuevoEstadoActivo = resolverEstadoBaja(venta.getTipoBaja());
        activo.setFlagEstado("0");
        maestroRepository.save(activo);

        venta.setEstado(ESTADO_CONTABILIZADO);
        venta.setUpdatedBy(TenantContext.getUsuarioId());
        AfVenta aprobada = repository.save(venta);

        registrarHistorial(venta.getAfMaestroId(), "BAJA_CONTABILIZADA",
                "Baja contabilizada — activo dado de baja (" + nuevoEstadoActivo + "). " +
                        "Resultado: " + venta.getResultadoBaja() + ". Depreciación futura bloqueada.",
                estadoAnterior, nuevoEstadoActivo);

        log.info("Baja aprobada. Activo {} — estado: {} → {}. Depreciación futura bloqueada.",
                activo.getId(), estadoAnterior, nuevoEstadoActivo);
        contabilidadAutoContabilizador.ejecutarSiAutomatico(
                "venta",
                () -> contabilidadIntegracionService.contabilizarVenta(aprobada.getId()));
        return aprobada;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "anular"})
    @Override
    @Transactional
    public AfVenta anular(Long id) {
        log.info("Anulando baja con id: {}", id);
        AfVenta venta = findById(id);

        if (ESTADO_CERRADO.equals(venta.getEstado())) {
            throw new BusinessException("No se puede anular una baja cerrada",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.VENTA_ESTADO_INVALIDO);
        }

        if (ESTADO_CONTABILIZADO.equals(venta.getEstado())) {
            AfMaestro activo = maestroRepository.findById(venta.getAfMaestroId())
                    .orElseThrow(() -> new ResourceNotFoundException("Activo", venta.getAfMaestroId()));
            activo.setFlagEstado("1");
            maestroRepository.save(activo);
        }

        String estadoAnterior = venta.getEstado();
        venta.setEstado(ESTADO_ANULADO);
        venta.setUpdatedBy(TenantContext.getUsuarioId());
        AfVenta anulada = repository.save(venta);

        registrarHistorial(venta.getAfMaestroId(), "BAJA_ANULADA",
                "Baja anulada — activo restaurado a estado ACTIVO", estadoAnterior, ESTADO_ANULADO);

        log.info("Baja anulada exitosamente con id: {}", id);
        return anulada;
    }

    private AfMaestro validarActivoParaBaja(Long afMaestroId) {
        AfMaestro activo = maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new BusinessException(
                        "El activo con ID " + afMaestroId + " no existe en el sistema",
                        HttpStatus.NOT_FOUND, ActivosErrorCodes.MAESTRO_NO_ENCONTRADO));

        if (!"1".equals(activo.getFlagEstado())) {
            throw new BusinessException(
                    "El activo ya fue dado de baja o está inactivo (flag_estado: " + activo.getFlagEstado() + ")",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }
        return activo;
    }

    private void validarActivoNoBajado(Long afMaestroId) {
        List<AfVenta> ventas = repository.findByAfMaestroId(afMaestroId);
        boolean tieneVentaActiva = ventas.stream()
                .anyMatch(v -> ESTADO_EN_PROCESO.equals(v.getEstado()) || ESTADO_CONTABILIZADO.equals(v.getEstado()));
        if (tieneVentaActiva) {
            throw new BusinessException(
                    "Ya existe un proceso de baja activo para el activo " + afMaestroId,
                    HttpStatus.CONFLICT, ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }
    }

    private BigDecimal obtenerDepreciacionAcumulada(Long afMaestroId) {
        return calculoRepository.obtenerUltimaDepreciacion(afMaestroId)
                .map(AfCalculoCntbl::getDepreciacionAcumulada)
                .orElse(BigDecimal.ZERO);
    }

    private String resolverEstadoBaja(String tipoBaja) {
        if (tipoBaja == null) return "BAJ_V";
        return switch (tipoBaja.toUpperCase()) {
            case "VENTA"         -> "BAJ_V";
            case "SINIESTRO"     -> "BAJ_S";
            case "OBSOLESCENCIA" -> "BAJ_O";
            default              -> "BAJ_V";
        };
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
        historial.setModulo("VENTAS_BAJAS");
        historialService.create(historial);
    }
}
