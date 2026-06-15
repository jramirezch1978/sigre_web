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
import com.sigre.rrhh.constants.PeriodoCtsConstants;
import com.sigre.rrhh.dto.request.PeriodoCtsCreateRequest;
import com.sigre.rrhh.dto.request.PeriodoCtsUpdateRequest;
import com.sigre.rrhh.dto.response.PeriodoCtsResponse;
import com.sigre.rrhh.entity.PeriodoCts;
import com.sigre.rrhh.mapper.PeriodoCtsMapper;
import com.sigre.rrhh.repository.PeriodoCtsRepository;
import com.sigre.rrhh.service.PeriodoCtsService;
import com.sigre.rrhh.specification.PeriodoCtsSpecification;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PeriodoCtsServiceImpl implements PeriodoCtsService {

    private final PeriodoCtsRepository repository;
    private final PeriodoCtsMapper mapper;

    @Override @Timed("rrhh.periodoCts.listar")
    public Page<PeriodoCtsResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(PeriodoCtsSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.periodoCts.obtener")
    public PeriodoCtsResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.periodoCts.crear")
    public PeriodoCtsResponse crear(PeriodoCtsCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.periodoCts.actualizar")
    public PeriodoCtsResponse actualizar(Long id, PeriodoCtsUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.periodoCts.desactivar")
    public PeriodoCtsResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<PeriodoCtsResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override @Transactional @Timed("rrhh.periodoCts.activar")
    public PeriodoCtsResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private PeriodoCts buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Período CTS no encontrado: {}", id);
            return new BusinessException(PeriodoCtsConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, PeriodoCtsConstants.ERROR_NO_ENCONTRADO);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException(PeriodoCtsConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, PeriodoCtsConstants.ERROR_CODIGO_DUPLICADO);
        }
    }
}
