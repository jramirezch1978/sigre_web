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
import pe.restaurant.rrhh.constants.TipoSangreConstants;
import pe.restaurant.rrhh.dto.request.TipoSangreCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoSangreUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoSangreResponse;
import pe.restaurant.rrhh.entity.TipoSangre;
import pe.restaurant.rrhh.mapper.TipoSangreMapper;
import pe.restaurant.rrhh.repository.TipoSangreRepository;
import pe.restaurant.rrhh.specification.TipoSangreSpecification;
import pe.restaurant.rrhh.service.TipoSangreService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoSangreServiceImpl implements TipoSangreService {
    private final TipoSangreRepository repository;
    private final TipoSangreMapper mapper;

    @Override @Timed("rrhh.tipo_sangre.listar")
    public Page<TipoSangreResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoSangreSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public TipoSangreResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_sangre.crear")
    public TipoSangreResponse crear(TipoSangreCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(TipoSangreConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoSangreConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_sangre.actualizar")
    public TipoSangreResponse actualizar(Long id, TipoSangreUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public TipoSangreResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public TipoSangreResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<TipoSangreResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private TipoSangre buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                TipoSangreConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoSangreConstants.ERROR_NO_ENCONTRADO));
    }
}
