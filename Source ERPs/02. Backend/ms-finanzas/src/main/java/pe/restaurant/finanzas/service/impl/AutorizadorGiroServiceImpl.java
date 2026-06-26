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
import pe.restaurant.finanzas.dto.request.AutorizadorGiroRequest;
import pe.restaurant.finanzas.dto.response.AutorizadorGiroResponse;
import pe.restaurant.finanzas.entity.AutorizadorGiro;
import pe.restaurant.finanzas.mapper.AutorizadorGiroMapper;
import pe.restaurant.finanzas.repository.AutorizadorGiroRepository;
import pe.restaurant.finanzas.service.AutorizadorGiroService;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AutorizadorGiroServiceImpl implements AutorizadorGiroService {

    private final AutorizadorGiroRepository repository;
    private final AutorizadorGiroMapper mapper;

    @Override
    public Page<AutorizadorGiroResponse> findAll(Pageable pageable) {
        log.debug("Listando autorizadores de giro con paginación");
        Page<AutorizadorGiro> entityPage = repository.findAll(pageable);
        return entityPage.map(mapper::toResponse);
    }

    @Override
    public AutorizadorGiroResponse findById(Long id) {
        log.debug("Buscando autorizador de giro por id: {}", id);
        AutorizadorGiro entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Autorizador de giro", id));
        
        log.debug("Autorizador de giro encontrado: usuarioId={}, centrosCostoId={}", 
                entity.getUsuarioId(), entity.getCentrosCostoId());
        return mapper.toResponse(entity);
    }

    @Override
    @Transactional
    public AutorizadorGiroResponse create(AutorizadorGiroRequest request) {
        Long usuarioIdToken = TenantContext.getUsuarioId();
        log.info("Creando autorizador de giro para usuario: {} en centro de costo: {}", 
                usuarioIdToken, request.getCentrosCostoId());
        
        // Validar unicidad (usuarioId ya está validado en el token)
        if (repository.existsByCentrosCostoIdAndUsuarioId(request.getCentrosCostoId(), usuarioIdToken)) {
            throw new BusinessException(
                    "Ya existe un autorizador de giro para este usuario y centro de costo",
                    HttpStatus.CONFLICT,
                    "FIN-002"
            );
        }
        
        AutorizadorGiro entity = mapper.toEntity(request);
        entity.setUsuarioId(usuarioIdToken); // Usar usuarioId del token
        entity.setCreatedBy(usuarioIdToken);
        AutorizadorGiro saved = repository.save(entity);
        
        log.info("Autorizador de giro creado exitosamente con id: {}", saved.getId());
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    public AutorizadorGiroResponse update(Long id, AutorizadorGiroRequest request) {
        log.info("Actualizando autorizador de giro con id: {}", id);
        
        AutorizadorGiro existing = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Autorizador de giro", id));
        
        Long usuarioIdToken = TenantContext.getUsuarioId();
        
        // Validar unicidad (usuarioId ya está validado en el token)
        if ((!existing.getCentrosCostoId().equals(request.getCentrosCostoId()) || 
             !existing.getUsuarioId().equals(usuarioIdToken)) && 
            repository.existsByCentrosCostoIdAndUsuarioIdAndIdNot(
                    request.getCentrosCostoId(), usuarioIdToken, id)) {
            throw new BusinessException(
                    "Ya existe un autorizador de giro para este usuario y centro de costo",
                    HttpStatus.CONFLICT,
                    "FIN-002"
            );
        }
        
        
        mapper.updateEntity(request, existing);
        existing.setUsuarioId(usuarioIdToken); // Usar usuarioId del token
        existing.setUpdatedBy(usuarioIdToken);
        AutorizadorGiro updated = repository.save(existing);
        
        log.info("Autorizador de giro actualizado exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        log.info("Eliminando autorizador de giro con id: {}", id);
        
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("Autorizador de giro", id);
        }
        
        repository.deleteById(id);
        log.info("Autorizador de giro eliminado exitosamente con id: {}", id);
    }

    @Override
    @Transactional
    public AutorizadorGiroResponse activate(Long id) {
        log.info("Activando autorizador de giro con id: {}", id);
        
        AutorizadorGiro entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Autorizador de giro", id));
        
        entity.setActivo(true);
        AutorizadorGiro updated = repository.save(entity);
        
        log.info("Autorizador de giro activado exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }

    @Override
    @Transactional
    public AutorizadorGiroResponse deactivate(Long id) {
        log.info("Desactivando autorizador de giro con id: {}", id);
        
        AutorizadorGiro entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Autorizador de giro", id));
        
        entity.setActivo(false);
        AutorizadorGiro updated = repository.save(entity);
        
        log.info("Autorizador de giro desactivado exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }

    @Override
    public List<AutorizadorGiroResponse> findByCentroCosto(Long centrosCostoId) {
        log.debug("Buscando autorizadores de giro por centro de costo: {}", centrosCostoId);
        return repository.findByCentrosCostoIdAndActivo(centrosCostoId, true)
                .stream()
                .map(mapper::toResponse)
                .toList();
    }

    @Override
    public List<AutorizadorGiroResponse> findActivosByCentroCosto(Long centrosCostoId) {
        log.debug("Buscando autorizadores de giro activos por centro de costo: {}", centrosCostoId);
        return repository.findAutorizadoresActivosPorCentroCosto(centrosCostoId)
                .stream()
                .map(mapper::toResponse)
                .toList();
    }
}
