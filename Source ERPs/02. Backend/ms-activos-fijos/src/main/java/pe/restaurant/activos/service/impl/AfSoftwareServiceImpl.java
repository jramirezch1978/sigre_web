package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfSoftware;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfSoftwareRepository;
import pe.restaurant.activos.service.AfSoftwareService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfSoftwareServiceImpl implements AfSoftwareService {

    private final AfSoftwareRepository repository;
    private final AfMaestroRepository maestroRepository;

    @Override
    public Page<AfSoftware> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public AfSoftware findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Software", id));
    }

    @Override
    public List<AfSoftware> findByMaestro(Long afMaestroId) {
        maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new ResourceNotFoundException("Activo", afMaestroId));
        return repository.findByAfMaestroIdOrderByFechaVigenciaFinDesc(afMaestroId);
    }

    @Override
    @Transactional
    public AfSoftware create(AfSoftware entity) {
        maestroRepository.findById(entity.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", entity.getAfMaestroId()));
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public AfSoftware update(Long id, AfSoftware entity) {
        AfSoftware existing = findById(id);
        existing.setLicencia(entity.getLicencia());
        existing.setProveedorSoftware(entity.getProveedorSoftware());
        existing.setFechaVigenciaIni(entity.getFechaVigenciaIni());
        existing.setFechaVigenciaFin(entity.getFechaVigenciaFin());
        existing.setSoporte(entity.getSoporte());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        repository.delete(findById(id));
    }
}
