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
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfPolizaActivo;
import pe.restaurant.activos.entity.AfPolizaSeguro;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfPolizaActivoRepository;
import pe.restaurant.activos.repository.AfPolizaSeguroRepository;
import pe.restaurant.activos.service.AfPolizaActivoService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfPolizaActivoServiceImpl implements AfPolizaActivoService {

    private final AfPolizaActivoRepository repository;
    private final AfPolizaSeguroRepository polizaSeguroRepository;
    private final AfMaestroRepository maestroRepository;
    private final AfCalculoCntblRepository calculoCntblRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_activo", "operation", "findAll"})
    @Override
    public Page<AfPolizaActivo> findAll(Pageable pageable) {
        log.info("Listando pólizas-activos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfPolizaActivo> page = repository.findAll(pageable);
        log.info("Pólizas-activos encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_activo", "operation", "findById"})
    @Override
    public AfPolizaActivo findById(Long id) {
        log.info("Buscando póliza-activo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Póliza-activo no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Póliza-activo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_activo", "operation", "create"})
    @Override
    @Transactional
    public AfPolizaActivo create(AfPolizaActivo entity) {
        log.info("Creando póliza-activo para póliza: {} y activo: {}", 
                entity.getAfPolizaSeguroId(), entity.getAfMaestroId());
        
        validarPolizaExistente(entity.getAfPolizaSeguroId());
        validarActivoExistente(entity.getAfMaestroId());
        validarActivoNoDuplicado(entity.getAfPolizaSeguroId(), entity.getAfMaestroId(), null);
        validarValorAsegurado(entity.getAfMaestroId(), entity.getValorAsegurado());
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        
        AfPolizaActivo saved = repository.save(entity);
        log.info("Póliza-activo creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_activo", "operation", "update"})
    @Override
    @Transactional
    public AfPolizaActivo update(Long id, AfPolizaActivo entity) {
        log.info("Actualizando póliza-activo con id: {}", id);
        AfPolizaActivo existing = findById(id);
        
        if (!existing.getAfPolizaSeguroId().equals(entity.getAfPolizaSeguroId()) ||
            !existing.getAfMaestroId().equals(entity.getAfMaestroId())) {
            validarPolizaExistente(entity.getAfPolizaSeguroId());
            validarActivoExistente(entity.getAfMaestroId());
            validarActivoNoDuplicado(entity.getAfPolizaSeguroId(), entity.getAfMaestroId(), id);
        }
        
        validarValorAsegurado(entity.getAfMaestroId(), entity.getValorAsegurado());
        
        existing.setAfPolizaSeguroId(entity.getAfPolizaSeguroId());
        existing.setAfMaestroId(entity.getAfMaestroId());
        existing.setValorAsegurado(entity.getValorAsegurado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfPolizaActivo updated = repository.save(existing);
        log.info("Póliza-activo actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_activo", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando póliza-activo con id: {}", id);
        AfPolizaActivo existing = findById(id);
        repository.delete(existing);
        log.info("Póliza-activo eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_activo", "operation", "findByPoliza"})
    @Override
    public List<AfPolizaActivo> findByPoliza(Long polizaId) {
        log.info("Listando activos de póliza: {}", polizaId);
        List<AfPolizaActivo> activos = repository.findByAfPolizaSeguroId(polizaId);
        log.info("Activos encontrados para póliza {}: {}", polizaId, activos.size());
        return activos;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_activo", "operation", "findByActivo"})
    @Override
    public List<AfPolizaActivo> findByActivo(Long activoId) {
        log.info("Listando pólizas del activo: {}", activoId);
        List<AfPolizaActivo> polizas = repository.findByAfMaestroId(activoId);
        log.info("Pólizas encontradas para activo {}: {}", activoId, polizas.size());
        return polizas;
    }

    private void validarPolizaExistente(Long afPolizaSeguroId) {
        log.debug("Validando existencia de póliza con id: {}", afPolizaSeguroId);
        AfPolizaSeguro poliza = polizaSeguroRepository.findById(afPolizaSeguroId)
                .orElseThrow(() -> {
                    log.warn("Póliza de seguro no encontrada con id: {}", afPolizaSeguroId);
                    return new BusinessException(
                            "La póliza de seguro con ID " + afPolizaSeguroId + " no existe en el sistema",
                            HttpStatus.NOT_FOUND,
                            "ACT-031"
                    );
                });
        
        
        log.debug("Póliza validada exitosamente: {}", poliza.getNumeroPoliza());
    }

    private void validarActivoExistente(Long afMaestroId) {
        log.debug("Validando existencia de activo con id: {}", afMaestroId);
        AfMaestro activo = maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> {
                    log.warn("Activo maestro no encontrado con id: {}", afMaestroId);
                    return new BusinessException(
                            "El activo con ID " + afMaestroId + " no existe en el sistema",
                            HttpStatus.NOT_FOUND,
                            ActivosErrorCodes.ACTIVO_NO_ENCONTRADO_POLIZA
                    );
                });
        
        
        log.debug("Activo validado exitosamente: {}", activo.getCodigo());
    }

    private void validarActivoNoDuplicado(Long afPolizaSeguroId, Long afMaestroId, Long excludeId) {
        boolean exists = repository.existsByAfPolizaSeguroIdAndAfMaestroId(afPolizaSeguroId, afMaestroId);
        
        if (exists) {
            AfPolizaActivo existing = repository.findByPolizaAndActivo(afPolizaSeguroId, afMaestroId);
            if (excludeId == null || !existing.getId().equals(excludeId)) {
                log.warn("Intento de duplicar activo {} en póliza {}", afMaestroId, afPolizaSeguroId);
                throw new BusinessException(
                        "El activo ya está registrado en esta póliza de seguro",
                        HttpStatus.CONFLICT,
                        ActivosErrorCodes.ACTIVO_YA_ASEGURADO
                );
            }
        }
    }

    private void validarValorAsegurado(Long afMaestroId, BigDecimal valorAsegurado) {
        if (valorAsegurado == null || valorAsegurado.compareTo(BigDecimal.ZERO) <= 0) {
            return;
        }
        
        log.debug("Validando valor asegurado para activo: {}", afMaestroId);
        
        AfMaestro activo = maestroRepository.findById(afMaestroId).orElseThrow();
        
        AfCalculoCntbl ultimaDepreciacion = calculoCntblRepository
                .obtenerUltimaDepreciacion(afMaestroId)
                .orElse(null);
        
        BigDecimal valorNeto = (ultimaDepreciacion != null) 
                ? ultimaDepreciacion.getValorNeto() 
                : activo.getValorAdquisicion();
        
        if (valorAsegurado.compareTo(valorNeto) > 0) {
            log.warn("Valor asegurado {} excede valor neto {} del activo {}", 
                    valorAsegurado, valorNeto, afMaestroId);
            throw new BusinessException(
                    String.format("El valor asegurado (%.2f) no puede exceder el valor neto del activo (%.2f)", 
                            valorAsegurado, valorNeto),
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.VALOR_ASEGURADO_EXCEDE_NETO
            );
        }
        
        log.debug("Valor asegurado validado exitosamente: {} <= {}", valorAsegurado, valorNeto);
    }
}
