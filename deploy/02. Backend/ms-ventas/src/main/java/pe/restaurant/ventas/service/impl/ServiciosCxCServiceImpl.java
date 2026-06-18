package pe.restaurant.ventas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.ServiciosCxCRequest;
import pe.restaurant.ventas.dto.response.ServiciosCxCResponse;
import pe.restaurant.ventas.entity.ServiciosCxC;
import pe.restaurant.ventas.mapper.ServiciosCxCMapper;
import pe.restaurant.ventas.repository.ServiciosCxCRepository;
import pe.restaurant.ventas.service.ServiciosCxCService;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ServiciosCxCServiceImpl implements ServiciosCxCService {

    private final ServiciosCxCRepository repository;
    private final ServiciosCxCMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "servicios_cxc", "operation", "findAll"})
    @Override
    public Page<ServiciosCxC> findAll(Pageable pageable) {
        log.info("Listando servicios CxC - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<ServiciosCxC> page = repository.findAll(pageable);
        log.info("Servicios CxC encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios_cxc", "operation", "findAllWithFilters"})
    @Override
    public Page<ServiciosCxC> findAllWithFilters(String codServicio, String descServicio, String codMoneda, String flagEstado, Pageable pageable) {
        log.info("Listando servicios CxC con filtros - codServicio: {}, descServicio: {}, codMoneda: {}, flagEstado: {}",
                codServicio, descServicio, codMoneda, flagEstado);
        Page<ServiciosCxC> page = repository.findAllWithFilters(codServicio, descServicio, codMoneda, flagEstado, pageable);
        log.info("Servicios CxC encontrados con filtros: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios_cxc", "operation", "findById"})
    @Override
    public ServiciosCxC findById(Long id) {
        log.info("Buscando servicio CxC con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Servicio CxC no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Servicio CxC", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios_cxc", "operation", "create"})
    @Override
    @Transactional
    public ServiciosCxC create(ServiciosCxC entity) {
        log.info("Creando servicio CxC con codigo: {}", entity.getCodServicio());
        validateUniqueCodServicio(entity.getCodServicio(), null);
        
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        ServiciosCxC saved = repository.save(entity);
        log.info("Servicio CxC creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios_cxc", "operation", "update"})
    @Override
    @Transactional
    public ServiciosCxC update(Long id, ServiciosCxC entity) {
        log.info("Actualizando servicio CxC con id: {}", id);
        ServiciosCxC existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Servicio CxC no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Servicio CxC", id);
                });
        
        validateUniqueCodServicio(entity.getCodServicio(), id);
        
        existing.setCodServicio(entity.getCodServicio());
        existing.setDescServicio(entity.getDescServicio());
        existing.setTarifa(entity.getTarifa());
        existing.setCodMoneda(entity.getCodMoneda());
        existing.setFlagAfectoIgv(entity.getFlagAfectoIgv());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ServiciosCxC updated = repository.save(existing);
        log.info("Servicio CxC actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios_cxc", "operation", "activate"})
    @Override
    @Transactional
    public ServiciosCxC activate(Long id) {
        log.info("Activando servicio CxC con id: {}", id);
        ServiciosCxC existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Servicio CxC no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Servicio CxC", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ServiciosCxC activated = repository.save(existing);
        log.info("Servicio CxC activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios_cxc", "operation", "deactivate"})
    @Override
    @Transactional
    public ServiciosCxC deactivate(Long id) {
        log.info("Desactivando servicio CxC con id: {}", id);
        ServiciosCxC existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Servicio CXC no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Servicio CXC", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ServiciosCxC deactivated = repository.save(existing);
        log.info("Servicio CXC desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios_cxc", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando servicio CXC con id: {}", id);
        ServiciosCxC existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Servicio CXC no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Servicio CXC", id);
                });
        
        repository.delete(existing);
        log.info("Servicio CXC eliminado exitosamente con id: {}", id);
    }

    private void validateUniqueCodServicio(String codServicio, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodServicioAndFlagEstado(codServicio, "1")
                : repository.existsByCodServicioAndFlagEstadoAndIdNot(codServicio, "1", excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar codigo de servicio CXC: {}", codServicio);
            throw new BusinessException(
                    "Ya existe un servicio CXC con código: " + codServicio,
                    org.springframework.http.HttpStatus.CONFLICT, 
                    VentasErrorCodes.SERVICIOS_CXC_CODIGO_DUPLICADO);
        }
    }
}
