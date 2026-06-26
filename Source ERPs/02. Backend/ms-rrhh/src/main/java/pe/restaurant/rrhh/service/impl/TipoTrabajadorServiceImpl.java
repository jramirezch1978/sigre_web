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
import pe.restaurant.rrhh.constants.TipoTrabajadorConstants;
import pe.restaurant.rrhh.dto.request.TipoTrabajadorCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoTrabajadorUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoTrabajadorResponse;
import pe.restaurant.rrhh.entity.TipoTrabajador;
import pe.restaurant.rrhh.mapper.TipoTrabajadorMapper;
import pe.restaurant.rrhh.repository.TipoTrabajadorRepository;
import pe.restaurant.rrhh.specification.TipoTrabajadorSpecification;
import pe.restaurant.rrhh.service.TipoTrabajadorService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoTrabajadorServiceImpl implements TipoTrabajadorService {
    private final TipoTrabajadorRepository repository;
    private final TipoTrabajadorMapper mapper;

    @Override @Timed("rrhh.tipo_trabajador.listar")
    public Page<TipoTrabajadorResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoTrabajadorSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public TipoTrabajadorResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_trabajador.crear")
    public TipoTrabajadorResponse crear(TipoTrabajadorCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(TipoTrabajadorConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoTrabajadorConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_trabajador.actualizar")
    public TipoTrabajadorResponse actualizar(Long id, TipoTrabajadorUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public TipoTrabajadorResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public TipoTrabajadorResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<TipoTrabajadorResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private TipoTrabajador buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                TipoTrabajadorConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoTrabajadorConstants.ERROR_NO_ENCONTRADO));
    }
}
