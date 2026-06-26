package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfRevaluacion;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfRevaluacionRepository;
import pe.restaurant.activos.service.AfRevaluacionService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfRevaluacionServiceImpl implements AfRevaluacionService {

    private final AfRevaluacionRepository repository;
    private final AfMaestroRepository maestroRepository;

    @Override
    public Page<AfRevaluacion> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public AfRevaluacion findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Revaluacion", id));
    }

    @Override
    public List<AfRevaluacion> findByMaestro(Long afMaestroId) {
        maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new ResourceNotFoundException("Activo", afMaestroId));
        return repository.findByAfMaestroIdOrderByFechaDesc(afMaestroId);
    }

    @Override
    @Transactional
    public AfRevaluacion create(AfRevaluacion entity) {
        maestroRepository.findById(entity.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", entity.getAfMaestroId()));
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public AfRevaluacion update(Long id, AfRevaluacion entity) {
        AfRevaluacion existing = findById(id);
        existing.setFecha(entity.getFecha());
        existing.setValorAnterior(entity.getValorAnterior());
        existing.setValorNuevo(entity.getValorNuevo());
        existing.setSustento(entity.getSustento());
        existing.setPeritoId(entity.getPeritoId());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        repository.delete(findById(id));
    }
}
