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
import pe.restaurant.rrhh.constants.OcupacionRtpsConstants;
import pe.restaurant.rrhh.dto.request.OcupacionRtpsCreateRequest;
import pe.restaurant.rrhh.dto.request.OcupacionRtpsUpdateRequest;
import pe.restaurant.rrhh.dto.response.OcupacionRtpsResponse;
import pe.restaurant.rrhh.entity.OcupacionRtps;
import pe.restaurant.rrhh.mapper.OcupacionRtpsMapper;
import pe.restaurant.rrhh.repository.OcupacionRtpsRepository;
import pe.restaurant.rrhh.specification.OcupacionRtpsSpecification;
import pe.restaurant.rrhh.service.OcupacionRtpsService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OcupacionRtpsServiceImpl implements OcupacionRtpsService {
    private final OcupacionRtpsRepository repository;
    private final OcupacionRtpsMapper mapper;

    @Override @Timed("rrhh.ocupacion_rtps.listar")
    public Page<OcupacionRtpsResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(OcupacionRtpsSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public OcupacionRtpsResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.ocupacion_rtps.crear")
    public OcupacionRtpsResponse crear(OcupacionRtpsCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(OcupacionRtpsConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, OcupacionRtpsConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.ocupacion_rtps.actualizar")
    public OcupacionRtpsResponse actualizar(Long id, OcupacionRtpsUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public OcupacionRtpsResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public OcupacionRtpsResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<OcupacionRtpsResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private OcupacionRtps buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                OcupacionRtpsConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, OcupacionRtpsConstants.ERROR_NO_ENCONTRADO));
    }
}
