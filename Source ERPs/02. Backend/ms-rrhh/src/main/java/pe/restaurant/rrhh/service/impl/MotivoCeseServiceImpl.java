package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.constants.MotivoCeseConstants;
import pe.restaurant.rrhh.dto.request.MotivoCeseCreateRequest;
import pe.restaurant.rrhh.dto.request.MotivoCeseUpdateRequest;
import pe.restaurant.rrhh.dto.response.MotivoCeseResponse;
import pe.restaurant.rrhh.entity.MotivoCese;
import pe.restaurant.rrhh.mapper.MotivoCeseMapper;
import pe.restaurant.rrhh.repository.MotivoCeseRepository;
import pe.restaurant.rrhh.specification.MotivoCeseSpecification;
import pe.restaurant.rrhh.service.MotivoCeseService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MotivoCeseServiceImpl implements MotivoCeseService {
    private final MotivoCeseRepository repository;
    private final MotivoCeseMapper mapper;

    @Override @Timed("rrhh.motivo_cese.listar")
    public Page<MotivoCeseResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(MotivoCeseSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public MotivoCeseResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.motivo_cese.crear")
    public MotivoCeseResponse crear(MotivoCeseCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(MotivoCeseConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, MotivoCeseConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.motivo_cese.actualizar")
    public MotivoCeseResponse actualizar(Long id, MotivoCeseUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public MotivoCeseResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public MotivoCeseResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<MotivoCeseResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private MotivoCese buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                MotivoCeseConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, MotivoCeseConstants.ERROR_NO_ENCONTRADO));
    }
}
