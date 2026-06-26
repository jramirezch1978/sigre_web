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
import java.time.Instant;
import pe.restaurant.rrhh.constants.EstadoCivilConstants;
import pe.restaurant.rrhh.dto.request.EstadoCivilCreateRequest;
import pe.restaurant.rrhh.dto.request.EstadoCivilUpdateRequest;
import pe.restaurant.rrhh.dto.response.EstadoCivilResponse;
import pe.restaurant.rrhh.entity.EstadoCivil;
import pe.restaurant.rrhh.mapper.EstadoCivilMapper;
import pe.restaurant.rrhh.repository.EstadoCivilRepository;
import pe.restaurant.rrhh.specification.EstadoCivilSpecification;
import pe.restaurant.rrhh.service.EstadoCivilService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EstadoCivilServiceImpl implements EstadoCivilService {

    private final EstadoCivilRepository repository;
    private final EstadoCivilMapper mapper;

    @Override @Timed("rrhh.estado_civil.listar")
    public Page<EstadoCivilResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(EstadoCivilSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.estado_civil.obtener")
    public EstadoCivilResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.estado_civil.crear")
    public EstadoCivilResponse crear(EstadoCivilCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setFlagEstado("1");
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.estado_civil.actualizar")
    public EstadoCivilResponse actualizar(Long id, EstadoCivilUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.estadoCivil.desactivar")
    public EstadoCivilResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<EstadoCivilResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override @Transactional @Timed("rrhh.estadoCivil.activar")
    public EstadoCivilResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private EstadoCivil buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("EstadoCivil no encontrado: {}", id);
            return new BusinessException(EstadoCivilConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, EstadoCivilConstants.ERROR_NO_ENCONTRADO);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException(EstadoCivilConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, EstadoCivilConstants.ERROR_CODIGO_DUPLICADO);
        }
    }
}
