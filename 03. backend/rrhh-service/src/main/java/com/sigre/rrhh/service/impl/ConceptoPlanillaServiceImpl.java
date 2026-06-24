package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.ConceptoPlanillaResponse;
import com.sigre.rrhh.entity.ConceptoPlanilla;
import com.sigre.rrhh.entity.GrupoConceptosPlanilla;
import com.sigre.rrhh.mapper.ConceptoPlanillaMapper;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.repository.GrupoConceptosPlanillaRepository;
import com.sigre.rrhh.service.ConceptoPlanillaService;
import com.sigre.rrhh.specification.ConceptoPlanillaSpecification;
import com.sigre.rrhh.validation.ConceptoPlanillaValidator;

import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ConceptoPlanillaServiceImpl implements ConceptoPlanillaService {

    private final ConceptoPlanillaRepository repository;
    private final GrupoConceptosPlanillaRepository grupoConceptosPlanillaRepository;
    private final ConceptoPlanillaMapper mapper;
    private final ConceptoPlanillaValidator validator;

    @Override
    @Transactional(readOnly = true)
    public Page<ConceptoPlanillaResponse> listar(String codigo, String nombre, String grupoCalculo, String flagEstado, Pageable pageable) {
        Specification<ConceptoPlanilla> spec = Specification.where(null);

        if (codigo != null && !codigo.isEmpty()) {
            spec = spec.and(ConceptoPlanillaSpecification.conCodigo(codigo));
        }
        if (nombre != null && !nombre.isEmpty()) {
            spec = spec.and(ConceptoPlanillaSpecification.conNombre(nombre));
        }
        if (grupoCalculo != null && !grupoCalculo.isEmpty()) {
            spec = spec.and(ConceptoPlanillaSpecification.conGrupoCalculo(grupoCalculo));
        }
        if (flagEstado != null && !flagEstado.isBlank()) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstado));
        }

        Page<ConceptoPlanilla> page = repository.findAll(spec, pageable);
        return page.map(mapper::toResponse);
    }

    @Override
    public List<ConceptoPlanillaResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Transactional(readOnly = true)
    public ConceptoPlanillaResponse obtenerPorId(Long id) {
        ConceptoPlanilla entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Concepto de planilla", id));
        return mapper.toResponse(entity);
    }

    @Override
    @Transactional
    @Timed("rrhh.conceptoPlanilla.crear")
    public ConceptoPlanillaResponse crear(ConceptoPlanillaCreateRequest request) {
        validator.validarCodigoUnico(request.getCodigo());
        validator.validarGrupoCalculo(request.getGrupoCalculo());

        ConceptoPlanilla entity = mapper.toEntity(request);
        entity.setGrupoConceptosPlanilla(resolverGrupo(request.getGrupoCalculo()));
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        ConceptoPlanilla saved = repository.save(entity);
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    @Timed("rrhh.conceptoPlanilla.actualizar")
    public ConceptoPlanillaResponse actualizar(Long id, ConceptoPlanillaUpdateRequest request) {
        ConceptoPlanilla entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Concepto de planilla", id));

        validator.validarGrupoCalculo(request.getGrupoCalculo());

        mapper.updateEntity(entity, request);
        entity.setGrupoConceptosPlanilla(resolverGrupo(request.getGrupoCalculo()));
        ConceptoPlanilla saved = repository.save(entity);
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    @Timed("rrhh.conceptoPlanilla.activar")
    public ConceptoPlanillaResponse activar(Long id) {
        ConceptoPlanilla entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Concepto de planilla", id));
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.conceptoPlanilla.desactivar")
    public ConceptoPlanillaResponse desactivar(Long id) {
        ConceptoPlanilla entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Concepto de planilla", id));

        validator.validarNoEnUso(id);

        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private GrupoConceptosPlanilla resolverGrupo(String codigoGrupo) {
        return grupoConceptosPlanillaRepository.findByCodigo(codigoGrupo)
            .orElseThrow(() -> new ResourceNotFoundException("Grupo de conceptos de planilla", "codigo", codigoGrupo));
    }
}
