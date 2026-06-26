package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfAccesorio;
import pe.restaurant.activos.repository.AfAccesorioRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.AfAccesorioService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfAccesorioServiceImpl implements AfAccesorioService {

    private final AfAccesorioRepository repository;
    private final AfMaestroRepository maestroRepository;

    @Override
    public AfAccesorio findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Accesorio", id));
    }

    @Override
    public List<AfAccesorio> findByMaestro(Long afMaestroId) {
        maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new ResourceNotFoundException("Activo", afMaestroId));
        return repository.findByAfMaestroIdOrderByFechaInstalacionDesc(afMaestroId);
    }

    @Override
    @Transactional
    public AfAccesorio create(AfAccesorio entity) {
        maestroRepository.findById(entity.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", entity.getAfMaestroId()));
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public AfAccesorio update(Long id, AfAccesorio entity) {
        AfAccesorio existing = findById(id);
        existing.setDescripcion(entity.getDescripcion());
        existing.setCosto(entity.getCosto());
        existing.setFechaInstalacion(entity.getFechaInstalacion());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        repository.delete(findById(id));
    }
}
