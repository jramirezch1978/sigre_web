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
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.TipoSuspensionLaboralCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoSuspensionLaboralUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoSuspensionLaboralResponse;
import pe.restaurant.rrhh.entity.TipoSuspensionLaboral;
import pe.restaurant.rrhh.mapper.TipoSuspensionLaboralMapper;
import pe.restaurant.rrhh.repository.TipoSuspensionLaboralRepository;
import pe.restaurant.rrhh.service.TipoSuspensionLaboralService;
import pe.restaurant.rrhh.specification.TipoSuspensionLaboralSpecification;
import java.time.Instant;
import pe.restaurant.rrhh.validation.TipoSuspensionLaboralValidator;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoSuspensionLaboralServiceImpl implements TipoSuspensionLaboralService {

    private final TipoSuspensionLaboralRepository repository;
    private final TipoSuspensionLaboralMapper mapper;
    private final TipoSuspensionLaboralValidator validator;

    @Override
    @Timed(value = "rrhh.tipoSuspensionLaboral.listar")
    public Page<TipoSuspensionLaboralResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        var spec = TipoSuspensionLaboralSpecification.filtros(codigo, nombre, flagEstado);
        return repository.findAll(spec, pageable).map(mapper::toResponse);
    }

    @Override
    @Timed(value = "rrhh.tipoSuspensionLaboral.obtener")
    public TipoSuspensionLaboralResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.tipoSuspensionLaboral.crear")
    public TipoSuspensionLaboralResponse crear(TipoSuspensionLaboralCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validator.validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.tipoSuspensionLaboral.actualizar")
    public TipoSuspensionLaboralResponse actualizar(Long id, TipoSuspensionLaboralUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        return mapper.toResponse(repository.save(existing));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.tipoSuspensionLaboral.desactivar")
    public TipoSuspensionLaboralResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        validator.validarNoEnUsoEnPermisos(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<TipoSuspensionLaboralResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Transactional
    @Timed(value = "rrhh.tipoSuspensionLaboral.activar")
    public TipoSuspensionLaboralResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private TipoSuspensionLaboral buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Tipo suspensión laboral no encontrado: {}", id);
            return new ResourceNotFoundException("TipoSuspensionLaboral", id);
        });
    }
}
