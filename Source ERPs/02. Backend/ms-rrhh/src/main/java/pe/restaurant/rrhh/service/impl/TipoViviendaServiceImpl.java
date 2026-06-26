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
import pe.restaurant.rrhh.constants.TipoViviendaConstants;
import pe.restaurant.rrhh.dto.request.TipoViviendaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoViviendaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoViviendaResponse;
import pe.restaurant.rrhh.entity.TipoVivienda;
import pe.restaurant.rrhh.mapper.TipoViviendaMapper;
import pe.restaurant.rrhh.repository.TipoViviendaRepository;
import pe.restaurant.rrhh.specification.TipoViviendaSpecification;
import pe.restaurant.rrhh.service.TipoViviendaService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoViviendaServiceImpl implements TipoViviendaService {
    private final TipoViviendaRepository repository;
    private final TipoViviendaMapper mapper;

    @Override @Timed("rrhh.tipo_vivienda.listar")
    public Page<TipoViviendaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoViviendaSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public TipoViviendaResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_vivienda.crear")
    public TipoViviendaResponse crear(TipoViviendaCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(TipoViviendaConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoViviendaConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_vivienda.actualizar")
    public TipoViviendaResponse actualizar(Long id, TipoViviendaUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public TipoViviendaResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public TipoViviendaResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<TipoViviendaResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private TipoVivienda buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                TipoViviendaConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoViviendaConstants.ERROR_NO_ENCONTRADO));
    }
}
