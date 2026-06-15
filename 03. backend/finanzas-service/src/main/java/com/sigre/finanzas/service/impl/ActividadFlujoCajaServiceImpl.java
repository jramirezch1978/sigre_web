package com.sigre.finanzas.service.impl;

import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.finanzas.dto.request.ActividadFlujoCajaRequest;
import com.sigre.finanzas.dto.response.ActividadFlujoCajaResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.entity.ActividadFlujoCaja;
import com.sigre.finanzas.mapper.ActividadFlujoCajaMapper;
import com.sigre.finanzas.repository.ActividadFlujoCajaRepository;
import com.sigre.finanzas.service.ActividadFlujoCajaService;
import com.sigre.finanzas.service.FinanzasErrorCodes;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ActividadFlujoCajaServiceImpl implements ActividadFlujoCajaService {

    private final ActividadFlujoCajaRepository repository;
    private final ActividadFlujoCajaMapper mapper;

    @Override
    public PageData<ActividadFlujoCajaResponse> listar(String flagEstado, String codigo, String nombre, Pageable pageable) {
        log.debug("Listando actividades de flujo de caja - estado: {}, codigo: {}, nombre: {}", flagEstado, codigo, nombre);

        Specification<ActividadFlujoCaja> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            } else {
                predicates.add(cb.equal(root.get("flagEstado"), "1"));
            }
            if (codigo != null && !codigo.isBlank()) {
                predicates.add(cb.like(cb.lower(root.get("codigo")), "%" + codigo.toLowerCase() + "%"));
            }
            if (nombre != null && !nombre.isBlank()) {
                predicates.add(cb.like(cb.lower(root.get("nombre")), "%" + nombre.toLowerCase() + "%"));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<ActividadFlujoCaja> entityPage = repository.findAll(spec, pageable);
        return PageData.of(entityPage, entityPage.map(mapper::toResponse).getContent());
    }

    @Override
    public ActividadFlujoCajaResponse findById(Long id) {
        log.debug("Buscando actividad de flujo de caja por id: {}", id);
        ActividadFlujoCaja entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Actividad de flujo de caja", id));

        log.debug("Actividad de flujo de caja encontrada: {}", entity.getCodigo());
        return mapper.toResponse(entity);
    }

    @Override
    @Transactional
    public ActividadFlujoCajaResponse create(ActividadFlujoCajaRequest request) {
        log.info("Creando actividad de flujo de caja con código: {}", request.getCodigo());

        if (repository.existsByCodigo(request.getCodigo())) {
            throw new BusinessException(
                    "Ya existe una actividad de flujo de caja con el código: " + request.getCodigo(),
                    HttpStatus.CONFLICT,
                    FinanzasErrorCodes.ACTIVIDAD_FLUJO_CAJA_CODIGO_DUPLICADO
            );
        }

        ActividadFlujoCaja entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        ActividadFlujoCaja saved = repository.save(entity);

        log.info("Actividad de flujo de caja creada exitosamente con id: {}", saved.getId());
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    public ActividadFlujoCajaResponse update(Long id, ActividadFlujoCajaRequest request) {
        log.info("Actualizando actividad de flujo de caja con id: {}", id);

        ActividadFlujoCaja existing = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Actividad de flujo de caja", id));

        if (!existing.getCodigo().equals(request.getCodigo()) &&
                repository.existsByCodigo(request.getCodigo())) {
            throw new BusinessException(
                    "Ya existe una actividad de flujo de caja con el código: " + request.getCodigo(),
                    HttpStatus.CONFLICT,
                    FinanzasErrorCodes.ACTIVIDAD_FLUJO_CAJA_CODIGO_DUPLICADO
            );
        }

        mapper.updateEntity(request, existing);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        ActividadFlujoCaja updated = repository.save(existing);

        log.info("Actividad de flujo de caja actualizada exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }

    @Override
    @Transactional
    public ActividadFlujoCajaResponse activate(Long id) {
        log.info("Activando actividad de flujo de caja con id: {}", id);

        ActividadFlujoCaja entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Actividad de flujo de caja", id));

        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        ActividadFlujoCaja updated = repository.save(entity);

        log.info("Actividad de flujo de caja activada exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }

    @Override
    @Transactional
    public ActividadFlujoCajaResponse deactivate(Long id) {
        log.info("Desactivando actividad de flujo de caja con id: {}", id);

        ActividadFlujoCaja entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Actividad de flujo de caja", id));

        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        ActividadFlujoCaja updated = repository.save(entity);

        log.info("Actividad de flujo de caja desactivada exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }
}
