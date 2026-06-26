package pe.restaurant.finanzas.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.dto.request.GrupoCodigoFlujoCajaRequest;
import pe.restaurant.finanzas.dto.response.GrupoCodigoFlujoCajaResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.entity.GrupoCodigoFlujoCaja;
import pe.restaurant.finanzas.mapper.GrupoCodigoFlujoCajaMapper;
import pe.restaurant.finanzas.repository.GrupoCodigoFlujoCajaRepository;
import pe.restaurant.finanzas.service.GrupoCodigoFlujoCajaService;

@Slf4j
@Service
@RequiredArgsConstructor
public class GrupoCodigoFlujoCajaServiceImpl implements GrupoCodigoFlujoCajaService {

    private final GrupoCodigoFlujoCajaRepository repository;
    private final GrupoCodigoFlujoCajaMapper mapper;

    @Override
    public PageData<GrupoCodigoFlujoCajaResponse> findAll(Pageable pageable) {
        log.debug("Listando grupos de código de flujo de caja con paginación");
        Page<GrupoCodigoFlujoCaja> entityPage = repository.findAll(pageable);
        return PageData.of(entityPage, entityPage.map(mapper::toResponse).getContent());
    }

    @Override
    public GrupoCodigoFlujoCajaResponse findById(Long id) {
        log.debug("Buscando grupo de código de flujo de caja por id: {}", id);
        GrupoCodigoFlujoCaja entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Grupo de código de flujo de caja", id));
        
        log.debug("Grupo de código de flujo de caja encontrado: {}", entity.getCodigo());
        return mapper.toResponse(entity);
    }

    @Override
    @Transactional
    public GrupoCodigoFlujoCajaResponse create(GrupoCodigoFlujoCajaRequest request) {
        log.info("Creando grupo de código de flujo de caja con código: {}", request.getCodigo());
        
        // Validar código único
        if (repository.existsByCodigo(request.getCodigo())) {
            throw new BusinessException(
                    "Ya existe un grupo de código de flujo de caja con el código: " + request.getCodigo(),
                    HttpStatus.CONFLICT,
                    "FIN-001"
            );
        }
        
        GrupoCodigoFlujoCaja entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        GrupoCodigoFlujoCaja saved = repository.save(entity);
        
        log.info("Grupo de código de flujo de caja creado exitosamente con id: {}", saved.getId());
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    public GrupoCodigoFlujoCajaResponse update(Long id, GrupoCodigoFlujoCajaRequest request) {
        log.info("Actualizando grupo de código de flujo de caja con id: {}", id);
        
        GrupoCodigoFlujoCaja existing = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Grupo de código de flujo de caja", id));
        
        // Validar código único (si cambió)
        if (!existing.getCodigo().equals(request.getCodigo()) && 
            repository.existsByCodigo(request.getCodigo())) {
            throw new BusinessException(
                    "Ya existe un grupo de código de flujo de caja con el código: " + request.getCodigo(),
                    HttpStatus.CONFLICT,
                    "FIN-001"
            );
        }
        
        mapper.updateEntity(request, existing);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        GrupoCodigoFlujoCaja updated = repository.save(existing);
        
        log.info("Grupo de código de flujo de caja actualizado exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        log.info("Eliminando grupo de código de flujo de caja con id: {}", id);
        
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("Grupo de código de flujo de caja", id);
        }
        
        repository.deleteById(id);
        log.info("Grupo de código de flujo de caja eliminado exitosamente con id: {}", id);
    }

    @Override
    @Transactional
    public GrupoCodigoFlujoCajaResponse activate(Long id) {
        log.info("Activando grupo de código de flujo de caja con id: {}", id);
        
        GrupoCodigoFlujoCaja entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Grupo de código de flujo de caja", id));
        
        entity.setFlagEstado("1");
        GrupoCodigoFlujoCaja updated = repository.save(entity);
        
        log.info("Grupo de código de flujo de caja activado exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }

    @Override
    @Transactional
    public GrupoCodigoFlujoCajaResponse deactivate(Long id) {
        log.info("Desactivando grupo de código de flujo de caja con id: {}", id);
        
        GrupoCodigoFlujoCaja entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Grupo de código de flujo de caja", id));
        
        entity.setFlagEstado("0");
        GrupoCodigoFlujoCaja updated = repository.save(entity);
        
        log.info("Grupo de código de flujo de caja desactivado exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }
}
