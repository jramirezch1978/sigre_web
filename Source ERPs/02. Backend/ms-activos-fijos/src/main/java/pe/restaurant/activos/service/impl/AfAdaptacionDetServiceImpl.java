package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.entity.AfAdaptacionDet;
import pe.restaurant.activos.repository.AfAdaptacionDetRepository;
import pe.restaurant.activos.repository.AfAdaptacionRepository;
import pe.restaurant.activos.service.AfAdaptacionDetService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfAdaptacionDetServiceImpl implements AfAdaptacionDetService {

    private final AfAdaptacionDetRepository repository;
    private final AfAdaptacionRepository adaptacionRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_det", "operation", "findById"})
    @Override
    public AfAdaptacionDet findById(Long id) {
        log.info("Buscando detalle de adaptación con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Detalle de adaptación no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Detalle de adaptación", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_det", "operation", "create"})
    @Override
    @Transactional
    public AfAdaptacionDet create(AfAdaptacionDet entity) {
        log.info("Creando detalle de adaptación para adaptación: {}", entity.getAfAdaptacionId());
        
        validarAdaptacionExistente(entity.getAfAdaptacionId());
        validarMontoPositivo(entity.getMonto());
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        
        AfAdaptacionDet saved = repository.save(entity);
        actualizarMontoTotalAdaptacion(entity.getAfAdaptacionId());
        
        log.info("Detalle de adaptación creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_det", "operation", "update"})
    @Override
    @Transactional
    public AfAdaptacionDet update(Long id, AfAdaptacionDet entity) {
        log.info("Actualizando detalle de adaptación con id: {}", id);
        AfAdaptacionDet existing = findById(id);
        
        validarAdaptacionNoCapitalizada(existing.getAfAdaptacionId());
        validarMontoPositivo(entity.getMonto());
        
        existing.setDescripcion(entity.getDescripcion());
        existing.setMonto(entity.getMonto());
        existing.setUnidadMedidaId(entity.getUnidadMedidaId());
        
        AfAdaptacionDet updated = repository.save(existing);
        actualizarMontoTotalAdaptacion(existing.getAfAdaptacionId());
        
        log.info("Detalle de adaptación actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_det", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando detalle de adaptación con id: {}", id);
        AfAdaptacionDet existing = findById(id);
        
        validarAdaptacionNoCapitalizada(existing.getAfAdaptacionId());
        
        Long adaptacionId = existing.getAfAdaptacionId();
        repository.delete(existing);
        actualizarMontoTotalAdaptacion(adaptacionId);
        
        log.info("Detalle de adaptación eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_det", "operation", "findByAdaptacion"})
    @Override
    public List<AfAdaptacionDet> findByAdaptacion(Long adaptacionId) {
        log.info("Listando detalles de adaptación: {}", adaptacionId);
        List<AfAdaptacionDet> detalles = repository.findByAfAdaptacionId(adaptacionId);
        log.info("Detalles encontrados para adaptación {}: {}", adaptacionId, detalles.size());
        return detalles;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_det", "operation", "calcularTotal"})
    @Override
    public BigDecimal calcularTotal(Long adaptacionId) {
        log.info("Calculando total de detalles para adaptación: {}", adaptacionId);
        BigDecimal total = repository.calcularTotalDetalles(adaptacionId);
        BigDecimal resultado = (total != null) ? total : BigDecimal.ZERO;
        log.info("Total calculado para adaptación {}: {}", adaptacionId, resultado);
        return resultado;
    }

    private void validarAdaptacionExistente(Long afAdaptacionId) {
        log.debug("Validando existencia de adaptación con id: {}", afAdaptacionId);
        AfAdaptacion adaptacion = adaptacionRepository.findById(afAdaptacionId)
                .orElseThrow(() -> {
                    log.warn("Adaptación no encontrada con id: {}", afAdaptacionId);
                    return new BusinessException(
                            "La adaptación con ID " + afAdaptacionId + " no existe en el sistema",
                            HttpStatus.NOT_FOUND,
                            ActivosErrorCodes.ADAPTACION_NO_ENCONTRADA
                    );
                });
        
        
        log.debug("Adaptación validada exitosamente");
    }

    private void validarAdaptacionNoCapitalizada(Long afAdaptacionId) {
        log.debug("Validando que adaptación no esté capitalizada: {}", afAdaptacionId);
        AfAdaptacion adaptacion = adaptacionRepository.findById(afAdaptacionId)
                .orElseThrow(() -> new ResourceNotFoundException("Adaptación", afAdaptacionId));
        
    }

    private void validarMontoPositivo(BigDecimal monto) {
        if (monto == null || monto.compareTo(BigDecimal.ZERO) <= 0) {
            log.warn("Monto inválido: {}", monto);
            throw new BusinessException(
                    "El monto debe ser mayor a cero",
                    HttpStatus.BAD_REQUEST,
                    "ACT-038"
            );
        }
    }

    @Transactional
    private void actualizarMontoTotalAdaptacion(Long adaptacionId) {
        log.debug("Actualizando monto total de adaptación: {}", adaptacionId);
        BigDecimal total = calcularTotal(adaptacionId);
        
        AfAdaptacion adaptacion = adaptacionRepository.findById(adaptacionId)
                .orElseThrow(() -> new ResourceNotFoundException("Adaptación", adaptacionId));
        
        adaptacion.setMontoTotal(total);
        adaptacionRepository.save(adaptacion);
        
        log.debug("Monto total actualizado a: {}", total);
    }
}
