package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.GanDescVariableImportarRequest;
import com.sigre.rrhh.dto.request.GanDescVariableRequest;
import com.sigre.rrhh.dto.response.GanDescVariableResponse;
import com.sigre.rrhh.entity.GanDescVariable;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.mapper.GanDescVariableMapper;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.repository.GanDescVariableRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.GanDescVariableService;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class GanDescVariableServiceImpl implements GanDescVariableService {

    private final GanDescVariableRepository repository;
    private final TrabajadorRepository trabajadorRepo;
    private final ConceptoPlanillaRepository conceptoPlanillaRepo;
    private final GanDescVariableMapper mapper;

    @Override
    @Transactional(readOnly = true)
    public Page<GanDescVariableResponse> listar(Long trabajadorId, Long conceptoId, Integer anio,
                                                  Integer mes, Long tipoPlanillaId, Pageable pageable) {
        return repository.findWithFilters(trabajadorId, conceptoId, anio, mes, tipoPlanillaId, pageable)
                .map(mapper::toResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public GanDescVariableResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override
    @Timed("rrhh.ganDescVariable.crear")
    public GanDescVariableResponse crear(GanDescVariableRequest request) {
        validarTrabajadorActivo(request.getTrabajadorId());
        validarConceptoExiste(request.getConceptoId());
        validarTipoPlanilla(request.getTipoPlanillaId());

        GanDescVariable entity = GanDescVariable.builder()
                .trabajadorId(request.getTrabajadorId())
                .fecMovim(request.getFecMovim())
                .conceptoId(request.getConceptoId())
                .nroDoc(request.getNroDoc())
                .impVar(request.getImpVar())
                .centrosCostoId(request.getCentrosCostoId())
                .cantLabor(request.getCantLabor())
                .nroDias(request.getNroDias())
                .nroHoras(request.getNroHoras())
                .nroCuotas(request.getNroCuotas())
                .tipoPlanillaId(request.getTipoPlanillaId())
                .build();

        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        GanDescVariable saved = repository.save(entity);
        return mapper.toResponse(saved);
    }

    @Override
    @Timed("rrhh.ganDescVariable.actualizar")
    public GanDescVariableResponse actualizar(Long id, GanDescVariableRequest request) {
        GanDescVariable existing = buscarOrThrow(id);
        validarTrabajadorActivo(request.getTrabajadorId());
        validarConceptoExiste(request.getConceptoId());
        validarTipoPlanilla(request.getTipoPlanillaId());

        existing.setTrabajadorId(request.getTrabajadorId());
        existing.setFecMovim(request.getFecMovim());
        existing.setConceptoId(request.getConceptoId());
        existing.setNroDoc(request.getNroDoc());
        existing.setImpVar(request.getImpVar());
        existing.setCentrosCostoId(request.getCentrosCostoId());
        existing.setCantLabor(request.getCantLabor());
        existing.setNroDias(request.getNroDias());
        existing.setNroHoras(request.getNroHoras());
        existing.setNroCuotas(request.getNroCuotas());
        existing.setTipoPlanillaId(request.getTipoPlanillaId());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());

        GanDescVariable saved = repository.save(existing);
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    @Timed("rrhh.ganDescVariable.importar")
    public List<GanDescVariableResponse> importar(GanDescVariableImportarRequest request) {
        List<GanDescVariableResponse> results = new ArrayList<>();
        for (GanDescVariableImportarRequest.GanDescVariableRow row : request.registros()) {
            GanDescVariable entity = new GanDescVariable();
            entity.setTrabajadorId(row.trabajadorId());
            entity.setFecMovim(row.fecMovim());
            entity.setConceptoId(row.conceptoId());
            entity.setImpVar(row.impVar());
            entity.setTipoPlanillaId(row.tipoPlanillaId());
            entity.setCreatedBy(TenantContext.getUsuarioId());
            entity.setFecCreacion(Instant.now());
            results.add(mapper.toResponse(repository.save(entity)));
        }
        return results;
    }

    @Override
    @Timed("rrhh.ganDescVariable.eliminar")
    public void eliminar(Long id) {
        GanDescVariable existing = buscarOrThrow(id);
        repository.delete(existing);
    }

    private GanDescVariable buscarOrThrow(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("GanDescVariable", id));
    }

    private void validarTrabajadorActivo(Long trabajadorId) {
        Trabajador t = trabajadorRepo.findById(trabajadorId)
                .orElseThrow(() -> new BusinessException(
                        "Trabajador no encontrado con ID: " + trabajadorId,
                        HttpStatus.UNPROCESSABLE_ENTITY, "RH-GV-001"));
        if (!"1".equals(t.getFlagEstado())) {
            throw new BusinessException(
                    "El trabajador con ID " + trabajadorId + " no está activo",
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-GV-001");
        }
    }

    private void validarConceptoExiste(Long conceptoId) {
        if (!conceptoPlanillaRepo.existsById(conceptoId)) {
            throw new BusinessException(
                    "Concepto de planilla no encontrado con ID: " + conceptoId,
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-GV-002");
        }
    }

    private void validarTipoPlanilla(Long tipoPlanillaId) {
        if (tipoPlanillaId != null && !repository.existsTipoPlanillaById(tipoPlanillaId)) {
            throw new BusinessException(
                    "Tipo de planilla no encontrado con ID: " + tipoPlanillaId,
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-GV-002");
        }
    }
}
