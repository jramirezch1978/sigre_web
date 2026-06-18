package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.entity.AfAdaptacionDep;
import pe.restaurant.activos.repository.AfAdaptacionDepRepository;
import pe.restaurant.activos.repository.AfAdaptacionRepository;
import pe.restaurant.activos.service.AfAdaptacionDepService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfAdaptacionDepServiceImpl implements AfAdaptacionDepService {

    private final AfAdaptacionDepRepository repository;
    private final AfAdaptacionRepository adaptacionRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_dep", "operation", "findById"})
    @Override
    public AfAdaptacionDep findById(Long id) {
        log.info("Buscando depreciación de adaptación con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Depreciación de adaptación no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Depreciación de adaptación", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_dep", "operation", "create"})
    @Override
    @Transactional
    public AfAdaptacionDep create(AfAdaptacionDep entity) {
        log.info("Creando depreciación de adaptación para adaptación: {} - {}/{}", 
                entity.getAfAdaptacionId(), entity.getAnio(), entity.getMes());
        
        validarAdaptacionExistente(entity.getAfAdaptacionId());
        validarPeriodoNoExistente(entity.getAfAdaptacionId(), entity.getAnio(), entity.getMes(), null);
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        
        AfAdaptacionDep saved = repository.save(entity);
        log.info("Depreciación de adaptación creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_dep", "operation", "update"})
    @Override
    @Transactional
    public AfAdaptacionDep update(Long id, AfAdaptacionDep entity) {
        log.info("Actualizando depreciación de adaptación con id: {}", id);
        AfAdaptacionDep existing = findById(id);
        
        if (!existing.getAnio().equals(entity.getAnio()) || !existing.getMes().equals(entity.getMes())) {
            validarPeriodoNoExistente(existing.getAfAdaptacionId(), entity.getAnio(), entity.getMes(), id);
        }
        
        existing.setAnio(entity.getAnio());
        existing.setMes(entity.getMes());
        existing.setDepreciacionPeriodo(entity.getDepreciacionPeriodo());
        existing.setDepreciacionAcumulada(entity.getDepreciacionAcumulada());
        
        AfAdaptacionDep updated = repository.save(existing);
        log.info("Depreciación de adaptación actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_dep", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando depreciación de adaptación con id: {}", id);
        AfAdaptacionDep existing = findById(id);
        repository.delete(existing);
        log.info("Depreciación de adaptación eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_dep", "operation", "findByAdaptacion"})
    @Override
    public List<AfAdaptacionDep> findByAdaptacion(Long adaptacionId) {
        log.info("Listando depreciaciones de adaptación: {}", adaptacionId);
        List<AfAdaptacionDep> depreciaciones = repository.findByAfAdaptacionId(adaptacionId);
        log.info("Depreciaciones encontradas para adaptación {}: {}", adaptacionId, depreciaciones.size());
        return depreciaciones;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_dep", "operation", "findByPeriodo"})
    @Override
    public List<AfAdaptacionDep> findByPeriodo(Integer anio, Integer mes) {
        log.info("Listando depreciaciones del período: {}/{}", anio, mes);
        List<AfAdaptacionDep> depreciaciones = repository.findByAnioAndMes(anio, mes);
        log.info("Depreciaciones encontradas para período {}/{}: {}", anio, mes, depreciaciones.size());
        return depreciaciones;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_adaptacion_dep", "operation", "calcularDepreciacion"})
    @Override
    @Transactional
    public AfAdaptacionDep calcularDepreciacion(Long adaptacionId, Integer anio, Integer mes) {
        log.info("Calculando depreciación para adaptación {} - {}/{}", adaptacionId, anio, mes);
        
        AfAdaptacion adaptacion = adaptacionRepository.findById(adaptacionId)
                .orElseThrow(() -> new ResourceNotFoundException("Adaptación", adaptacionId));
        
        
        validarPeriodoNoExistente(adaptacionId, anio, mes, null);
        
        List<AfAdaptacionDep> depreciacionesAnteriores = repository.findByAdaptacionOrderByPeriodoDesc(adaptacionId);
        
        BigDecimal depreciacionAcumuladaAnterior = BigDecimal.ZERO;
        if (!depreciacionesAnteriores.isEmpty()) {
            depreciacionAcumuladaAnterior = depreciacionesAnteriores.get(0).getDepreciacionAcumulada();
        }
        
        BigDecimal depreciacionPeriodo = BigDecimal.ZERO;
        
        BigDecimal depreciacionAcumulada = depreciacionAcumuladaAnterior.add(depreciacionPeriodo);
        
        AfAdaptacionDep nuevaDepreciacion = new AfAdaptacionDep();
        nuevaDepreciacion.setAfAdaptacionId(adaptacionId);
        nuevaDepreciacion.setAnio(anio);
        nuevaDepreciacion.setMes(mes);
        nuevaDepreciacion.setDepreciacionPeriodo(depreciacionPeriodo);
        nuevaDepreciacion.setDepreciacionAcumulada(depreciacionAcumulada);
        nuevaDepreciacion.setFlagEstado("1");
        
        AfAdaptacionDep saved = repository.save(nuevaDepreciacion);
        log.info("Depreciación calculada y guardada exitosamente con id: {}", saved.getId());
        return saved;
    }

    private void validarAdaptacionExistente(Long afAdaptacionId) {
        log.debug("Validando existencia de adaptación con id: {}", afAdaptacionId);
        adaptacionRepository.findById(afAdaptacionId)
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

    private void validarPeriodoNoExistente(Long adaptacionId, Integer anio, Integer mes, Long excludeId) {
        boolean exists = repository.existsByAfAdaptacionIdAndAnioAndMes(adaptacionId, anio, mes);
        
        if (exists) {
            AfAdaptacionDep existing = repository.findByAdaptacionAndPeriodo(adaptacionId, anio, mes)
                    .orElse(null);
            
            if (existing != null && (excludeId == null || !existing.getId().equals(excludeId))) {
                log.warn("Ya existe depreciación para adaptación {} en período {}/{}", adaptacionId, anio, mes);
                throw new BusinessException(
                        String.format("Ya existe depreciación para esta adaptación en el período %d/%d", anio, mes),
                        HttpStatus.CONFLICT,
                        ActivosErrorCodes.DEPRECIACION_ADAPTACION_DUPLICADA
                );
            }
        }
    }
}
