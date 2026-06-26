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
import pe.restaurant.rrhh.constants.TipoTrabajadorRtpsConstants;
import pe.restaurant.rrhh.dto.request.TipoTrabajadorRtpsCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoTrabajadorRtpsUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoTrabajadorRtpsResponse;
import pe.restaurant.rrhh.entity.TipoTrabajadorRtps;
import pe.restaurant.rrhh.mapper.TipoTrabajadorRtpsMapper;
import pe.restaurant.rrhh.repository.TipoTrabajadorRtpsRepository;
import pe.restaurant.rrhh.specification.TipoTrabajadorRtpsSpecification;
import pe.restaurant.rrhh.service.TipoTrabajadorRtpsService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoTrabajadorRtpsServiceImpl implements TipoTrabajadorRtpsService {
    private final TipoTrabajadorRtpsRepository repository;
    private final TipoTrabajadorRtpsMapper mapper;

    @Override @Timed("rrhh.tipo_trabajador_rtps.listar")
    public Page<TipoTrabajadorRtpsResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoTrabajadorRtpsSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public TipoTrabajadorRtpsResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_trabajador_rtps.crear")
    public TipoTrabajadorRtpsResponse crear(TipoTrabajadorRtpsCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(TipoTrabajadorRtpsConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoTrabajadorRtpsConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_trabajador_rtps.actualizar")
    public TipoTrabajadorRtpsResponse actualizar(Long id, TipoTrabajadorRtpsUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public TipoTrabajadorRtpsResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public TipoTrabajadorRtpsResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<TipoTrabajadorRtpsResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private TipoTrabajadorRtps buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                TipoTrabajadorRtpsConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoTrabajadorRtpsConstants.ERROR_NO_ENCONTRADO));
    }
}
