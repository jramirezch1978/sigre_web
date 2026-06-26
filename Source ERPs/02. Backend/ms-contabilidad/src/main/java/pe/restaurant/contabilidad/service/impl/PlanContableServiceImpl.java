package pe.restaurant.contabilidad.service.impl;

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
import pe.restaurant.contabilidad.dto.request.PlanContableRequest;
import pe.restaurant.contabilidad.dto.response.PlanContableResponse;
import pe.restaurant.contabilidad.entity.PlanContable;
import pe.restaurant.contabilidad.mapper.PlanContableMapper;
import pe.restaurant.contabilidad.repository.PlanContableRepository;
import pe.restaurant.contabilidad.service.PlanContableService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
public class PlanContableServiceImpl implements PlanContableService {

    private final PlanContableRepository repository;
    private final PlanContableMapper mapper;

    @Override
    @Transactional(readOnly = true)
    public Page<PlanContableResponse> listar(String codigo, Integer anio, String flagEstado, Pageable pageable) {
        return repository.buscar(
                codigo != null && !codigo.isBlank() ? codigo : null,
                anio,
                flagEstado != null && !flagEstado.isBlank() ? flagEstado : null,
                pageable
        ).map(mapper::toResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public PlanContableResponse obtenerPorId(Long id) {
        return mapper.toResponse(repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Plan contable", id)));
    }

    @Override
    @Transactional
    public PlanContableResponse crear(PlanContableRequest request) {
        if (repository.findByCodigo(request.getCodigo()).isPresent()) {
            throw new BusinessException(
                    "Ya existe un plan contable con el código " + request.getCodigo(),
                    HttpStatus.CONFLICT, "PLAN_CONTABLE_DUPLICADO");
        }
        PlanContable entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        entity = repository.save(entity);
        log.info("Plan contable creado: {} - {}", entity.getCodigo(), entity.getNombre());
        return mapper.toResponse(entity);
    }

    @Override
    @Transactional
    public PlanContableResponse actualizar(Long id, PlanContableRequest request) {
        PlanContable entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Plan contable", id));

        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede modificar un plan contable inactivo",
                    HttpStatus.CONFLICT, "PLAN_CONTABLE_ESTADO_INVALIDO");
        }

        mapper.updateEntity(entity, request);
        entity = repository.save(entity);
        log.info("Plan contable actualizado: {} - {}", entity.getCodigo(), entity.getNombre());
        return mapper.toResponse(entity);
    }

    @Override
    @Transactional
    public PlanContableResponse cambiarEstado(Long id) {
        PlanContable entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Plan contable", id));
        String nuevoEstado = "1".equals(entity.getFlagEstado()) ? "0" : "1";
        entity.setFlagEstado(nuevoEstado);
        entity = repository.save(entity);
        log.info("Plan contable {} cambiado a estado {}", id, nuevoEstado);
        return mapper.toResponse(entity);
    }
}
