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
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.AfVentaService;
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

    private final AfVentaRepository repository;
    private final AfMaestroRepository maestroRepository;
    private final AfCalculoCntblRepository calculoRepository;
    private final AfHistorialService historialService;

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "findAll"})
    @Override
    public Page<AfVenta> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "findById"})
    @Override
    public AfVenta findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Venta", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "create"})
    @Override
    @Transactional
    public AfVenta create(AfVenta entity) {
        log.info("Registrando venta/baja para activo: {}", entity.getAfMaestroId());

        AfMaestro activo = validarActivoParaBaja(entity.getAfMaestroId());
        validarActivoNoBajado(entity.getAfMaestroId());

        BigDecimal depAcumulada = obtenerDepreciacionAcumulada(entity.getAfMaestroId());
        BigDecimal valorNeto = activo.getValorAdquisicion().subtract(depAcumulada);

        entity.setDepreciacionAcumulada(depAcumulada);
        entity.setValorNetoContable(valorNeto);
        entity.setCreatedBy(TenantContext.getUsuarioId());

        AfVenta saved = repository.save(entity);

        activo.setFlagEstado("0");
        maestroRepository.save(activo);

        registrarHistorial(entity.getAfMaestroId(), "BAJA_REGISTRADA",
                "Venta/baja registrada — valor neto: " + valorNeto
                        + ", doc: " + entity.getSerieDoc() + "-" + entity.getNroDoc(),
                "1", "0");

        log.info("Venta creada con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "update"})
    @Override
    @Transactional
    public AfVenta update(Long id, AfVenta entity) {
        log.info("Actualizando venta con id: {}", id);
        AfVenta existing = findById(id);

        existing.setCntasCobrarId(entity.getCntasCobrarId());
        existing.setDocTipoId(entity.getDocTipoId());
        existing.setSerieDoc(entity.getSerieDoc());
        existing.setNroDoc(entity.getNroDoc());
        existing.setFechaBaja(entity.getFechaBaja());
        existing.setMotivo(entity.getMotivo());
        existing.setValorVenta(entity.getValorVenta());
        existing.setComprador(entity.getComprador());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando venta con id: {}", id);
        AfVenta existing = findById(id);

        AfMaestro activo = maestroRepository.findById(existing.getAfMaestroId()).orElse(null);
        if (activo != null && "0".equals(activo.getFlagEstado())) {
            activo.setFlagEstado("1");
            maestroRepository.save(activo);
        }

        repository.delete(existing);

        registrarHistorial(existing.getAfMaestroId(), "BAJA_ANULADA",
                "Venta/baja eliminada — activo restaurado", "0", "1");

        log.info("Venta eliminada con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "findByActivo"})
    @Override
    public List<AfVenta> findByActivo(Long activoId) {
        return repository.findByAfMaestroId(activoId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_venta", "operation", "findByAnio"})
    @Override
    public List<AfVenta> findByAnio(Integer anio) {
        return repository.findByAnio(anio);
    }

    private AfMaestro validarActivoParaBaja(Long afMaestroId) {
        AfMaestro activo = maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new BusinessException(
                        "El activo con ID " + afMaestroId + " no existe en el sistema",
                        HttpStatus.NOT_FOUND, ActivosErrorCodes.MAESTRO_NO_ENCONTRADO));

        if (!"1".equals(activo.getFlagEstado())) {
            throw new BusinessException(
                    "El activo ya fue dado de baja o está inactivo",
                    HttpStatus.BAD_REQUEST, ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }
        return activo;
    }

    private void validarActivoNoBajado(Long afMaestroId) {
        List<AfVenta> ventas = repository.findByAfMaestroId(afMaestroId);
        boolean tieneVentaActiva = ventas.stream()
                .anyMatch(v -> "1".equals(v.getFlagEstado()));
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
