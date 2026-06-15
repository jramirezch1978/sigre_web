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
import com.sigre.common.security.TenantContext;

import java.time.Instant;
import com.sigre.rrhh.constants.RegimenLaboralConstants;
import com.sigre.rrhh.dto.request.RegimenLaboralCreateRequest;
import com.sigre.rrhh.dto.request.RegimenLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.RegimenLaboralResponse;
import com.sigre.rrhh.entity.RegimenLaboral;
import com.sigre.rrhh.mapper.RegimenLaboralMapper;
import com.sigre.rrhh.repository.RegimenLaboralRepository;
import com.sigre.rrhh.specification.RegimenLaboralSpecification;
import com.sigre.rrhh.service.RegimenLaboralService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RegimenLaboralServiceImpl implements RegimenLaboralService {

    private final RegimenLaboralRepository repository;
    private final RegimenLaboralMapper mapper;

    @Override @Timed("rrhh.regimen_laboral.listar")
    public Page<RegimenLaboralResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(RegimenLaboralSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.regimen_laboral.obtener")
    public RegimenLaboralResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.regimen_laboral.crear")
    public RegimenLaboralResponse crear(RegimenLaboralCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setFlagEstado("1");
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.regimen_laboral.actualizar")
    public RegimenLaboralResponse actualizar(Long id, RegimenLaboralUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.regimenLaboral.desactivar")
    public RegimenLaboralResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<RegimenLaboralResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override @Transactional @Timed("rrhh.regimenLaboral.activar")
    public RegimenLaboralResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private RegimenLaboral buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("RegimenLaboral no encontrado: {}", id);
            return new BusinessException(RegimenLaboralConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, RegimenLaboralConstants.ERROR_NO_ENCONTRADO);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException(RegimenLaboralConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, RegimenLaboralConstants.ERROR_CODIGO_DUPLICADO);
        }
    }
}
