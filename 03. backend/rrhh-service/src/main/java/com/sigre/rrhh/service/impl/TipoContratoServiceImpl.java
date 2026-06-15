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
import com.sigre.rrhh.constants.TipoContratoConstants;
import com.sigre.rrhh.dto.request.TipoContratoCreateRequest;
import com.sigre.rrhh.dto.request.TipoContratoUpdateRequest;
import com.sigre.rrhh.dto.response.TipoContratoResponse;
import com.sigre.rrhh.entity.TipoContrato;
import com.sigre.rrhh.mapper.TipoContratoMapper;
import com.sigre.rrhh.repository.TipoContratoRepository;
import com.sigre.rrhh.specification.TipoContratoSpecification;
import com.sigre.rrhh.service.TipoContratoService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoContratoServiceImpl implements TipoContratoService {

    private final TipoContratoRepository repository;
    private final TipoContratoMapper mapper;

    @Override @Timed("rrhh.tipo_contrato.listar")
    public Page<TipoContratoResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoContratoSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.tipo_contrato.obtener")
    public TipoContratoResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_contrato.crear")
    public TipoContratoResponse crear(TipoContratoCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_contrato.actualizar")
    public TipoContratoResponse actualizar(Long id, TipoContratoUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.tipoContrato.desactivar")
    public TipoContratoResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<TipoContratoResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override @Transactional @Timed("rrhh.tipoContrato.activar")
    public TipoContratoResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private TipoContrato buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("TipoContrato no encontrado: {}", id);
            return new BusinessException(TipoContratoConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoContratoConstants.ERROR_NO_ENCONTRADO);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException(TipoContratoConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoContratoConstants.ERROR_CODIGO_DUPLICADO);
        }
    }
}
