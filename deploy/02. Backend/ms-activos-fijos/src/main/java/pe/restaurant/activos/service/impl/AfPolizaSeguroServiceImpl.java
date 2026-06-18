package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfAseguradora;
import pe.restaurant.activos.entity.AfPolizaSeguro;
import pe.restaurant.activos.repository.AfAseguradoraRepository;
import pe.restaurant.activos.repository.AfPolizaSeguroRepository;
import pe.restaurant.activos.service.AfPolizaSeguroService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfPolizaSeguroServiceImpl implements AfPolizaSeguroService {

    private final AfPolizaSeguroRepository repository;
    private final AfAseguradoraRepository aseguradoraRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "findAll"})
    @Override
    public Page<AfPolizaSeguro> findAll(Pageable pageable) {
        log.info("Listando pólizas de seguro - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfPolizaSeguro> page = repository.findAll(pageable);
        log.info("Pólizas de seguro encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "findById"})
    @Override
    public AfPolizaSeguro findById(Long id) {
        log.info("Buscando póliza de seguro con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Póliza de seguro no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Póliza de seguro", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "create"})
    @Override
    @Transactional
    public AfPolizaSeguro create(AfPolizaSeguro entity) {
        log.info("Creando póliza de seguro con número: {}", entity.getNumeroPoliza());
        
        validarNumeroPolizaUnico(entity.getNumeroPoliza(), null);
        validarAseguradoraExistente(entity.getAfAseguradoraId());
        validarFechas(entity.getFechaInicio(), entity.getFechaFin());
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        
        AfPolizaSeguro saved = repository.save(entity);
        log.info("Póliza de seguro creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "update"})
    @Override
    @Transactional
    public AfPolizaSeguro update(Long id, AfPolizaSeguro entity) {
        log.info("Actualizando póliza de seguro con id: {}", id);
        AfPolizaSeguro existing = findById(id);
        
        if (!existing.getNumeroPoliza().equalsIgnoreCase(entity.getNumeroPoliza())) {
            validarNumeroPolizaUnico(entity.getNumeroPoliza(), id);
        }
        
        if (!existing.getAfAseguradoraId().equals(entity.getAfAseguradoraId())) {
            validarAseguradoraExistente(entity.getAfAseguradoraId());
        }
        
        validarFechas(entity.getFechaInicio(), entity.getFechaFin());
        
        existing.setAfAseguradoraId(entity.getAfAseguradoraId());
        existing.setNumeroPoliza(entity.getNumeroPoliza());
        existing.setFechaInicio(entity.getFechaInicio());
        existing.setFechaFin(entity.getFechaFin());
        existing.setPrima(entity.getPrima());
        existing.setCobertura(entity.getCobertura());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfPolizaSeguro updated = repository.save(existing);
        log.info("Póliza de seguro actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando póliza de seguro con id: {}", id);
        AfPolizaSeguro existing = findById(id);
        repository.delete(existing);
        log.info("Póliza de seguro eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "findPolizasVigentes"})
    @Override
    public Page<AfPolizaSeguro> findPolizasVigentes(Pageable pageable) {
        log.info("Listando pólizas vigentes - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfPolizaSeguro> page = repository.findPolizasVigentes(pageable);
        log.info("Pólizas vigentes encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "findPolizasPorVencer"})
    @Override
    public List<AfPolizaSeguro> findPolizasPorVencer(Integer dias) {
        log.info("Buscando pólizas por vencer en {} días", dias);
        LocalDate fechaActual = LocalDate.now();
        LocalDate fechaLimite = fechaActual.plusDays(dias);
        
        List<AfPolizaSeguro> polizas = repository.findPolizasPorVencer(fechaActual, fechaLimite);
        log.info("Pólizas por vencer encontradas: {}", polizas.size());
        return polizas;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "findByAseguradora"})
    @Override
    public Page<AfPolizaSeguro> findByAseguradora(Long aseguradoraId, Pageable pageable) {
        log.info("Listando pólizas de aseguradora: {}", aseguradoraId);
        Page<AfPolizaSeguro> page = repository.findByAfAseguradoraId(aseguradoraId, pageable);
        log.info("Pólizas encontradas para aseguradora {}: {}", aseguradoraId, page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_poliza_seguro", "operation", "renovarPoliza"})
    @Override
    @Transactional
    public AfPolizaSeguro renovarPoliza(Long id, AfPolizaSeguro datosRenovacion) {
        log.info("Renovando póliza de seguro con id: {}", id);
        AfPolizaSeguro existing = findById(id);
        
        validarFechas(datosRenovacion.getFechaInicio(), datosRenovacion.getFechaFin());
        
        existing.setFechaInicio(datosRenovacion.getFechaInicio());
        existing.setFechaFin(datosRenovacion.getFechaFin());
        existing.setPrima(datosRenovacion.getPrima());
        existing.setCobertura(datosRenovacion.getCobertura());
        
        AfPolizaSeguro renovada = repository.save(existing);
        log.info("Póliza de seguro renovada exitosamente con id: {}", id);
        return renovada;
    }

    private void validarNumeroPolizaUnico(String numeroPoliza, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByNumeroPolizaIgnoreCase(numeroPoliza)
                : repository.existsByNumeroPolizaIgnoreCaseAndIdNot(numeroPoliza, excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar número de póliza: {}", numeroPoliza);
            throw new BusinessException(
                    "Ya existe una póliza con el número: " + numeroPoliza,
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.POLIZA_NUMERO_DUPLICADO
            );
        }
    }

    private void validarAseguradoraExistente(Long afAseguradoraId) {
        log.debug("Validando existencia de aseguradora con id: {}", afAseguradoraId);
        AfAseguradora aseguradora = aseguradoraRepository.findById(afAseguradoraId)
                .orElseThrow(() -> {
                    log.warn("Aseguradora no encontrada con id: {}", afAseguradoraId);
                    return new BusinessException(
                            "La aseguradora con ID " + afAseguradoraId + " no existe en el sistema",
                            HttpStatus.NOT_FOUND,
                            ActivosErrorCodes.ASEGURADORA_NO_ENCONTRADA
                    );
                });
        
        if (!"1".equals(aseguradora.getFlagEstado())) {
            log.warn("Aseguradora inactiva con id: {}", afAseguradoraId);
            throw new BusinessException(
                    "La aseguradora '" + aseguradora.getNombre() + "' está inactiva. Debe activarla antes de usarla",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.ASEGURADORA_INACTIVA
            );
        }
        
        log.debug("Aseguradora validada exitosamente: {}", aseguradora.getNombre());
    }

    private void validarFechas(LocalDate fechaInicio, LocalDate fechaFin) {
        if (fechaFin != null && fechaFin.isBefore(fechaInicio)) {
            log.warn("Fecha fin {} es anterior a fecha inicio {}", fechaFin, fechaInicio);
            throw new BusinessException(
                    "La fecha de fin debe ser posterior a la fecha de inicio",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.FECHA_FIN_ANTERIOR_INICIO
            );
        }
    }
}
